import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/access_key.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/config/app_version.dart';
import 'package:futureetp/core/push/push_registration.dart';
import 'package:futureetp/core/push/push_service.dart';
import 'package:futureetp/core/settings/display_settings.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/display_store.dart';
import '../../helpers/fake_http.dart';
import '../../helpers/fake_push.dart';

const _deviceId = '3f2c1a9e-8b7d-4c6e-9f1a-2b3c4d5e6f70';

Future<(ProviderContainer, FakeHttpAdapter)> _container(
  FakePushService push, {
  String? key = 'stored-key',
  Locale device = const Locale('ko', 'KR'),
  FakeHttpAdapter? http,
}) async {
  final adapter =
      http ?? FakeHttpAdapter.always(FakeResponse.ok({'id': _deviceId}));
  final store = await openTestDisplayStore();
  final container = ProviderContainer(
    overrides: [
      displaySettingsStoreProvider.overrideWithValue(store),
      deviceLocaleProvider.overrideWithValue(device),
      storedAccessKeyProvider.overrideWithValue(key),
      pushServiceProvider.overrideWithValue(push),
      appVersionProvider.overrideWith(
        (ref) async => (version: '1.0.0', build: '1'),
      ),
      apiClientProvider.overrideWith((ref) {
        final key = ref.watch(accessKeyProvider.select((s) => s.key));
        return ApiClient(
          Dio(BaseOptions(baseUrl: 'http://test/v1'))
            ..httpClientAdapter = adapter,
          accessToken: () async => key,
          deviceId: () async => _deviceId,
        );
      }),
    ],
  );
  addTearDown(container.dispose);
  container.listen(pushRegistrationProvider, (_, _) {});
  await pumpEventQueue();
  return (container, adapter);
}

List<Object?> _bodies(FakeHttpAdapter adapter) =>
    adapter.sentBodies.map(jsonDecode).toList();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  group('pushRegistrationProvider', () {
    test('채널을 앱 언어로 만들고 권한을 물은 뒤 토큰을 한 번 등록한다', () async {
      final push = FakePushService();
      final (_, adapter) = await _container(push);
      expect(push.channelNames, [
        {AndroidChannel.alerts: '시세 알림', AndroidChannel.ops: '운영 알림'},
      ]);
      expect(push.permissionRequests, 1);
      final req = adapter.requests.single;
      expect(req.method, 'PUT');
      expect(req.uri.path, '/v1/devices');
      expect(_bodies(adapter), [
        {
          'pushToken': 'fcm-token',
          'platform': 'ANDROID',
          'appVersion': 'fl-1.0.0',
        },
      ]);
    });

    test('앱 언어가 바뀌면 채널 이름만 바꾸고 다시 등록하지 않는다', () async {
      final push = FakePushService();
      final (c, adapter) = await _container(push);
      c.read(displaySettingsProvider.notifier).setLanguage(AppLanguage.en);
      await pumpEventQueue();
      expect(push.channelNames.last, {
        AndroidChannel.alerts: 'Market alerts',
        AndroidChannel.ops: 'Server alerts',
      });
      expect(adapter.requests, hasLength(1));
    });

    test('등록이 실패하면 앱 언어가 바뀔 때 다시 등록한다', () async {
      var calls = 0;
      final http = FakeHttpAdapter(
        (_) => ++calls == 1
            ? FakeResponse.fail('UNAUTHORIZED', 401)
            : FakeResponse.ok({'id': _deviceId}),
      );
      final (c, adapter) = await _container(FakePushService(), http: http);
      expect(adapter.requests, hasLength(1));
      c.read(displaySettingsProvider.notifier).setLanguage(AppLanguage.en);
      await pumpEventQueue();
      c.read(displaySettingsProvider.notifier).setLanguage(AppLanguage.ko);
      await pumpEventQueue();
      expect(adapter.requests, hasLength(2));
    });

    test('빈 토큰이면 토큰 없이 등록한다', () async {
      final (_, adapter) = await _container(FakePushService(token: ''));
      expect(_bodies(adapter).single, containsPair('pushToken', null));
    });

    test('토큰 조회가 실패하면 등록하지 않는다', () async {
      final (_, adapter) = await _container(
        FakePushService(tokenError: Exception('SERVICE_NOT_AVAILABLE')),
      );
      expect(adapter.requests, isEmpty);
    });

    test('토큰이 바뀌면 새 토큰만 다시 등록한다', () async {
      final push = FakePushService();
      final (_, adapter) = await _container(push);
      push.tokenRefresh
        ..add('fcm-token')
        ..add('new-token');
      await pumpEventQueue();
      expect(_bodies(adapter).map((b) => (b! as Map)['pushToken']), [
        'fcm-token',
        'new-token',
      ]);
    });

    test('푸시를 못 쓰는 플랫폼이나 키가 없으면 아무것도 하지 않는다', () async {
      final noPlatform = FakePushService(platform: null);
      final (_, a1) = await _container(noPlatform);
      final noKey = FakePushService();
      final (_, a2) = await _container(noKey, key: null);
      expect(a1.requests, isEmpty);
      expect(a2.requests, isEmpty);
      expect(noPlatform.channelNames, isEmpty);
      expect(noKey.channelNames, isEmpty);
    });

    test('키를 새로 저장하면 새 키로 다시 등록한다', () async {
      final push = FakePushService();
      final (c, adapter) = await _container(push);
      await c.read(accessKeyProvider.notifier).save('new-key');
      await pumpEventQueue();
      expect(adapter.requests, hasLength(2));
      expect(adapter.requests.last.headers['Authorization'], 'Bearer new-key');
    });
  });

  group('notificationCommodity', () {
    test('rare 레벨 알림은 그 원자재, 그 밖은 null(A)', () {
      expect(
        notificationCommodity({'type': 'RARE_LEVEL', 'commodity': 'CL'}),
        CommodityCode.cl,
      );
      expect(
        notificationCommodity({'type': 'RARE_LEVEL', 'commodity': 'XX'}),
        isNull,
      );
      expect(notificationCommodity({'type': 'JOB_FAILED'}), isNull);
      expect(notificationCommodity(null), isNull);
    });
  });
}
