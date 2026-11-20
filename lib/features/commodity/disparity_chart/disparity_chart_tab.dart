import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/app_error.dart';
import 'package:futureetp/core/api/error_text.dart';
import 'package:futureetp/core/api/models/disparity_chart.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/charts/chart_decor.dart';
import 'package:futureetp/core/charts/chart_detail.dart';
import 'package:futureetp/core/charts/chart_layout.dart';
import 'package:futureetp/core/charts/chart_skeleton.dart';
import 'package:futureetp/core/charts/chart_viewport.dart';
import 'package:futureetp/core/charts/price_chart.dart';
import 'package:futureetp/core/settings/device_settings.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:futureetp/core/util/format_date_time.dart';
import 'package:futureetp/core/util/format_number.dart';
import 'package:futureetp/core/widgets/query_state_view.dart';
import 'package:futureetp/features/commodity/chart_busy.dart';
import 'package:futureetp/features/commodity/chart_tab.dart';
import 'package:futureetp/features/commodity/disparity_chart/disparity_chart_provider.dart';
import 'package:futureetp/features/commodity/disparity_chart/disparity_model.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// C-a 이격도차트 탭(screens.md C-a, D-086, RN `DisparityChartScreen`).
class DisparityChartTab extends ConsumerWidget {
  const new({super.key, required this.codeText});

  /// 경로의 원자재 코드. 모르는 값이면 NOT_FOUND 문구다.
  final String codeText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = CommodityCode.fromWire(codeText);
    if (code == null) {
      return TabMessage(
        errorText(
          AppLocalizations.of(context),
          const AppError(AppErrorCode.notFound),
        ),
      );
    }
    final provider = disparityChartProvider(code);
    return ColoredBox(
      color: AppColors.background,
      child: QueryStateView(
        value: ref.watch(provider),
        // 설정을 못 읽어 실패했을 수 있어 설정도 다시 받는다
        onRetry: () => ref
          ..invalidate(deviceSettingsProvider)
          ..invalidate(provider),
        skeleton: const ChartSkeleton(footer: ChartSkeletonFooter.periods),
        builder: (context, data) =>
            _DisparityChartView(key: ValueKey(code), code: code, data: data),
      ),
    );
  }
}

class _DisparityChartView extends ConsumerStatefulWidget {
  const new({super.key, required this.code, required this.data});

  final CommodityCode code;
  final DisparityData data;

  @override
  ConsumerState<_DisparityChartView> createState() =>
      _DisparityChartViewState();
}

/// 정보 줄 글자.
const _lineStyle = TextStyle(
  color: AppColors.text,
  fontSize: AppFontSize.caption,
  fontFeatures: [FontFeature.tabularFigures()],
);

