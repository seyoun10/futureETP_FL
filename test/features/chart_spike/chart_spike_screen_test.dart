import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/charts/candle_painter.dart';
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
    final paint = tester.widget<CustomPaint>(
      find.byKey(const Key('chart-spike-canvas')),
    );
    final viewport = (paint.painter! as CandlePainter).viewport;
    expect(viewport.value.span, 126);

    await tester.tap(find.text('12M'));
    await tester.pump();
    expect(viewport.value.span, 252);
    expect(viewport.value.end, 756);
    // FrameStats 타이머를 멈춘다
    await tester.pumpWidget(const SizedBox());
  });
}
