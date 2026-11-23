import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/app/app.dart';
import 'package:futureetp/core/api/access_key.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/app_error.dart';
import 'package:futureetp/core/config/app_config.dart';
import 'package:futureetp/core/settings/device_settings.dart';
import 'package:futureetp/core/settings/display_settings.dart';
import 'package:futureetp/features/access_key/access_key_screen.dart';
import 'package:futureetp/features/commodity_list/commodity_list_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/display_store.dart';
import '../../helpers/fake_http.dart';

// 둘 다 형식(base64url 43자)은 맞다. 서버는 _goodKey만 받는다.
const _goodKey = 'GOODgoodGOODgoodGOODgoodGOODgoodGOODgood123';
const _badKey = 'BADbadBADbadBADbadBADbadBADbadBADbadBADbad1';

final Object? _settings = jsonDecode(
  File('test/contract/fixtures/settings.json').readAsStringSync(),
);
final Object? _commodities = jsonDecode(
  File('test/contract/fixtures/commodities.json').readAsStringSync(),
);

/// 서버 흉내: `/settings`는 _goodKey만 받고, A의 `/commodities`는 [listStatus]로 응답한다.
FakeHttpAdapter _server({int listStatus = 200, bool offline = false}) =>
    FakeHttpAdapter((req) {
      if (offline) {
        return FakeResponse(
          error: DioException.connectionError(
            requestOptions: req,
            reason: 'offline',
          ),
        );
      }
      final authorized = req.headers['Authorization'] == 'Bearer $_goodKey';
      return switch (req.path) {
        '/commodities' when listStatus == 401 => FakeResponse.fail(
          'UNAUTHORIZED',
          401,
        ),
        '/commodities' => FakeResponse.ok(_commodities),
        '/settings' when authorized => FakeResponse.ok(_settings),
        _ => FakeResponse.fail('UNAUTHORIZED', 401),
      };
    });

Widget _app(FakeHttpAdapter adapter, {String? storedKey}) => ProviderScope(
  retry: appRetry,
  observers: const [AuthErrorObserver()],
  overrides: [
    storedAccessKeyProvider.overrideWithValue(storedKey),
    displaySettingsStoreProvider.overrideWithValue(_displayStore),
    // 시간대는 fixture와 같아 언어만 보낸다
    deviceTimeZoneProvider.overrideWithValue(() async => 'Asia/Seoul'),
    appConfigProvider.overrideWithValue(
      const AppConfig(variant: AppVariant.prod, apiUrl: 'http://test'),
    ),
    apiClientProvider.overrideWith((ref) {
      final key = ref.watch(accessKeyProvider.select((s) => s.key));
      return ApiClient(
        Dio(BaseOptions(baseUrl: 'http://test/v1'))
          ..httpClientAdapter = adapter,
        accessToken: () async => key,
        deviceId: () async => '3f2c1a9e-8b7d-4c6e-9f1a-2b3c4d5e6f70',
      );
    }),
  ],
  child: const App(),
);

Finder get _input => find.byKey(const Key('access-key-input'));
Finder get _error => find.byKey(const Key('access-key-error'));
Finder get _submit => find.widgetWithText(FilledButton, 'Confirm');

Future<void> _enter(WidgetTester tester, String text) async {
  await tester.enterText(_input, text);
  await tester.pump();
  await tester.tap(_submit);
  await tester.pumpAndSettle();
}

late SharedPreferencesWithCache _displayStore;

