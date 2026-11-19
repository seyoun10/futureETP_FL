import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/access_key.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/settings/device_settings.dart';
import 'package:futureetp/core/settings/display_settings.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/display_store.dart';
import '../../helpers/fake_http.dart';

final _fixture = jsonDecode(
  File('test/contract/fixtures/settings.json').readAsStringSync(),
) as Map<String, dynamic>;

/// 기기 설정 서버 흉내. 서버 locale은 [serverLocale]에서 시작해 PATCH로 바뀐다.
/// [patchFails]면 PATCH에 그 에러 코드로 응답한다.
class _Server {
  new({this.serverLocale = 'ko', this.patchFails});

  String serverLocale;
  final (String, int)? patchFails;

  final patches = <Map<String, dynamic>>[];

  late final FakeHttpAdapter adapter = FakeHttpAdapter((req) {
    if (req.method == 'PATCH') {
      // 어댑터가 본문을 handler 전에 기록한다
      final body = jsonDecode(adapter.sentBodies.last) as Map<String, dynamic>;
      patches.add(body);
      if (patchFails case (final code, final status)) {
        return FakeResponse.fail(code, status);
      }
      serverLocale = body['locale'] as String? ?? serverLocale;
    }
    return FakeResponse.ok({..._fixture, 'locale': serverLocale});
  });
}

Future<ProviderContainer> _container(
  _Server server, {
  Locale device = const Locale('en', 'US'),
}) async {
  final store = await openTestDisplayStore();
  final container = ProviderContainer(
    overrides: [
      displaySettingsStoreProvider.overrideWithValue(store),
      deviceLocaleProvider.overrideWithValue(device),
      storedAccessKeyProvider.overrideWithValue('stored-key'),
      apiClientProvider.overrideWithValue(
        ApiClient(
          Dio(BaseOptions(baseUrl: 'http://test/v1'))
            ..httpClientAdapter = server.adapter,
          accessToken: () async => 'stored-key',
          deviceId: () async => '3f2c1a9e-8b7d-4c6e-9f1a-2b3c4d5e6f70',
        ),
      ),
    ],
  );
  addTearDown(container.dispose);
  container.listen(deviceSettingsSyncProvider, (_, _) {});
  await pumpEventQueue();
  return container;
}

void main() {
  test('앱 언어가 서버 locale과 다르면 한 번 PATCH하고 결과를 상태로 둔다', () async {
    final server = _Server();
    final c = await _container(server);
    expect(server.patches, [
      {'locale': 'en'},
    ]);
    expect(c.read(deviceSettingsProvider).value?.locale, AppLanguage.en);
  });

  test('같으면 보내지 않는다', () async {
    final server = _Server();
    await _container(server, device: const Locale('ko', 'KR'));
    expect(server.patches, isEmpty);
    expect(server.adapter.requests, hasLength(1));
  });

  test('실패한 값은 다시 받아도 되풀이하지 않는다', () async {
    final server = _Server(patchFails: ('INTERNAL', 500));
    final c = await _container(server);
    expect(server.patches, hasLength(1));
    c.invalidate(deviceSettingsProvider);
    await pumpEventQueue();
    expect(server.patches, hasLength(1));
    expect(c.read(accessKeyProvider).rejected, isFalse);
  });

  test('앱 언어를 바꾸면 새 값을 보낸다', () async {
    final server = _Server(serverLocale: 'en');
    final c = await _container(server);
    expect(server.patches, isEmpty);
    c.read(displaySettingsProvider.notifier).setLanguage(AppLanguage.ko);
    await pumpEventQueue();
    expect(server.patches, [
      {'locale': 'ko'},
    ]);
  });

  test('PATCH가 UNAUTHORIZED면 거절 표시', () async {
    final server = _Server(patchFails: ('UNAUTHORIZED', 401));
    final c = await _container(server);
    expect(c.read(accessKeyProvider).rejected, isTrue);
  });
}
