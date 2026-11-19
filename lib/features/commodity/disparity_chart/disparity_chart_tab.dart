import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/app_error.dart';
import 'package:futureetp/core/api/error_text.dart';
import 'package:futureetp/core/api/models/disparity_chart.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/charts/candle_chart.dart';
import 'package:futureetp/core/charts/chart_decor.dart';
import 'package:futureetp/core/charts/chart_detail.dart';
import 'package:futureetp/core/charts/chart_layout.dart';
import 'package:futureetp/core/charts/chart_periods.dart';
import 'package:futureetp/core/charts/chart_viewport.dart';
import 'package:futureetp/core/charts/period_chips.dart';
import 'package:futureetp/core/settings/device_settings.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:futureetp/core/util/failed_alert.dart';
import 'package:futureetp/core/util/format_date_time.dart';
import 'package:futureetp/core/util/format_number.dart';
import 'package:futureetp/core/util/orientation.dart';
import 'package:futureetp/core/widgets/query_state_view.dart';
import 'package:futureetp/features/commodity/chart_busy.dart';
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

/// 이전 3년 받기가 이 시간 안에 끝나지 않으면 로딩·차단을 거두고 실패 Alert를 띄운다(D-139).
const olderLoadTimeout = Duration(seconds: 5);

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

  // 이전 3년 받기(D-104, D-108, D-139). 회차 번호로 시간 초과로 거둔 회차의 늦은 응답이
  // 상태를 다시 바꾸지 않게 한다(데이터는 Provider가 그대로 붙인다)
  var _loadingOlder = false;
  var _olderRun = 0;
  Timer? _olderTimer;
  late final ChartBusyNotifier _busy = ref.read(chartBusyProvider.notifier);

  @override
  void initState() {
    super.initState();
    _viewport.addListener(_maybeLoadOlder);
  }

  /// 가장 과거 봉이 화면에 보이고 더 받을 것이 있으면 이전 3년을 받는다.
  void _maybeLoadOlder() {
    if (_loadingOlder ||
        !_viewport.value.showsOldest ||
        !widget.data.chart.hasMore) {
      return;
    }
    final id = ++_olderRun;
    HapticFeedback.lightImpact().ignore();
    setState(() => _loadingOlder = true);
    _busy.set(busy: true);
    _olderTimer = Timer(olderLoadTimeout, () => _finishOlder(id, failed: true));
    ref
        .read(disparityChartProvider(widget.code).notifier)
        .loadOlder()
        .then(
          (_) => _finishOlder(id, failed: false),
          onError: (Object _) => _finishOlder(id, failed: true),
        )
        .ignore();
  }

  void _finishOlder(int id, {required bool failed}) {
    if (id != _olderRun || !mounted) return;
    _olderRun++;
    _olderTimer?.cancel();
    setState(() => _loadingOlder = false);
    _busy.set(busy: false);
    if (failed) {
      final l10n = AppLocalizations.of(context);
      showFailedAlert(
        context,
        l10n.chartOlderFailedTitle,
        l10n.chartOlderFailedMessage,
      );
    }
  }

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
    _olderRun++;
    _olderTimer?.cancel();
    if (_loadingOlder) _busy.set(busy: false);
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
    // 차단 상태를 C 껍데기 밖(탭만 띄운 테스트)에서도 살려 둔다
    ref.watch(chartBusyProvider);
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
                  onGestureEnd: _maybeLoadOlder,
                  locked: _loadingOlder,
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
              Positioned.fill(
                child: ChartDetailOverlay(
                  series: _model.series,
                  viewport: _viewport,
                  crosshair: _crosshair,
                  padding: padding,
                  builder: (context, index) => _CrosshairDetail(
                    model: _model,
                    chart: chart,
                    index: index,
                  ),
                ),
              ),
              // 이전 3년을 받는 동안 차트 왼쪽 가운데 로딩 표시
              if (_loadingOlder)
                const Positioned.fill(
                  child: IgnorePointer(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: AppSpacing.lg),
                        child: _OlderIndicator(),
                      ),
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

/// 이전 3년 받기 로딩 표시(RN `OlderDataIndicator`).
class _OlderIndicator extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Semantics(
    label: AppLocalizations.of(context).loading,
    child: Container(
      key: const Key('older-loading'),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.overlay,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
      ),
      child: const SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.text),
      ),
    ),
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