void main() {
  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    _displayStore = await openTestDisplayStore();
  });

  testWidgets('키가 없으면 첫 화면이 B-b이고 [←]가 없다', (tester) async {
    await tester.pumpWidget(_app(_server()));
    await tester.pumpAndSettle();
    expect(find.byType(AccessKeyScreen), findsOneWidget);
    expect(find.bySemanticsLabel('Back'), findsNothing);
    // 비어 있으면 [확인]을 막는다
    expect(tester.widget<FilledButton>(_submit).onPressed, isNull);
  });

  testWidgets('입력 칸·버튼은 RN처럼 높이 44이고 사이가 12다', (tester) async {
    await tester.pumpWidget(_app(_server()));
    await tester.pumpAndSettle();
    final input = tester.getRect(
      find
          .ancestor(
            of: find.byKey(const Key('access-key-input')),
            matching: find.byType(Container),
          )
          .first,
    );
    final submit = tester.getRect(_submit);
    expect(input.height, 44);
    expect(submit.height, 44);
    expect(submit.top - input.bottom, 12);
  });

  testWidgets('서버가 받은 키를 저장하고 A로 간다', (tester) async {
    final adapter = _server();
    await tester.pumpWidget(_app(adapter));
    await tester.pumpAndSettle();
    await _enter(tester, '  $_goodKey ');

    expect(find.byType(CommodityListScreen), findsOneWidget);
    expect(await readStoredAccessKey(const FlutterSecureStorage()), _goodKey);
    // 확인 요청은 입력한 키로 보냈다
    expect(adapter.requests.first.headers['Authorization'], 'Bearer $_goodKey');
    // 키가 생기면 서버 언어(fixture ko)를 앱 언어(테스트 기기 en)로 맞춘다(D-137)
    expect(
      adapter.requests.where((r) => r.method == 'PATCH').map((r) => r.path),
      ['/settings'],
    );
  });

  testWidgets('형식이 아니면 서버에 묻지 않는다', (tester) async {
    final adapter = _server();
    await tester.pumpWidget(_app(adapter));
    await tester.pumpAndSettle();
    await _enter(tester, 'not-a-key');
    expect(find.text('The key format is invalid.'), findsOneWidget);
    expect(adapter.requests, isEmpty);
  });

  testWidgets('서버가 거절하면 저장하지 않고 오류 줄', (tester) async {
    await tester.pumpWidget(_app(_server()));
    await tester.pumpAndSettle();
    await _enter(tester, _badKey);
    expect(find.text('The key was not accepted.'), findsOneWidget);
    expect(find.byType(AccessKeyScreen), findsOneWidget);
    expect(await readStoredAccessKey(const FlutterSecureStorage()), isNull);
  });

  testWidgets('네트워크 오류는 공용 문구이고 저장하지 않는다', (tester) async {
    await tester.pumpWidget(_app(_server(offline: true)));
    await tester.pumpAndSettle();
    await _enter(tester, _goodKey);
    expect(
      tester.widget<Text>(_error).data,
      'Unable to connect to the network.',
    );
    expect(await readStoredAccessKey(const FlutterSecureStorage()), isNull);
  });

  testWidgets('저장된 키가 거절되면 B-b를 올리고, 새 키 없이 떠나면 표시를 지운다', (tester) async {
    await tester.pumpWidget(_app(_server(listStatus: 401), storedKey: _badKey));
    await tester.pumpAndSettle();

    expect(find.byType(AccessKeyScreen), findsOneWidget);
    expect(find.text('The key was not accepted.'), findsOneWidget);
    expect(find.bySemanticsLabel('Back'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(CommodityListScreen), findsOneWidget);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(CommodityListScreen)),
    );
    expect(container.read(accessKeyProvider).rejected, isFalse);
    // 키는 지우지 않는다
    expect(container.read(accessKeyProvider).key, _badKey);
  });

  testWidgets('거절돼서 온 B-b에서 새 키를 저장하면 돌아가고 다시 조회한다', (tester) async {
    final adapter = FakeHttpAdapter((req) {
      final authorized = req.headers['Authorization'] == 'Bearer $_goodKey';
      return switch (req.path) {
        '/commodities' when authorized => FakeResponse.ok(_commodities),
        '/settings' when authorized => FakeResponse.ok(_settings),
        _ => FakeResponse.fail('UNAUTHORIZED', 401),
      };
    });
    await tester.pumpWidget(_app(adapter, storedKey: _badKey));
    await tester.pumpAndSettle();
    expect(find.byType(AccessKeyScreen), findsOneWidget);

    await _enter(tester, _goodKey);
    expect(find.byType(AccessKeyScreen), findsNothing);
    expect(find.byKey(const Key('commodity-GC')), findsOneWidget);
  });
}
