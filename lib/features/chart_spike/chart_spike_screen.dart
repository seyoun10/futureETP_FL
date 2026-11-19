import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/charts/candle_chart.dart';
import 'package:futureetp/core/charts/candle_series.dart';
import 'package:futureetp/core/charts/chart_viewport.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:futureetp/features/chart_spike/frame_stats.dart';
import 'package:futureetp/features/chart_spike/synthetic_bars.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// 4단계 C-a 차트 스파이크 화면(dev 경로 `/dev/chart-spike`). 스파이크가 끝나면 지운다.
class ChartSpikeScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ChartSpikeScreen> createState() => _ChartSpikeScreenState();
}

/// 기간 버튼 봉 수(월 21거래일, RN `PERIOD_BARS`).
const _periods = {
  '2M': 42,
  '4M': 84,
  '6M': 126,
  '8M': 168,
  '10M': 210,
  '12M': 252,
};

/// 처음 받는 봉 수(3년, D-104).
const _page = 756;

class _ChartSpikeScreenState extends ConsumerState<ChartSpikeScreen> {
  final _bars = SyntheticBars();
  final _stats = FrameStats();
  late final CandleSeries _series = _bars.latest(_page);
  late final ValueNotifier<ChartViewport> _viewport = ValueNotifier(
    ChartViewport.latest(_series.length, _periods['6M']!),
  );

  final _crosshair = ValueNotifier<int?>(null);

  @override
  void dispose() {
    _stats.dispose();
    _crosshair.dispose();
    _viewport.dispose();
    super.dispose();
  }

  // 기간을 바꾸면 십자선도 지운다(screens.md C-a)
  void _period(int bars) {
    _viewport.value = ChartViewport.latest(_series.length, bars);
    _crosshair.value = null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = ref.watch(upDownPaletteProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.devChartSpikeTitle)),
      body: SafeArea(
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: _stats,
              builder: (context, s, _) => Text(
                l10n.devChartSpikeStats(
                  s.fps,
                  s.worstMs.toStringAsFixed(1),
                  _series.length,
                ),
                style: const TextStyle(color: ChartColors.tick),
              ),
            ),
            Expanded(
              child: CandleChart(
                key: const Key('chart-spike-chart'),
                series: _series,
                viewport: _viewport,
                crosshair: _crosshair,
                palette: palette,
              ),
            ),
            SizedBox(
              height: AppSize.touchTarget,
              child: Row(
                children: [
                  for (final MapEntry(:key, :value) in _periods.entries)
                    Expanded(
                      child: TextButton(
                        onPressed: () => _period(value),
                        child: Text(key),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
