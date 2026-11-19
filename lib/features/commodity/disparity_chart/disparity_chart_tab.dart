import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/app_error.dart';
import 'package:futureetp/core/api/error_text.dart';
import 'package:futureetp/core/api/models/disparity_chart.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/charts/candle_chart.dart';
import 'package:futureetp/core/charts/chart_decor.dart';
import 'package:futureetp/core/charts/chart_layout.dart';
import 'package:futureetp/core/charts/chart_periods.dart';
import 'package:futureetp/core/charts/chart_viewport.dart';
import 'package:futureetp/core/charts/period_chips.dart';
import 'package:futureetp/core/settings/device_settings.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:futureetp/core/util/format_date_time.dart';
import 'package:futureetp/core/util/format_number.dart';
import 'package:futureetp/core/util/orientation.dart';
import 'package:futureetp/core/widgets/query_state_view.dart';
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
        builder: (context, data) =>
            _DisparityChartView(key: ValueKey(code), code: code, data: data),
      ),
    );
  }
}

/// 탭 가운데 안내 문구(없는 원자재, 값 없음).
class TabMessage extends StatelessWidget {
  const new(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: AppFontSize.body,
        ),
      ),
    ),
  );
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

class _DisparityChartViewState extends ConsumerState<_DisparityChartView> {
  late DisparityModel _model = DisparityModel.from(widget.data.chart);

  /// 고른 기간. C-a 탭이 떠 있는 동안(C 화면) 기억한다(D-107).
  ChartPeriod _period = ChartPeriod.initial;

  /// 제스처로 범위를 바꿨는지. 핀치면 기간 칩 선택 표시를 지운다. null이면 기간의 최근 위치다.
  ChartGesture? _gesture;

  late final ValueNotifier<ChartViewport> _viewport = ValueNotifier(
    ChartViewport.latest(_model.bars.length, _period.bars),
  );
  final _crosshair = ValueNotifier<int?>(null);

  @override
  void didUpdateWidget(_DisparityChartView old) {
    super.didUpdateWidget(old);
    if (identical(old.data.chart, widget.data.chart)) return;
    final before = _model;
    _model = DisparityModel.from(widget.data.chart);
    final count = _model.bars.length;
    // 과거 봉이 앞에 붙었으면 보던 날짜 범위를 그대로 둔다(D-104)
    final oldFirst = before.bars.firstOrNull?.tradeDate;
    final shift = oldFirst == null
        ? -1
        : _model.bars.indexWhere((b) => b.tradeDate == oldFirst);
    if (_gesture == null) {
      _viewport.value = ChartViewport.latest(count, _period.bars);
    } else if (shift > 0) {
      _viewport.value = _viewport.value.prepended(shift);
    } else {
      _viewport.value = ChartViewport(
        count: count,
        start: _viewport.value.start,
        span: _viewport.value.span,
      ).clamped();
    }
    final i = _crosshair.value;
    if (i != null) {
      _crosshair.value = shift > 0 && i + shift < count ? i + shift : null;
    }
  }

