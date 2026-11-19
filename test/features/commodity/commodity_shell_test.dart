import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/app/app.dart';
import 'package:futureetp/app/router.dart';
import 'package:futureetp/core/api/access_key.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/app_error.dart';
import 'package:futureetp/core/config/app_config.dart';
import 'package:futureetp/core/settings/device_settings.dart';
import 'package:futureetp/core/settings/display_settings.dart';
import 'package:futureetp/features/commodity/commodity_shell.dart';
import 'package:futureetp/features/commodity_list/commodity_list_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/display_store.dart';
import '../../helpers/fake_http.dart';

Object? _fixture(String name) =>
    jsonDecode(File('test/contract/fixtures/$name.json').readAsStringSync());

late SharedPreferencesWithCache _displayStore;

Future<ProviderContainer> _pump(WidgetTester tester) async {
  // 테스트 기본 창(800×600)은 가로라 tab-bar가 숨는다. 세로 휴대폰 크기로 둔다
  tester.view
    ..physicalSize = const Size(1080, 2400)
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final settings = _fixture('settings')! as Map<String, Object?>;
  final adapter = FakeHttpAdapter(
    (req) => switch (req.path) {
      '/commodities' => FakeResponse.ok(_fixture('commodities')),
      // NG가 알림 대상
      '/settings' => FakeResponse.ok({...settings, 'alertCommodity': 'NG'}),
      _ => FakeResponse.fail('NOT_FOUND', 404),
    },
  );
  await tester.pumpWidget(
    ProviderScope(
      retry: appRetry,
      overrides: [
        storedAccessKeyProvider.overrideWithValue('key'),
        displaySettingsStoreProvider.overrideWithValue(_displayStore),
        deviceTimeZoneProvider.overrideWithValue(() async => 'Asia/Seoul'),
        appConfigProvider.overrideWithValue(
          const AppConfig(variant: AppVariant.prod, apiUrl: 'http://test'),
        ),
        apiClientProvider.overrideWithValue(
          ApiClient(
            Dio(BaseOptions(baseUrl: 'http://test/v1'))
              ..httpClientAdapter = adapter,
            accessToken: () async => 'key',
            deviceId: () async => 'id',
          ),
        ),
      ],
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
  return ProviderScope.containerOf(tester.element(find.byType(App)));
}

String _location(ProviderContainer c) =>
    c.read(routerProvider).routerDelegate.currentConfiguration.uri.toString();

Text _tabText(WidgetTester tester, String key) => tester.widget<Text>(
  find.descendant(of: find.byKey(Key(key)), matching: find.byType(Text)),
);

void main() {
  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    _displayStore = await openTestDisplayStore();
  });

  testWidgets('A 행을 누르면 C-a 탭으로 가고, 탭·[←]로 오간다', (tester) async {
    final c = await _pump(tester);
    await tester.tap(find.byKey(const Key('commodity-NG')));
    await tester.pumpAndSettle();

    expect(_location(c), '/commodity/NG');
    expect(find.text('Natural Gas (NG)'), findsOneWidget);
    // 알림 대상이라 제목 옆 🔔
    expect(find.text('🔔'), findsOneWidget);
    expect(
      _tabText(tester, 'commodity-tab-disparity').style?.fontWeight,
      FontWeight.w600,
    );
    expect(find.byKey(const Key('commodity-rotate')), findsOneWidget);

    await tester.tap(find.byKey(const Key('commodity-tab-contracts')));
    await tester.pumpAndSettle();
    expect(_location(c), '/commodity/NG/contracts');

    // ETP 탭에서는 [⟲]가 없다
    await tester.tap(find.byKey(const Key('commodity-tab-etps')));
    await tester.pumpAndSettle();
    expect(_location(c), '/commodity/NG/etps');
    expect(find.byKey(const Key('commodity-rotate')), findsNothing);

    // [←]는 탭 이력과 상관없이 A로
    await tester.tap(find.bySemanticsLabel('Back'));
    await tester.pumpAndSettle();
    expect(_location(c), '/');
    expect(find.byType(CommodityListScreen), findsOneWidget);
    expect(find.byType(CommodityShell), findsNothing);
  });

  testWidgets('Android 뒤로 가기도 A로 간다', (tester) async {
    final c = await _pump(tester);
    c.read(routerProvider).go('/commodity/GC/curve');
    await tester.pumpAndSettle();
    expect(find.text('Gold (GC)'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(_location(c), '/');
  });

  testWidgets('모르는 코드면 경로 값을 제목으로 쓴다', (tester) async {
    final c = await _pump(tester);
    c.read(routerProvider).go('/commodity/XX');
    await tester.pumpAndSettle();
    expect(find.text('XX'), findsOneWidget);
  });
}
