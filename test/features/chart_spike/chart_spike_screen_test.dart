import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/charts/candle_chart.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:futureetp/features/chart_spike/chart_spike_screen.dart';
import 'package:futureetp/features/chart_spike/synthetic_bars.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('합성 봉: 고가 ≥ 시가·종가 ≥ 저가 > 0, 이평선은 200봉째부터', () {
    final s = SyntheticBars().latest(4000);
    for (var i = 0; i < s.length; i++) {
      expect(s.highs[i], greaterThanOrEqualTo(s.opens[i]));
      expect(s.highs[i], greaterThanOrEqualTo(s.closes[i]));
      expect(s.lows[i], lessThanOrEqualTo(s.opens[i]));
      expect(s.lows[i], greaterThan(0));
    }
    final ma = s.lines.last.values;
    expect(ma[198], isNaN);
    expect(ma[199], isNotNaN);
    expect(s.lines, hasLength(11));
  });

  testWidgets('봉 756개를 그리고 기간 버튼으로 범위를 바꾼다', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [upDownPaletteProvider.overrideWithValue(UpDownPalette.kr)],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChartSpikeScreen(),
        ),
      ),
    );
    final viewport = tester
        .widget<CandleChart>(find.byType(CandleChart))
        .viewport;
    expect(viewport.value.span, 126);

    await tester.tap(find.text('12M'));
    await tester.pump();
    expect(viewport.value.span, 252);
    expect(viewport.value.end, 756);
    // FrameStats 타이머를 멈춘다
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('가장 과거 봉이 보이면 이전 3년을 앞에 붙이고, 보던 범위는 그대로다', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [upDownPaletteProvider.overrideWithValue(UpDownPalette.kr)],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChartSpikeScreen(),
        ),
      ),
    );
    final chart = find.byType(CandleChart);
    final viewport = tester.widget<CandleChart>(chart).viewport;
    // 한 번에 가장 과거까지 끈다
    final g = await tester.startGesture(tester.getCenter(chart));
    for (var i = 0; i < 20; i++) {
      await g.moveBy(const Offset(400, 0));
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(viewport.value.start, 0);
    expect(find.byKey(const Key('chart-spike-older')), findsOneWidget);
    expect(tester.widget<CandleChart>(chart).locked, isTrue);
    await g.up();

    final seen = viewport.value;
    await tester.pump(spikeOlderDelay);
    expect(find.byKey(const Key('chart-spike-older')), findsNothing);
    expect(tester.widget<CandleChart>(chart).series.length, 1512);
    expect(viewport.value.count, 1512);
    expect(viewport.value.start, seen.start + 756);
    expect(viewport.value.span, seen.span);
    await tester.pumpWidget(const SizedBox());
  });
}