  @override
  void dispose() {
    _viewport.dispose();
    _crosshair.dispose();
    super.dispose();
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

  ChartViewport get _periodView =>
      ChartViewport.latest(_model.bars.length, _period.bars);

  void _selectPeriod(ChartPeriod period) {
    setState(() {
      _period = period;
      _gesture = null;
    });
    _viewport.value = _periodView;
    _crosshair.value = null;
  }

  void _resetView() {
    setState(() => _gesture = null);
    _viewport.value = _periodView;
    _crosshair.value = null;
  }

  /// 끌어서 기간의 최근 위치로 돌아오면 [↻]를 거두고 선택 표시를 되살린다.
  /// 한 번 핀치하면 이후 드래그해도 선택 표시를 되살리지 않는다.
  void _onGesture(ChartGesture gesture) {
    final back = _sameView(_viewport.value, _periodView);
    final next = back
        ? null
        : (_gesture == ChartGesture.zoom ? ChartGesture.zoom : gesture);
    if (next != _gesture) setState(() => _gesture = next);
  }

  static bool _sameView(ChartViewport a, ChartViewport b) =>
      a.count == b.count &&
      (a.start - b.start).abs() < 1e-6 &&
      (a.span - b.span).abs() < 1e-6;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_model.bars.isEmpty) return TabMessage(l10n.disparityNoData);
    final palette = ref.watch(upDownPaletteProvider);
    final chart = widget.data.chart;
    final decimals = chart.priceDecimals;
    final landscape = isLandscape(context);
    final textScaler = MediaQuery.textScalerOf(context);
    // 위 정보 줄 두 개 높이. 봉·선은 이만큼 비켜 그리고 격자는 뒤까지 이어진다(D-117)
    final lineHeight =
        textScaler.scale(AppFontSize.caption) * 1.4 + AppSpacing.xs * 2;
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
                child: CandleChart(
                  key: const Key('disparity-chart'),
                  series: _model.series,
                  viewport: _viewport,
                  crosshair: _crosshair,
                  palette: palette,
                  padding: padding,
                  onGesture: _onGesture,
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
                        code: widget.code,
                        chart: chart,
                        today: _model.bars.last,
                        requestedBasis: widget.data.params.basis,
                      ),
                      // 보이는 봉이 바뀌면 저점대비·고점대비를 바로 갱신한다
                      IgnorePointer(
                        child: ValueListenableBuilder(
                          valueListenable: _viewport,
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
              if (_gesture != null)
                Positioned(
                  left: 0,
                  right: yAxis,
                  bottom: xLabelHeight + AppSpacing.sm,
                  child: Center(child: ChartResetButton(onPressed: _resetView)),
                ),
            ],
          ),
        ),
        // 가로 모드에서는 차트만 남긴다(D-103)
        if (!landscape)
          ValueListenableBuilder(
            valueListenable: _viewport,
            builder: (context, v, _) => PeriodChips(
              selected: _gesture == ChartGesture.zoom ? null : _period,
              nearest: _gesture == ChartGesture.zoom
                  ? nearestPeriod(v.span, v.count)
                  : null,
              onSelect: _selectPeriod,
            ),
          ),
      ],
    );
  }
}

/// 상단 첫 줄: 기준값 · 오늘 시고저종. 기준값을 누르면 안내가 열린다.
class _TodayLine extends StatefulWidget {
  const new({
    required this.code,
    required this.chart,
    required this.today,
    required this.requestedBasis,
  });

  final CommodityCode code;
  final DisparityChart chart;
  final DisparityBar today;
  final Basis requestedBasis;

  @override
  State<_TodayLine> createState() => _TodayLineState();
}

class _TodayLineState extends State<_TodayLine> {
  var _hintOpen = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chart = widget.chart;
    final today = widget.today;
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
    final hints = [
      if (chart.basis == Basis.front)
        l10n.disparityHintFront
      else
        l10n.disparityHintAdjusted(basisName),
      if (chart.fallback && widget.requestedBasis != Basis.front)
        l10n.disparityHintFallback(basisText(l10n, widget.requestedBasis)),
      // 금·은은 미국형과 한국형이 같은 지수다(D-014)
      if (chart.basis == Basis.us &&
          (widget.code == CommodityCode.gc || widget.code == CommodityCode.si))
        l10n.disparityHintSameAsKr,
    ];
    final d = chart.priceDecimals;
    final ohlc = [
      '${l10n.disparityOpen}${formatPrice(today.open!, d)}',
      '${l10n.disparityHigh}${formatPrice(today.high!, d)}',
      '${l10n.disparityLow}${formatPrice(today.low!, d)}',
      '${l10n.disparityClose}${formatPrice(today.close!, d)}',
    ].join(' ');
    return Column(
      children: [
        Padding(
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
                    onTap: () => setState(() => _hintOpen = !_hintOpen),
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
        ),
        if (_hintOpen)
          GestureDetector(
            key: const Key('disparity-hint'),
            onTap: () => setState(() => _hintOpen = false),
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
                children: [
                  for (final hint in hints) Text(hint, style: _lineStyle),
                ],
              ),
            ),
          ),
      ],
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
    // 가운데(꼬리)가 화면 안에 있는 봉만 센다
    final stats = visibleStats(
      bars,
      viewport.start.ceil().clamp(0, bars.length - 1),
      (viewport.end - 1).floor().clamp(0, bars.length - 1),
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
    labelsAt: (index) => [
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

/// x축 월 라벨: 1월은 연도, 나머지는 월 이름(D-121).
String monthLabel(AppLocalizations l10n, int year, int month) =>
    month == 1 ? '$year' : l10n.chartMonth('$month');
