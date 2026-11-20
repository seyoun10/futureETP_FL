import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/access_key.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/settings.dart';
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
  String serverTimeZone = 'Asia/Seoul';
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
      serverTimeZone = body['timezone'] as String? ?? serverTimeZone;
    }
    return FakeResponse.ok({
      ..._fixture,
      'locale': serverLocale,
      'timezone': serverTimeZone,
    });
  });
}

Future<ProviderContainer> _container(
  _Server server, {
  Locale device = const Locale('en', 'US'),
  String? timeZone = 'Asia/Seoul',
}) async {
  final store = await openTestDisplayStore();
  final container = ProviderContainer(
    overrides: [
      displaySettingsStoreProvider.overrideWithValue(store),
      deviceLocaleProvider.overrideWithValue(device),
      deviceTimeZoneProvider.overrideWithValue(() async => timeZone),
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
  // 기기 설정은 앱 생명주기(AppLifecycleListener)를 듣는다
  TestWidgetsFlutterBinding.ensureInitialized();

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

  test('기기 시간대가 서버와 다르면 PATCH한다', () async {
    final server = _Server();
    await _container(
      server,
      device: const Locale('ko', 'KR'),
      timeZone: 'America/Chicago',
    );
    expect(server.patches, [
      {'timezone': 'America/Chicago'},
    ]);
  });

  test('언어·시간대가 둘 다 다르면 한 번에 보낸다', () async {
    final server = _Server();
    await _container(server, timeZone: 'America/Chicago');
    expect(server.patches, [
      {'locale': 'en', 'timezone': 'America/Chicago'},
    ]);
  });

  test('시간대를 읽지 못하면 시간대는 보내지 않는다', () async {
    final server = _Server();
    await _container(server, device: const Locale('ko', 'KR'), timeZone: null);
    expect(server.patches, isEmpty);
  });

  test('앱이 앞으로 돌아오면 설정을 다시 받는다', () async {
    final server = _Server();
    await _container(server, device: const Locale('ko', 'KR'));
    expect(server.adapter.requests, hasLength(1));
    final binding = TestWidgetsFlutterBinding.instance
      ..handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await pumpEventQueue();
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await pumpEventQueue();
    expect(server.adapter.requests, hasLength(2));
  });

  group('화면 저장(PATCH 순서·낙관적 표시)', () {
    late _GateAdapter gate;
    late ProviderContainer c;

    setUp(() async {
      gate = _GateAdapter();
      final store = await openTestDisplayStore();
      c = ProviderContainer(
        overrides: [
          displaySettingsStoreProvider.overrideWithValue(store),
          storedAccessKeyProvider.overrideWithValue('stored-key'),
          apiClientProvider.overrideWithValue(
            ApiClient(
              Dio(BaseOptions(baseUrl: 'http://test/v1'))
                ..httpClientAdapter = gate,
              accessToken: () async => 'stored-key',
              deviceId: () async => '3f2c1a9e-8b7d-4c6e-9f1a-2b3c4d5e6f70',
            ),
          ),
        ],
      );
      addTearDown(c.dispose);
      c.listen(settingsViewProvider, (_, _) {});
      await pumpEventQueue();
      gate.respond(_fixture);
      await pumpEventQueue();
    });

    test('끝나기 전에도 바꾼 값을 보이고, 보낸 순서대로 하나씩 보낸다', () async {
      final notifier = c.read(deviceSettingsProvider.notifier);
      final first = notifier.save(const SettingsPatch(basis: Basis.kr));
      final second = notifier.save(
        const SettingsPatch(maPeriod: MaPeriod.ma20),
      );
      await pumpEventQueue();
      expect(c.read(settingsViewProvider).value?.basis, Basis.kr);
      expect(c.read(settingsViewProvider).value?.maPeriod, MaPeriod.ma20);
      // 둘째는 첫째가 끝나야 간다
      expect(gate.bodies, [
        {'basis': 'KR'},
      ]);
      gate.respond({..._fixture, 'basis': 'KR'});
      expect(await first, isNull);
      await pumpEventQueue();
      expect(gate.bodies, hasLength(2));
      gate.respond({..._fixture, 'basis': 'KR', 'maPeriod': 20});
      expect(await second, isNull);
      expect(c.read(pendingSettingsPatchesProvider), isEmpty);
      expect(c.read(deviceSettingsProvider).value?.maPeriod, MaPeriod.ma20);
    });

    test('실패하면 그 변경만 빠지고 서버 값으로 돌아간다', () async {
      final before = c.read(deviceSettingsProvider).value!.basis;
      final notifier = c.read(deviceSettingsProvider.notifier);
      final saving = notifier.save(const SettingsPatch(basis: Basis.us));
      await pumpEventQueue();
      expect(c.read(settingsViewProvider).value?.basis, Basis.us);
      gate.fail('INTERNAL', 500);
      // INTERNAL이어도 변경 요청은 다시 보내지 않는다(D-072)
      expect(await saving, isA<Object>());
      expect(gate.bodies, hasLength(1));
      expect(c.read(settingsViewProvider).value?.basis, before);
    });

    test('진행 중인 설정 조회가 PATCH보다 늦게 끝나도 옛 값으로 덮지 않는다', () async {
      // 앱 복귀 등으로 다시 받는 중(PATCH 전 서버 값을 받을 GET)
      c.invalidate(deviceSettingsProvider);
      await pumpEventQueue();
      final saving = c
          .read(deviceSettingsProvider.notifier)
          .save(const SettingsPatch(basis: Basis.kr));
      await pumpEventQueue();
      // 앞선 GET이 먼저 대기열에 있다: GET보다 PATCH 응답이 먼저 온 경우
      final get = gate.take();
      gate.respond({..._fixture, 'basis': 'KR'});
      expect(await saving, isNull);
      get.complete(gate.ok({..._fixture, 'basis': 'US'}));
      await pumpEventQueue();
      expect(c.read(deviceSettingsProvider).value?.basis, Basis.kr);
      expect(c.read(settingsViewProvider).value?.basis, Basis.kr);
    });

    test('알림 대상을 null로 지우는 변경을 얹는다', () async {
      unawaited(
        c
            .read(deviceSettingsProvider.notifier)
            .save(const SettingsPatch(alertCommodity: PatchValue(null))),
      );
      await pumpEventQueue();
      expect(gate.bodies.last, {'alertCommodity': null});
      expect(c.read(settingsViewProvider).value?.alertCommodity, isNull);
    });
  });
}

/// 요청을 붙잡아 두고 테스트가 [respond]·[fail]로 하나씩 답하는 어댑터.
class _GateAdapter implements HttpClientAdapter {
  final _waiting = <Completer<ResponseBody>>[];
  final bodies = <Map<String, dynamic>>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (requestStream != null) {
      final text = utf8.decode(await requestStream.expand((b) => b).toList());
      bodies.add(jsonDecode(text) as Map<String, dynamic>);
    }
    final completer = Completer<ResponseBody>();
    _waiting.add(completer);
    return await completer.future;
  }

  void respond(Map<String, dynamic> data) =>
      _waiting.removeAt(0).complete(ok(data));

  /// 가장 먼저 온 요청을 꺼내 나중에 답하게 한다(응답 순서 바꾸기).
  Completer<ResponseBody> take() => _waiting.removeAt(0);

  ResponseBody ok(Map<String, dynamic> data) =>
      ResponseBody.fromString(jsonEncode({'success': true, 'data': data}), 200);

  void fail(String code, int status) => _waiting
      .removeAt(0)
      .complete(
        ResponseBody.fromString(
          jsonEncode({
            'success': false,
            'error': {'code': code, 'message': 'test'},
          }),
          status,
        ),
      );

  @override
  void close({bool force = false}) {}
}
