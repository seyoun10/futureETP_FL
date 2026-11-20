import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/app/app.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/features/alert_settings/alert_settings_screen.dart';
import 'package:futureetp/features/data_sources/data_sources_screen.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/display_store.dart';
import '../../helpers/settings_server.dart';

late SharedPreferencesWithCache _displayStore;

Future<SettingsServer> _pump(
  WidgetTester tester, {
  Map<String, Object?>? initial,
  Widget home = const AlertSettingsScreen(),
}) async {
  final server = SettingsServer(initial: initial);
  tester.view
    ..physicalSize = const Size(800, 2400)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: server.overrides(_displayStore),
      child: MaterialApp(
        localizationsDelegates: appLocalizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: home,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return server;
}

bool _selected(WidgetTester tester, String label) =>
    tester
        .widget<Material>(
          find
              .ancestor(of: find.text(label), matching: find.byType(Material))
              .first,
        )
        .color ==
    AppColors.surfaceSelected;

void main() {
  setUp(() async {
    _displayStore = await openTestDisplayStore();
  });

  testWidgets('대상이 없으면 없음, 적용 기준 요약을 그린다', (tester) async {
    await _pump(
      tester,
      initial: {
        'basis': 'US',
        'window': 'Y10',
        'rareLevels': [0.5, 2, 4, 8, 16],
      },
    );
    expect(_selected(tester, 'None'), isTrue);
    expect(_selected(tester, 'Gold'), isFalse);
    expect(find.text('Basis US-style · 100-day MA · 10 years'), findsOneWidget);
    expect(find.text('Levels 0.5/2/4/8/16% (above & below)'), findsOneWidget);
    // 거부 시간이 꺼져 있으면 시각 행이 없다
    expect(find.textContaining('Start'), findsNothing);
  });

  testWidgets('대상을 고르면 PATCH, 없음은 null로 보낸다', (tester) async {
    final server = await _pump(tester);
    await tester.tap(find.text('Crude Oil'));
    await tester.pumpAndSettle();
    expect(_selected(tester, 'Crude Oil'), isTrue);
    await tester.tap(find.text('None'));
    await tester.pumpAndSettle();
    expect(server.patches, [
      {'alertCommodity': 'CL'},
      {'alertCommodity': null},
    ]);
  });

  testWidgets('저장이 실패하면 빨간 줄', (tester) async {
    (await _pump(tester)).failWith = ('INTERNAL', 500);
    await tester.tap(find.text('Gold'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Could not save.'), findsOneWidget);
    expect(_selected(tester, 'None'), isTrue);
  });

  testWidgets('거부 시간을 켜면 23:00~다음 날 07:00, 끄면 null', (tester) async {
    final server = await _pump(tester);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(server.patches.last, {
      'quietTime': {'startMin': 1380, 'endMin': 420},
    });
    expect(find.text('23:00'), findsOneWidget);
    expect(find.text('next day 07:00'), findsOneWidget);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(server.patches.last, {'quietTime': null});
  });

  testWidgets('시각 시트: 반대쪽 시각은 고를 수 없고, 고르면 저장한다', (tester) async {
    final server = await _pump(
      tester,
      initial: {
        'quietTime': {'startMin': 1380, 'endMin': 420},
      },
    );
    await tester.tap(find.bySemanticsLabel('Start 23:00'));
    await tester.pumpAndSettle();
    // 48칸
    expect(find.text('00:00'), findsOneWidget);
    expect(find.text('23:30'), findsOneWidget);
    // 종료 시각(07:00)은 막혀 있어 눌러도 닫히지 않는다
    await tester.tap(find.text('07:00').last);
    await tester.pumpAndSettle();
    expect(server.patches, isEmpty);
    await tester.tap(find.text('06:00'));
    await tester.pumpAndSettle();
    expect(server.patches, [
      {
        'quietTime': {'startMin': 360, 'endMin': 420},
      },
    ]);
    // 자정을 넘지 않으면 '다음 날'이 없다
    expect(find.text('07:00'), findsOneWidget);
  });

  test('분 → HH:MM', () {
    expect(formatQuietMinute(0), '00:00');
    expect(formatQuietMinute(90), '01:30');
    expect(formatQuietMinute(1410), '23:30');
  });

  testWidgets('데이터 출처: 묶음 두 개와 줄, 안내', (tester) async {
    await _pump(tester, home: const DataSourcesScreen());
    expect(find.text('Futures prices'), findsOneWidget);
    expect(find.text('Databento (since 2010-06)'), findsOneWidget);
    expect(find.text('Naver Finance, KRX'), findsOneWidget);
    expect(find.textContaining('not investment advice'), findsOneWidget);
  });
}
