import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/app/app.dart';
import 'package:futureetp/core/api/models/disparity_chart.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/charts/candle_chart.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:futureetp/features/commodity/disparity_chart/disparity_chart_provider.dart';
import 'package:futureetp/features/commodity/disparity_chart/disparity_chart_tab.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// fixture 봉 하나를 본으로 [n]개 봉을 만든다(날짜는 2025-01-01부터 하루씩, 종가는 조금씩 오른다).
DisparityChart _chart({int n = 300, String basis = 'FRONT'}) {
  final json = jsonDecode(
    File('test/contract/fixtures/disparityChart.json').readAsStringSync(),
  ) as Map<String, Object?>;
  final template = (json['bars']! as List).last as Map<String, Object?>;
  final start = DateTime.utc(2025);
  return DisparityChart.fromJson({
    ...json,
    'basis': basis,
    'bars': [
      for (var i = 0; i < n; i++)
        {
          ...template,
          'tradeDate': start
              .add(Duration(days: i))
              .toIso8601String()
              .substring(0, 10),
          'open': 100.0 + i,
          'high': 102.0 + i,
          'low': 99.0 + i,
          'close': 101.0 + i,
          'ma': 100.0 + i,
        },
    ],
  });
}

const _params = DisparityParams(
  basis: Basis.front,
  ma: MaPeriod.ma100,
  window: DistributionWindow.y10,
  levels: [1, 2, 4, 8, 16],
);

/// 조회 결과를 바로 넣는 가짜 Notifier.
class _FakeChart extends DisparityChartNotifier {
  new(super.code, this.chart);

  final DisparityChart chart;

  @override
  Future<DisparityData> build() async => DisparityData(_params, chart);
}

Future<void> _pump(WidgetTester tester, DisparityChart chart) async {
  tester.view
    ..physicalSize = const Size(1080, 2400)
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        upDownPaletteProvider.overrideWithValue(UpDownPalette.kr),
        disparityChartProvider(CommodityCode.gc)
            .overrideWith(() => _FakeChart(CommodityCode.gc, chart)),
      ],
      child: const MaterialApp(
        localizationsDelegates: appLocalizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: DisparityChartTab(codeText: 'GC')),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

CandleChart _candle(WidgetTester tester) =>
    tester.widget<CandleChart>(find.byType(CandleChart));

bool _selected(WidgetTester tester, String period) =>
    tester.widget<Material>(find.byKey(Key('period-$period'))).color ==
    AppColors.surfaceSelected;

Future<void> _pinchOut(WidgetTester tester) async {
  final center = tester.getCenter(find.byType(CandleChart));
  final a = await tester.startGesture(
    center - const Offset(30, 0),
    pointer: 10,
  );
  final b = await tester.startGesture(
    center + const Offset(30, 0),
    pointer: 11,
  );
  for (var i = 1; i <= 10; i++) {
    await a.moveTo(center - Offset(30 + i * 6.0, 0));
    await b.moveTo(center + Offset(30 + i * 6.0, 0));
    await tester.pump(const Duration(milliseconds: 16));
  }
  await a.up();
  await b.up();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('6M으로 시작하고, 위 두 줄에 오늘 시고저종과 이격도·LC·HC', (tester) async {
    await _pump(tester, _chart());
    expect(_candle(tester).viewport.value.span, 126);
    expect(_selected(tester, '6M'), isTrue);

    final today = tester
        .widget<RichText>(
          find
              .descendant(
                of: find.byKey(const Key('disparity-today')),
                matching: find.byType(RichText),
              )
              .first,
        )
        .text
        .toPlainText();
    expect(today, contains(' · O399.0 H401.0 L398.0 C400.0'));
    expect(find.text('Front month DEC26'), findsOneWidget);

    final stats = tester.widget<Text>(find.byKey(const Key('disparity-stats')));
    // fixture: 이격도 마지막 봉 값, 하위 3%. 보이는 봉(순번 174~299) 최저가 273·최고가 401, 현재가 400
    expect(stats.data, startsWith('Disparity '));
    expect(stats.data, contains('(bottom 3%)'));
    expect(stats.data, contains('LC +46.52%'));
    expect(stats.data, contains('HC -0.25%'));
  });

  testWidgets('기준값을 누르면 안내가 열리고 다시 누르면 닫힌다', (tester) async {
    await _pump(tester, _chart());
    await tester.tap(find.byKey(const Key('disparity-basis')));
    await tester.pump();
    expect(find.byKey(const Key('disparity-hint')), findsOneWidget);
    await tester.tap(find.byKey(const Key('disparity-hint')));
    await tester.pump();
    expect(find.byKey(const Key('disparity-hint')), findsNothing);
  });

  testWidgets('기간 칩을 누르면 그 기간의 최근 위치로 간다', (tester) async {
    await _pump(tester, _chart());
    await tester.tap(find.text('12M'));
    await tester.pump();
    expect(_candle(tester).viewport.value.span, 252);
    expect(_candle(tester).viewport.value.end, 300);
    expect(_selected(tester, '12M'), isTrue);
  });

  testWidgets('핀치하면 선택 표시를 지우고 [↻], 누르면 기간의 최근 위치로 돌아온다', (tester) async {
    await _pump(tester, _chart());
    await _pinchOut(tester);
    expect(_candle(tester).viewport.value.span, lessThan(126));
    expect(_selected(tester, '6M'), isFalse);
    expect(find.byKey(const Key('chart-reset')), findsOneWidget);

    await tester.tap(find.byKey(const Key('chart-reset')));
    await tester.pump();
    expect(_candle(tester).viewport.value.span, 126);
    expect(_candle(tester).viewport.value.end, 300);
    expect(_selected(tester, '6M'), isTrue);
    expect(find.byKey(const Key('chart-reset')), findsNothing);
  });

  testWidgets('끌기는 선택 표시를 남기고, 끌어서 돌아오면 [↻]가 사라진다', (tester) async {
    await _pump(tester, _chart());
    final center = tester.getCenter(find.byType(CandleChart));
    final g = await tester.startGesture(center);
    for (var i = 1; i <= 5; i++) {
      await g.moveTo(center + Offset(i * 20.0, 0));
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(find.byKey(const Key('chart-reset')), findsOneWidget);
    expect(_selected(tester, '6M'), isTrue);
    // 같은 손가락으로 처음 자리보다 더 왼쪽(최근 끝)까지 되돌린다
    for (var i = 4; i >= -3; i--) {
      await g.moveTo(center + Offset(i * 20.0, 0));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await g.up();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('chart-reset')), findsNothing);
  });

  testWidgets('봉이 없으면 안내 문구', (tester) async {
    await _pump(tester, _chart(n: 0));
    expect(find.text('No bars to show.'), findsOneWidget);
  });

  testWidgets('모르는 코드면 NOT_FOUND 문구', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: appLocalizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: DisparityChartTab(codeText: 'XX')),
        ),
      ),
    );
    expect(find.byType(TabMessage), findsOneWidget);
  });
}