class _DisparityChartViewState extends ConsumerState<_DisparityChartView>
    with ChartTabState {
  late DisparityModel _model = DisparityModel.from(widget.data.chart);
  var _hintOpen = false;

  @override
  int get barCount => _model.bars.length;

  @override
  bool get hasMore => widget.data.chart.hasMore;

  @override
  Future<void> loadOlder() =>
      ref.read(disparityChartProvider(widget.code).notifier).loadOlder();

  @override
  void didUpdateWidget(_DisparityChartView old) {
    super.didUpdateWidget(old);
    if (identical(old.data.chart, widget.data.chart)) return;
    final oldFirst = _model.bars.firstOrNull?.tradeDate;
    _model = DisparityModel.from(widget.data.chart);
    dataChanged(
      prependShift(oldFirst, [for (final b in _model.bars) b.tradeDate]),
    );
  }

  // 축·라벨 입력. 모델·언어가 바뀔 때만 새로 만든다(같은 객체면 다시 그리기만)
  ChartDecor? _decor;
  (DisparityModel, AppLocalizations)? _decorKey;

  ChartDecor _decorFor(AppLocalizations l10n) {
    final key = (_model, l10n);
    if (_decor != null &&
        identical(_decorKey?.$1, key.$1) &&
        identical(_decorKey?.$2, key.$2)) {
      return _decor!;
    }
    _decorKey = key;
    return _decor = disparityDecor(
      _model,
      widget.data.chart.priceDecimals,
      l10n,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_model.bars.isEmpty) return TabMessage(l10n.disparityNoData);
    final palette = ref.watch(upDownPaletteProvider);
    // 차단 상태를 C 껍데기 밖(탭만 띄운 테스트)에서도 살려 둔다
    ref.watch(chartBusyProvider);
    final chart = widget.data.chart;
    final decimals = chart.priceDecimals;
    // 위 정보 줄 두 개 높이. 봉·선은 이만큼 비켜 그리고 격자는 뒤까지 이어진다(D-117)
    final lineHeight = chartInfoLineHeight(context);
    final decor = _decorFor(l10n);
    final series = _model.series;
    // y축 라벨 자리: 가장 넓은 가격 글자 + 여백
    final yAxis = yAxisWidth([
      formatPrice(series.envelopeHigh.reduce(math.max), decimals),
      formatPrice(series.envelopeLow.reduce(math.min), decimals),
    ]);
    final padding = EdgeInsets.only(
      top: lineHeight * 2,
      right: yAxis,
      bottom: xLabelHeight,
    );
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: PriceChart(
                  key: const Key('disparity-chart'),
                  series: _model.series,
                  viewport: viewport,
                  crosshair: crosshair,
                  palette: palette,
                  padding: padding,
                  onGesture: onGesture,
                  onGestureEnd: maybeLoadOlder,
                  locked: loadingOlder,
                  formatPrice: (p) => formatPrice(p, decimals),
                  decor: decor,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: ColoredBox(
                  color: AppColors.overlay,
                  child: Column(
                    children: [
                      _TodayLine(
                        chart: chart,
                        today: _model.bars.last,
                        onToggleHint: () =>
                            setState(() => _hintOpen = !_hintOpen),
                      ),
                      // 보이는 봉이 바뀌면 저점대비·고점대비를 바로 갱신한다
                      IgnorePointer(
                        child: ValueListenableBuilder(
                          valueListenable: viewport,
                          builder: (context, v, _) => _StatsLine(
                            chart: chart,
                            bars: _model.bars,
                            viewport: v,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: ChartDetailOverlay(
                  series: _model.series,
                  viewport: viewport,
                  crosshair: crosshair,
                  padding: padding,
                  builder: (context, index) => _CrosshairDetail(
                    model: _model,
                    chart: chart,
                    index: index,
                  ),
                ),
              ),
              ...chartOverlays(),
              if (_hintOpen)
                Positioned(
                  left: 0,
                  right: 0,
                  top: lineHeight,
                  child: _BasisHint(
                    code: widget.code,
                    chart: chart,
                    requestedBasis: widget.data.params.basis,
                    onClose: () => setState(() => _hintOpen = false),
                  ),
                ),
            ],
          ),
        ),
        ?periodChips(context),
      ],
    );
  }
}

/// 상단 첫 줄: 기준값 · 오늘 시고저종. 기준값을 누르면 안내([_BasisHint])를 여닫는다.
class _TodayLine extends StatelessWidget {
  const new({
    required this.chart,
    required this.today,
    required this.onToggleHint,
  });

  final DisparityChart chart;
  final DisparityBar today;
  final VoidCallback onToggleHint;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final basisName = basisText(l10n, chart.basis);
    var basisLabel = chart.fallback
        ? l10n.disparityBasisFallback(basisName)
        : basisName;
    if (chart.basis == Basis.front) {
      if (today.holdings.firstOrNull?.contractMonth case final month?) {
        basisLabel = '$basisLabel ${formatContractMonth(month)}';
      }
    } else if (today.inRoll) {
      basisLabel = l10n.disparityBasisInRoll(basisName);
    }
    final d = chart.priceDecimals;
    final ohlc = [
      '${l10n.disparityOpen}${formatPrice(today.open!, d)}',
      '${l10n.disparityHigh}${formatPrice(today.high!, d)}',
      '${l10n.disparityLow}${formatPrice(today.low!, d)}',
      '${l10n.disparityClose}${formatPrice(today.close!, d)}',
    ].join(' ');
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: Text.rich(
        key: const Key('disparity-today'),
        TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: GestureDetector(
                key: const Key('disparity-basis'),
                onTap: onToggleHint,
                child: Text(
                  basisLabel,
                  style: _lineStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            TextSpan(text: ' · $ohlc'),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: _lineStyle,
      ),
    );
  }
}

/// 기준값 안내. 첫 줄 바로 아래, 둘째 줄 위에 띄운다(RN `position: absolute`).
/// 줄 띠 안에 끼우면 둘째 줄이 밀려 봉과 겹친다. 누르면 닫힌다.
class _BasisHint extends StatelessWidget {
  const new({
    required this.code,
    required this.chart,
    required this.requestedBasis,
    required this.onClose,
  });

  final CommodityCode code;
  final DisparityChart chart;
  final Basis requestedBasis;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final basisName = basisText(l10n, chart.basis);
    final hints = [
      if (chart.basis == Basis.front)
        l10n.disparityHintFront
      else
        l10n.disparityHintAdjusted(basisName),
      if (chart.fallback && requestedBasis != Basis.front)
        l10n.disparityHintFallback(basisText(l10n, requestedBasis)),
      // 금·은은 미국형과 한국형이 같은 지수다(D-014)
      if (chart.basis == Basis.us &&
          (code == CommodityCode.gc || code == CommodityCode.si))
        l10n.disparityHintSameAsKr,
    ];
    return GestureDetector(
      key: const Key('disparity-hint'),
      onTap: onClose,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xs,
          children: [for (final hint in hints) Text(hint, style: _lineStyle)],
        ),
      ),
    );
  }
}

