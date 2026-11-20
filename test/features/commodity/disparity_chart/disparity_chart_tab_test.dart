import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/app/app.dart';
import 'package:futureetp/core/api/app_error.dart';
import 'package:futureetp/core/api/models/disparity_chart.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/charts/chart_skeleton.dart';
import 'package:futureetp/core/charts/price_chart.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:futureetp/features/commodity/disparity_chart/disparity_chart_provider.dart';
import 'package:futureetp/features/commodity/disparity_chart/disparity_chart_tab.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// fixture 봉 하나를 본으로 [n]개 봉을 만든다(날짜는 2025-01-01부터 하루씩, 종가는 조금씩 오른다).
DisparityChart _chart({
  int n = 300,
  String basis = 'FRONT',
  DateTime? start,
  bool hasMore = true,
}) {
  final json = jsonDecode(
    File('test/contract/fixtures/disparityChart.json').readAsStringSync(),
  ) as Map<String, Object?>;
  final template = (json['bars']! as List).last as Map<String, Object?>;
  final from = start ?? DateTime.utc(2025);
  return DisparityChart.fromJson({
    ...json,
    'basis': basis,
    'hasMore': hasMore,
    'bars': [
      for (var i = 0; i < n; i++)
        {
          ...template,
          'tradeDate': from
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

/// 조회 결과를 바로 넣는 가짜 Notifier. 이전 3년은 `_olderDelay` 뒤 2024년 봉 300개를 붙이거나 실패한다.
class _FakeChart extends DisparityChartNotifier {
  new(super.code, this.chart);

  final DisparityChart chart;
  int olderCalls = 0;

  @override
  Future<DisparityData> build() async => DisparityData(_params, chart);

  @override
  Future<void> loadOlder() async {
    olderCalls++;
    await Future<void>.delayed(_olderDelay);
    if (_olderFails) throw const AppError(AppErrorCode.network);
    final now = state.requireValue.chart;
    final older = _chart(start: DateTime.utc(2024, 3), hasMore: false);
    state = AsyncData(
      DisparityData(
        _params,
        now.copyWith(bars: [...older.bars, ...now.bars], hasMore: false),
      ),
    );
  }
}

var _olderDelay = const Duration(milliseconds: 500);
var _olderFails = false;
late _FakeChart _fake;

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
            .overrideWith(() => _fake = _FakeChart(CommodityCode.gc, chart)),
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

PriceChart _candle(WidgetTester tester) =>
    tester.widget<PriceChart>(find.byType(PriceChart));

bool _selected(WidgetTester tester, String period) =>
    tester.widget<Material>(find.byKey(Key('period-$period'))).color ==
    AppColors.surfaceSelected;

Future<void> _pinchOut(WidgetTester tester) async {
  final center = tester.getCenter(find.byType(PriceChart));
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

/// 한 번에 가장 과거까지 끈다(손가락은 떼지 않는다).
Future<TestGesture> _dragToOldest(WidgetTester tester) async {
  final g = await tester.startGesture(
    tester.getCenter(find.byType(PriceChart)),
  );
  for (var i = 0; i < 10; i++) {
    await g.moveBy(const Offset(300, 0));
    await tester.pump(const Duration(milliseconds: 16));
  }
  return g;
}

void main() {
  setUp(() {
    _olderDelay = const Duration(milliseconds: 500);
    _olderFails = false;
  });

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
    final center = tester.getCenter(find.byType(PriceChart));
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

  testWidgets('길게 누르면 상세 박스: 날짜·시고저종·전일 대비·이격도·선 값', (tester) async {
    await _pump(tester, _chart());
    final center = tester.getCenter(find.byType(PriceChart));
    final g = await tester.startGesture(center);
    await tester.pump(crosshairLongPress + const Duration(milliseconds: 50));
    await g.up();
    await tester.pump();
    final i = _candle(tester).crosshair.value!;
    final date = DateTime.utc(2025).add(Duration(days: i));
    expect(find.byKey(const Key('chart-detail')), findsOneWidget);
    expect(find.text(date.toIso8601String().substring(0, 10)), findsOneWidget);
    expect(find.text('Chg'), findsOneWidget);
    // 전일 대비 +1.0 (+…%)는 상승 색(한국식 빨강)
    expect(
      tester.widget<Text>(find.textContaining('+1.0 (')).style?.color,
      UpDownPalette.kr.up,
    );
    expect(find.text('MA100'), findsOneWidget);
  });

  testWidgets('가장 과거가 보이면 햅틱과 함께 이전 3년을 받고, 받는 동안 막고, 붙인 뒤 범위를 지킨다', (
    tester,
  ) async {
    await _pump(tester, _chart());
    final g = await _dragToOldest(tester);
    expect(_candle(tester).viewport.value.start, 0);
    expect(find.byKey(const Key('older-loading')), findsOneWidget);
    expect(_candle(tester).locked, isTrue);
    await g.up();
    final seen = _candle(tester).viewport.value;

    await tester.pump(_olderDelay);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('older-loading')), findsNothing);
    expect(_candle(tester).locked, isFalse);
    final v = _candle(tester).viewport.value;
    expect(v.count, 600);
    expect(v.start, seen.start + 300);
    expect(v.span, seen.span);
    expect(_fake.olderCalls, 1);
  });

  testWidgets('5초 안에 못 받으면 Alert, 늦게 온 봉은 그대로 붙는다', (tester) async {
    _olderDelay = const Duration(seconds: 8);
    await _pump(tester, _chart());
    final g = await _dragToOldest(tester);
    await g.up();
    await tester.pump(olderLoadTimeout);
    await tester.pumpAndSettle();
    expect(find.text("Couldn't load older data"), findsOneWidget);
    expect(find.byKey(const Key('older-loading')), findsNothing);
    await tester.tap(find.text('OK'));
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(_candle(tester).viewport.value.count, 600);
  });

  testWidgets('실패하면 Alert, 가장 과거 끝에서 다시 끌면 다시 받는다', (tester) async {
    _olderFails = true;
    await _pump(tester, _chart());
    var g = await _dragToOldest(tester);
    await g.up();
    await tester.pumpAndSettle();
    expect(find.text('Drag the chart again in a moment.'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // 범위가 그대로인 끌기도 끝나면 다시 시도한다
    g = await _dragToOldest(tester);
    await g.up();
    await tester.pumpAndSettle();
    expect(_fake.olderCalls, 2);
  });

  testWidgets('첫 조회 중에는 차트 격자·기간 칩 자리 스켈레톤', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          disparityChartProvider(CommodityCode.gc)
              .overrideWith(_PendingChart.new),
        ],
        child: const MaterialApp(
          localizationsDelegates: appLocalizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: DisparityChartTab(codeText: 'GC')),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(ChartSkeleton), findsOneWidget);
    expect(find.byType(PriceChart), findsNothing);
  });
}

/// 응답이 오지 않는 조회.
class _PendingChart extends DisparityChartNotifier {
  new() : super(CommodityCode.gc);

  @override
  Future<DisparityData> build() => Completer<DisparityData>().future;
}
