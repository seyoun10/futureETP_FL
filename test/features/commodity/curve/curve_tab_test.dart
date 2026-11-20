import 'package:cupertino_ui/cupertino_ui.dart' hide Curve;
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/app/app.dart';
import 'package:futureetp/core/api/api_client.dart';
import 'package:futureetp/core/api/models/curve.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/freshness.dart';
import 'package:futureetp/core/charts/curve_chart.dart';
import 'package:futureetp/core/charts/price_chart.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:futureetp/features/commodity/chart_tab.dart';
import 'package:futureetp/features/commodity/curve/curve_tab.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart' hide Curve;

import '../../../helpers/fake_http.dart';

/// 기준일 [baseDate]의 커브. 거래일은 10/14~10/21, D-1은 10/21.
Curve _curve(String baseDate, {List<CurvePoint>? points}) {
  const days = [
    '2026-10-14',
    '2026-10-15',
    '2026-10-16',
    '2026-10-19',
    '2026-10-20',
    '2026-10-21',
    '2026-10-22',
  ];
  final i = days.indexOf(baseDate);
  return Curve(
    freshness: Freshness(
      asOf: DateTime.utc(2026, 10, 22, 14),
      tradeDate: '2026-10-22',
      delayed: true,
      marketState: MarketState.open,
      nextUpdateAt: null,
    ),
    priceDecimals: 3,
    baseDate: baseDate,
    baseOffset: 5 - i,
    prevBaseDate: i > 0 ? days[i - 1] : null,
    nextBaseDate: i < 5 ? days[i + 1] : null,
    minBaseDate: days.first,
    maxBaseDate: '2026-10-21',
    compareDate: days[i + 1],
    points:
        points ??
        const [
          CurvePoint(
            symbol: 'NGX26',
            contractMonth: '2026-11',
            basePrice: 2.9,
            currentPrice: null,
            changePct: null,
          ),
          CurvePoint(
            symbol: 'NGZ26',
            contractMonth: '2026-12',
            basePrice: 3.1,
            currentPrice: 3.2,
            changePct: 3.2258,
          ),
          CurvePoint(
            symbol: 'NGF27',
            contractMonth: '2027-01',
            basePrice: 3.4,
            currentPrice: 3.3,
            changePct: -2.941,
          ),
          CurvePoint(
            symbol: 'NGG27',
            contractMonth: '2027-02',
            basePrice: null,
            currentPrice: 3.1,
            changePct: null,
          ),
        ],
    current: const CurveSpread(
      m1ContractMonth: '2026-12',
      m2ContractMonth: '2027-01',
      state: CurveState.contango,
      spreadPct: 3.1,
      rollYieldPct: -36.5,
    ),
    base: null,
  );
}

/// 기준일마다 [_curve]를 준다. 휴장일(10/17·10/18)은 10/16으로 옮긴다.
FakeResponse _respond(RequestOptions req) {
  final asked = req.queryParameters['baseDate'] as String?;
  _requested.add(asked);
  final date = switch (asked) {
    null => '2026-10-21',
    '2026-10-17' || '2026-10-18' => '2026-10-16',
    final d => d,
  };
  return FakeResponse.ok(_overrideCurve?.call(date) ?? _curve(date));
}

late List<String?> _requested;
Curve Function(String)? _overrideCurve;