/// 기준값 이름.
String basisText(AppLocalizations l10n, Basis basis) => switch (basis) {
  Basis.front => l10n.basisFront,
  Basis.kr => l10n.basisKr,
  Basis.us => l10n.basisUs,
};

/// 상단 둘째 줄: 이격도(꼬리 백분위) · 저점대비 · 고점대비. LC·HC는 보이는 봉 기준이다.
class _StatsLine extends StatelessWidget {
  const new({required this.chart, required this.bars, required this.viewport});

  final DisparityChart chart;
  final List<DisparityBar> bars;
  final ChartViewport viewport;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final today = bars.last;
    // 몸통이 화면에 걸친 봉까지 센다(y 맞춤과 같은 범위, RN `visibleRange`)
    final stats = visibleStats(
      bars,
      viewport.first.clamp(0, bars.length - 1),
      viewport.last.clamp(0, bars.length - 1),
    );
    final tail = switch (chart.currentTail) {
      null => '',
      final t => switch (t.side) {
        Direction.up => ' (${l10n.disparityTailUp(formatTailPct(t.pct))})',
        Direction.down => ' (${l10n.disparityTailDown(formatTailPct(t.pct))})',
      },
    };
    final items = [
      if (today.disparity case final value?)
        l10n.disparityValue(formatDisparity(value)) + tail,
      if (stats != null) ...[
        l10n.disparityFromLow(formatChangePct(stats.fromLowPct)),
        l10n.disparityFromHigh(formatChangePct(stats.fromHighPct)),
      ],
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: Text(
        items.join(' · '),
        key: const Key('disparity-stats'),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: _lineStyle,
      ),
    );
  }
}

