import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/services.dart';
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

/// 이전 3년을 받는 척 기다리는 시간(RN 실측 0.3~0.55초, D-106).
const spikeOlderDelay = Duration(milliseconds: 400);

class _ChartSpikeScreenState extends ConsumerState<ChartSpikeScreen>
    with SingleTickerProviderStateMixin {
  final _bars = SyntheticBars();
  final _stats = FrameStats();
  late CandleSeries _series = _bars.latest(_page);
  late final ValueNotifier<ChartViewport> _viewport = ValueNotifier(
    ChartViewport.latest(_series.length, _periods['6M']!),
  )..addListener(_maybeLoadOlder);
  var _loadingOlder = false;

  /// 측정용 자동 확대·축소: 42봉 ↔ 전체를 log 비율로 오간다(adb로는 핀치를 넣을 수 없다).
  late final AnimationController _bench =
      AnimationController(vsync: this, duration: const Duration(seconds: 3))
        ..addListener(() {
          final n = _series.length;
          final span = math.exp(
            math.log(42) + (math.log(n) - math.log(42)) * _bench.value,
          );
          _viewport.value = ChartViewport(
            count: n,
            start: n - span,
            span: span,
          ).clamped();
        });

  void _runBench() => _bench.repeat(reverse: true, count: 4);

  final _crosshair = ValueNotifier<int?>(null);

  @override
  void dispose() {
    _bench.dispose();
    _stats.dispose();
    _crosshair.dispose();
    _viewport.dispose();
    super.dispose();
  }

  /// 가장 과거 봉이 보이면 이전 3년을 앞에 붙인다. 받는 동안 햅틱 한 번, 터치 차단(D-104, D-108).
  void _maybeLoadOlder() {
    if (_loadingOlder ||
        !_viewport.value.showsOldest ||
        _series.length >= _bars.total) {
      return;
    }
    setState(() => _loadingOlder = true);
    HapticFeedback.lightImpact().ignore();
    unawaited(
      Future<void>.delayed(spikeOlderDelay, () {
        if (!mounted) return;
        final before = _series.length;
        final next = _bars.latest(before + _page);
        final added = next.length - before;
        setState(() {
          _series = next;
          _loadingOlder = false;
        });
        // 붙인 뒤에도 보던 날짜 범위는 그대로다
        _viewport.value = _viewport.value.prepended(added);
        final i = _crosshair.value;
        if (i != null) _crosshair.value = i + added;
      }),
    );
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
              child: Stack(
                children: [
                  CandleChart(
                    key: const Key('chart-spike-chart'),
                    series: _series,
                    viewport: _viewport,
                    crosshair: _crosshair,
                    palette: palette,
                    locked: _loadingOlder,
                  ),
                  if (_loadingOlder)
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        child: CircularProgressIndicator(
                          key: Key('chart-spike-older'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: AppSize.touchTarget,
              child: Row(
                children: [
                  IconButton(
                    key: const Key('chart-spike-bench'),
                    onPressed: _runBench,
                    icon: const Icon(Icons.play_arrow),
                  ),
                  for (final MapEntry(:key, :value) in _periods.entries)
                    Expanded(
                      child: TextButton(
                        onPressed: _loadingOlder ? null : () => _period(value),
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
