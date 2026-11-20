import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/models/contracts_chart.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/freshness.dart';
import 'package:futureetp/core/charts/chart_viewport.dart';
import 'package:futureetp/core/charts/price_chart.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:futureetp/features/commodity/contract_chart/contract_chart_provider.dart';
import 'package:futureetp/features/commodity/contract_chart/contract_chart_tab.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/test_app.dart';

String _date(DateTime from, int i) =>
    from.add(Duration(days: i)).toIso8601String().substring(0, 10);

/// 월물 2개(NGZ26 대표, NGF27은 앞 100일 상장 전), [n]일. 가격은 하루씩 조금 오른다.
ContractsChart _chart({
  int n = 300,
  DateTime? start,
  bool hasMore = true,
  double base = 3,
}) {
  final from = start ?? DateTime.utc(2025);
  return ContractsChart(
    freshness: Freshness(
      asOf: DateTime.utc(2025, 10, 28, 14),
      tradeDate: '2025-10-28',
      delayed: true,
      marketState: MarketState.open,
      nextUpdateAt: null,
    ),
    priceDecimals: 3,
    dates: [for (var i = 0; i < n; i++) _date(from, i)],
    hasMore: hasMore,
    provisional: true,
    contracts: [
      ContractLine(
        symbol: 'NGZ26',
        contractMonth: '2026-12',
        lastTradeDate: '2026-11-25',
        isFront: true,
        prices: [for (var i = 0; i < n; i++) base + i * 0.01],
      ),
      ContractLine(
        symbol: 'NGF27',
        contractMonth: '2027-01',
        lastTradeDate: '2026-12-28',
        isFront: false,
        prices: List.generate(n, (i) => i < 100 ? null : 3.5 + i * 0.01),
      ),
    ],
  );
}

/// 조회 결과를 바로 넣는 가짜 Notifier. 이전 3년은 500ms 뒤 2024년 300일을 붙인다.
class _FakeChart extends ContractChartNotifier {
  new(super.code, this.chart);

  final ContractsChart chart;
  int olderCalls = 0;

  @override
  Future<ContractsChart> build() async => chart;

  @override
  Future<void> loadOlder() async {
    olderCalls++;
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final older = _chart(start: DateTime.utc(2024, 3), hasMore: false);
    state = AsyncData(
      prependContracts(older, state.requireValue, hasMore: false),
    );
  }
}

late _FakeChart _fake;

Future<void> _pump(WidgetTester tester, ContractsChart chart) async {
  tester.view
    ..physicalSize = const Size(1080, 2400)
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        upDownPaletteProvider.overrideWithValue(UpDownPalette.kr),
        contractChartProvider(CommodityCode.ng)
            .overrideWith(() => _fake = _FakeChart(CommodityCode.ng, chart)),
      ],
      child: testApp(
        home: const Scaffold(body: ContractChartTab(codeText: 'NG')),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

PriceChart _price(WidgetTester tester) =>
    tester.widget<PriceChart>(find.byType(PriceChart));

void main() {
  testWidgets('6M으로 시작하고, 범례에 선 견본·월물명, 대표월물 ●은 회색이다', (tester) async {
    await _pump(tester, _chart());
    expect(_price(tester).viewport.value.span, 126);
    expect(_price(tester).series.candles, isNull);
    expect(_price(tester).series.logScale, isTrue);

    final legend = find.byKey(const Key('contracts-legend'));
    expect(
      find.descendant(of: legend, matching: find.text('DEC26●')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: legend, matching: find.text('JAN27')),
      findsOneWidget,
    );
    final dec = tester.widget<Text>(
      find.descendant(of: legend, matching: find.text('DEC26●')),
    );
    final mark = (dec.textSpan! as TextSpan).children!.single as TextSpan;
    expect(mark.text, '●');
    expect(mark.style?.color, AppColors.textSecondary);
  });

  testWidgets('끝값 라벨은 보이는 범위에서 각 선의 마지막 값(선 색)이다', (tester) async {
    await _pump(tester, _chart());
    final decor = _price(tester).decor!;
    expect(decor.labelsIn(0, 299), [
      (price: 3 + 299 * 0.01, color: ChartColors.contractLines[0]),
      (price: 3.5 + 299 * 0.01, color: ChartColors.contractLines[1]),
    ]);
    // 상장 전 구간만 보이면 근월물만
    expect(decor.labelsIn(0, 50).map((l) => l.color), [
      ChartColors.contractLines[0],
    ]);
    expect(decor.extremeText, isNull);
  });

  testWidgets('길게 누르면 상세 박스: 날짜·(잠정)·월물별 가격·롤 수익률', (tester) async {
    await _pump(tester, _chart());
    // 마지막 날(오늘 잠정)에 십자선
    _price(tester).crosshair.value = 299;
    await tester.pump();
    final box = find.byKey(const Key('chart-detail'));
    expect(box, findsOneWidget);
    expect(
      find.descendant(of: box, matching: find.text('2025-10-27')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: box, matching: find.text('(provisional)')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: box, matching: find.text('DEC26●')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: box, matching: find.text('5.990')),
      findsOneWidget,
    );
    // (5.99 / 6.49 − 1) × 365 / 33 × 100 = −85.21%
    expect(
      find.descendant(of: box, matching: find.text('Roll yield')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: box, matching: find.textContaining('%/yr')),
      findsOneWidget,
    );
  });

  testWidgets('값이 있는 월물이 하나인 날은 롤 수익률이 없다', (tester) async {
    await _pump(tester, _chart());
    _price(tester).crosshair.value = 10;
    await tester.pump();
    expect(find.text('Roll yield'), findsNothing);
    expect(find.text('(provisional)'), findsNothing);
  });

  testWidgets('0 이하 값이 있으면 선형 축이다', (tester) async {
    await _pump(tester, _chart(base: -2));
    expect(_price(tester).series.logScale, isFalse);
  });

  testWidgets('가장 과거가 보이면 이전 3년을 받아 앞에 붙이고 보던 범위를 지킨다', (tester) async {
    await _pump(tester, _chart());
    final g = await tester.startGesture(
      tester.getCenter(find.byType(PriceChart)),
    );
    for (var i = 0; i < 10; i++) {
      await g.moveBy(const Offset(300, 0));
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(find.byKey(const Key('older-loading')), findsOneWidget);
    expect(_price(tester).locked, isTrue);
    await g.up();
    final seen = _price(tester).viewport.value;

    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    final v = _price(tester).viewport.value;
    expect(
      v,
      ChartViewport(count: 600, start: seen.start + 300, span: seen.span),
    );
    expect(_fake.olderCalls, 1);
    // 이어 붙인 앞 구간은 NGF27이 없어 null로 채운다
    expect(_price(tester).series.lines[1].values[0], isNaN);
  });

  testWidgets('월물이 없으면 안내 문구', (tester) async {
    await _pump(tester, _chart().copyWith(contracts: const []));
    expect(find.text('No contracts to show.'), findsOneWidget);
  });
}