/// C-a 축·라벨 입력(RN `priceLabelsAt`·`ExtremeTagsLayer`·`RollLayer`).
ChartDecor disparityDecor(
  DisparityModel model,
  int decimals,
  AppLocalizations l10n,
) {
  final bars = model.bars;
  final current = bars.last.close!;
  return ChartDecor(
    dates: [for (final b in bars) b.tradeDate],
    priceDecimals: decimals,
    monthLabel: (year, month) => monthLabel(l10n, year, month),
    // 이평선·rare-level 값은 보이는 마지막 봉 기준, 선 색으로 쓴다
    labelsIn: (_, index) => [
      for (final l in model.lines)
        if (!l.line.values[index].isNaN)
          (price: l.line.values[index], color: l.line.color),
    ],
    extremeText: (kind, index) {
      final bar = bars[index];
      final price = kind == ExtremeKind.high ? bar.high! : bar.low!;
      final p = formatPrice(price, decimals);
      final pct = formatChangePct((price / current - 1) * 100);
      final date = formatTradeDate(bar.tradeDate);
      return kind == ExtremeKind.high
          ? l10n.chartHighTag(p, pct, date)
          : l10n.chartLowTag(p, pct, date);
    },
    rollShading: model.rollShading,
    switches: model.frontSwitchAt.keys.toList(),
  );
}

/// 십자선 상세: 날짜·월물 구성, 시고저종, 전일 대비, 이격도, 이평선·rare-level 값(screens.md C-a).
/// 전일 대비·이격도는 부호대로 등락 색, 선 값은 가격 높은 순으로 선 색이다.
class _CrosshairDetail extends ConsumerWidget {
  const new({required this.model, required this.chart, required this.index});

  final DisparityModel model;
  final DisparityChart chart;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final palette = ref.watch(upDownPaletteProvider);
    final bar = model.bars[index];
    final prev = index > 0 ? model.bars[index - 1] : null;
    final d = chart.priceDecimals;
    final current = holdingsText(bar, chart.basis);
    // 대표월물 전환일 봉이면 새 월물명을 이어 쓴다(차트에는 세로 점선만 있다, D-103)
    final switchTo = model.frontSwitchAt[index];
    final holdings = switchTo != null && current != null
        ? '$current → $switchTo'
        : current;
    String lineName(LineLabel label) => switch (label) {
      MaLabel() => l10n.disparityMa('${chart.maPeriod.days}'),
      BandLabel(:final direction, :final level) => switch (direction) {
        Direction.up => l10n.disparityTailUp(_levelText(level)),
        Direction.down => l10n.disparityTailDown(_levelText(level)),
      },
    };
    final lineValues = [
      for (final l in model.lines)
        if (!l.line.values[index].isNaN)
          (label: l.label, price: l.line.values[index], color: l.line.color),
    ]..sort((a, b) => b.price.compareTo(a.price));
    Widget half(String label, double value) => Expanded(
      child: DetailRow(label: label, value: formatPrice(value, d)),
    );
    return DetailBox(
      children: [
        DetailRow(label: bar.tradeDate, value: holdings),
        Row(
          spacing: AppSpacing.md,
          children: [
            half(l10n.disparityOpen, bar.open!),
            half(l10n.disparityHigh, bar.high!),
          ],
        ),
        Row(
          spacing: AppSpacing.md,
          children: [
            half(l10n.disparityClose, bar.close!),
            half(l10n.disparityLow, bar.low!),
          ],
        ),
        if (prev != null)
          DetailRow(
            label: l10n.disparityPrevChange,
            value:
                '${formatChange(bar.close! - prev.close!, d)} '
                '(${formatChangePct((bar.close! / prev.close! - 1) * 100)})',
            color: changePairColor(
              bar.close! - prev.close!,
              (bar.close! / prev.close! - 1) * 100,
              d,
              palette,
            ),
          ),
        if (bar.disparity case final value?)
          DetailRow(
            label: l10n.disparityLabel,
            value: formatDisparity(value),
            color: changeColor(value, palette, decimals: 1),
          ),
        for (final l in lineValues)
          DetailRow(
            label: lineName(l.label),
            value: formatPrice(l.price, d),
            color: l.color,
          ),
      ],
    );
  }
}

/// rare 레벨 값(`1`, `2.5`). JS 숫자 표기와 같다.
String _levelText(double v) =>
    v == v.truncateToDouble() ? '${v.toInt()}' : '$v';