Future<void> _pump(WidgetTester tester) async {
  _requested = [];
  tester.view
    ..physicalSize = const Size(1080, 2400)
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        upDownPaletteProvider.overrideWithValue(UpDownPalette.kr),
        apiClientProvider.overrideWithValue(
          ApiClient(
            Dio(BaseOptions(baseUrl: 'http://test/v1'))
              ..httpClientAdapter = FakeHttpAdapter(_respond),
            accessToken: () async => 'key',
            deviceId: () async => 'id',
          ),
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: appLocalizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: CurveTab(codeText: 'NG')),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

String _richText(WidgetTester tester, Key key) =>
    tester.widget<Text>(find.byKey(key)).data ?? '';

void main() {
  setUp(() => _overrideCurve = null);

  testWidgets('D-1 커브: 범례 날짜·롤 수익률, [+]·[↻] 없음, 기준일 버튼은 연도까지', (tester) async {
    await _pump(tester);
    expect(_requested, [null]);
    final legend = find.byKey(const Key('curve-legend'));
    expect(
      find.descendant(of: legend, matching: find.text('10/21')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: legend, matching: find.text('10/22')),
      findsOneWidget,
    );
    expect(
      _richText(tester, const Key('curve-roll-yield')),
      'Roll yield -36.5%/yr',
    );
    expect(find.text('2026/10/21'), findsOneWidget);
    expect(find.byKey(const Key('chart-reset')), findsNothing);
    // D-1이 상한이라 [+]는 눌러도 조회하지 않는다
    await tester.tap(find.byKey(const Key('curve-next')));
    await tester.pumpAndSettle();
    expect(_requested, [null]);
  });

  testWidgets('[−]로 기준일을 옮기면 [↻]이 뜨고, 누르면 D-1로 돌아간다', (tester) async {
    await _pump(tester);
    await tester.tap(find.byKey(const Key('curve-prev')));
    await tester.pumpAndSettle();
    expect(_requested.last, '2026-10-20');
    expect(find.text('2026/10/20'), findsOneWidget);
    expect(find.byKey(const Key('chart-reset')), findsOneWidget);

    // 다시 [+]로 D-1에 오면 기본 조회를 쓴다
    await tester.tap(find.byKey(const Key('curve-next')));
    await tester.pumpAndSettle();
    expect(find.text('2026/10/21'), findsOneWidget);
    expect(find.byKey(const Key('chart-reset')), findsNothing);

    await tester.tap(find.byKey(const Key('curve-prev')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('chart-reset')));
    await tester.pumpAndSettle();
    expect(find.text('2026/10/21'), findsOneWidget);
  });

  testWidgets('맨 앞 기준일이면 [−]가 비활성이다', (tester) async {
    _overrideCurve = (_) => _curve('2026-10-14');
    await _pump(tester);
    await tester.tap(find.byKey(const Key('curve-prev')));
    await tester.pumpAndSettle();
    expect(_requested, [null]);
  });

  testWidgets('길게 누르면 상세 박스: 월물·기준일 값·비교일 값·변화율', (tester) async {
    await _pump(tester);
    final chart = tester.getRect(find.byType(CurveChart));
    // 4칸 중 둘째(NGZ26)
    final g = await tester.startGesture(
      Offset(chart.left + 8 + (chart.width - 60) * 0.375, chart.center.dy),
    );
    await tester.pump(crosshairLongPress + const Duration(milliseconds: 50));
    await g.up();
    await tester.pump();
    final box = find.byKey(const Key('chart-detail'));
    expect(box, findsOneWidget);
    expect(
      find.descendant(of: box, matching: find.text('DEC26')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: box, matching: find.text('3.100')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: box, matching: find.text('3.200')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: box, matching: find.text('+3.2%')),
      findsOneWidget,
    );

    // 한 번 더 누르면 사라진다
    await tester.tapAt(chart.center);
    await tester.pump();
    expect(box, findsNothing);
  });

  testWidgets('시트에서 휴장일을 고르면 서버가 옮긴 날짜를 잠깐 안내한다', (tester) async {
    await _pump(tester);
    await tester.tap(find.byKey(const Key('curve-base-date')));
    await tester.pumpAndSettle();
    expect(find.text('Available: 2026/10/14 – 2026/10/21'), findsOneWidget);
    final picker = tester.widget<CupertinoDatePicker>(
      find.byKey(const Key('base-date-picker')),
    );
    picker.onDateTimeChanged(DateTime(2026, 10, 17));
    await tester.tap(find.byKey(const Key('base-date-confirm')));
    await tester.pumpAndSettle();
    expect(_requested.last, '2026-10-17');
    expect(find.text('2026/10/16'), findsOneWidget);
    expect(find.text('Market closed, moved to 10/16 (Fri)'), findsOneWidget);

    await tester.pump(curveMovedNotice);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('curve-moved')), findsNothing);
  });

  testWidgets('시트를 취소하면 기준일을 바꾸지 않는다', (tester) async {
    await _pump(tester);
    await tester.tap(find.byKey(const Key('curve-base-date')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(_requested, [null]);
  });

  testWidgets('월물이 없으면 안내 문구, 기준일 버튼은 남는다', (tester) async {
    _overrideCurve = (d) => _curve(d, points: const []);
    await _pump(tester);
    expect(find.byType(TabMessage), findsOneWidget);
    expect(find.text('No contracts to show.'), findsOneWidget);
    expect(find.byKey(const Key('curve-base-date')), findsOneWidget);
  });
}
