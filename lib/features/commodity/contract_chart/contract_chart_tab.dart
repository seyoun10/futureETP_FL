import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/app_error.dart';
import 'package:futureetp/core/api/error_text.dart';
import 'package:futureetp/core/api/models/contracts_chart.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/charts/chart_decor.dart';
import 'package:futureetp/core/charts/chart_detail.dart';
import 'package:futureetp/core/charts/chart_layout.dart';
import 'package:futureetp/core/charts/chart_skeleton.dart';
import 'package:futureetp/core/charts/legend_line.dart';
import 'package:futureetp/core/charts/price_chart.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:futureetp/core/util/format_number.dart';
import 'package:futureetp/core/widgets/query_state_view.dart';
import 'package:futureetp/features/commodity/chart_busy.dart';
import 'package:futureetp/features/commodity/chart_tab.dart';
import 'package:futureetp/features/commodity/contract_chart/contract_chart_provider.dart';
import 'package:futureetp/features/commodity/contract_chart/contract_model.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// C-c 월물차트 탭(screens.md C-c, D-092, RN `ContractChartScreen`).
class ContractChartTab extends ConsumerWidget {
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
    final provider = contractChartProvider(code);
    return ColoredBox(
      color: AppColors.background,
      child: QueryStateView(
        value: ref.watch(provider),
        onRetry: () => ref.invalidate(provider),
        skeleton: const ChartSkeleton(footer: ChartSkeletonFooter.periods),
        builder: (context, chart) =>
            _ContractChartView(key: ValueKey(code), code: code, chart: chart),
      ),
    );
  }
}

class _ContractChartView extends ConsumerStatefulWidget {
  const new({super.key, required this.code, required this.chart});

  final CommodityCode code;
  final ContractsChart chart;

  @override
  ConsumerState<_ContractChartView> createState() => _ContractChartViewState();
}

class _ContractChartViewState extends ConsumerState<_ContractChartView>
    with ChartTabState {
  // 기간 선택은 C-a와 따로 기억한다(이 탭 State, D-107)
  late ContractModel? _model = ContractModel.from(widget.chart);

  @override
  int get barCount => widget.chart.dates.length;

  @override
  bool get hasMore => widget.chart.hasMore;

  @override
  Future<void> loadOlder() =>
      ref.read(contractChartProvider(widget.code).notifier).loadOlder();

  @override
  void didUpdateWidget(_ContractChartView old) {
    super.didUpdateWidget(old);
    if (identical(old.chart, widget.chart)) return;
    _model = ContractModel.from(widget.chart);
    dataChanged(prependShift(old.chart.dates.firstOrNull, widget.chart.dates));
  }

  // 축·라벨 입력. 모델·언어가 바뀔 때만 새로 만든다(같은 객체면 다시 그리기만)
  ChartDecor? _decor;
  (ContractModel, AppLocalizations)? _decorKey;

  ChartDecor _decorFor(ContractModel model, AppLocalizations l10n) {
    if (_decor != null &&
        identical(_decorKey?.$1, model) &&
        identical(_decorKey?.$2, l10n)) {
      return _decor!;
    }
    _decorKey = (model, l10n);
    return _decor = ChartDecor(
      dates: model.chart.dates,
      priceDecimals: model.chart.priceDecimals,
      monthLabel: (year, month) => monthLabel(l10n, year, month),
      // 끝값은 보이는 범위의 마지막 날 값이다(D-093)
      labelsIn: model.endLabels,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final model = _model;
    if (model == null) return TabMessage(l10n.contractsNoData);
    final palette = ref.watch(upDownPaletteProvider);
    // 차단 상태를 C 껍데기 밖(탭만 띄운 테스트)에서도 살려 둔다
    ref.watch(chartBusyProvider);
    final decimals = model.chart.priceDecimals;
    // 우측 y축 자리: 선마다 가장 긴 끝값 라벨. 이동해도 너비가 바뀌지 않는다
    final yAxis = yAxisWidth([
      '0',
      for (final p in model.widestLabels) formatPrice(p, decimals),
    ]);
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => _chartStack(
              context,
              model,
              palette,
              yAxis,
              _legendHeight(context, model, constraints.maxWidth),
            ),
          ),
        ),
        ?periodChips(context),
      ],
    );
  }

  Widget _chartStack(
    BuildContext context,
    ContractModel model,
    UpDownPalette palette,
    double yAxis,
    double legendHeight,
  ) {
    final l10n = AppLocalizations.of(context);
    final decimals = model.chart.priceDecimals;
    // 선은 범례 줄 높이만큼 비켜 그리고 격자는 뒤까지 이어진다(D-117)
    final padding = EdgeInsets.only(
      top: legendHeight,
      right: yAxis,
      bottom: xLabelHeight,
    );
    return Stack(
      children: [
        Positioned.fill(
          child: PriceChart(
            key: const Key('contract-chart'),
            series: model.series,
            viewport: viewport,
            crosshair: crosshair,
            palette: palette,
            padding: padding,
            onGesture: onGesture,
            onGestureEnd: maybeLoadOlder,
            locked: loadingOlder,
            formatPrice: (p) => formatPrice(p, decimals),
            decor: _decorFor(model, l10n),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: IgnorePointer(
            child: ColoredBox(
              color: AppColors.overlay,
              child: _Legend(model: model),
            ),
          ),
        ),
        Positioned.fill(
          child: ChartDetailOverlay(
            series: model.series,
            viewport: viewport,
            crosshair: crosshair,
            padding: padding,
            builder: (context, index) =>
                _CrosshairDetail(model: model, index: index),
          ),
        ),
        ...chartOverlays(yAxis: yAxis),
      ],
    );
  }

  /// 범례 높이. [_Legend]의 Wrap과 같은 규칙으로 줄 수를 센다(좁으면 여러 줄).
  double _legendHeight(
    BuildContext context,
    ContractModel model,
    double width,
  ) {
    final sizes = [
      for (final item in model.legend)
        measureInfoText(
          context,
          item.isFront ? '${item.label}$frontMark' : item.label,
        ),
    ];
    return wrappedInfoHeight(
      itemWidths: [
        for (final s in sizes) legendLineWidth + AppSpacing.xs + s.width,
      ],
      available: width - AppSpacing.lg * 2,
      spacing: AppSpacing.md,
      lineHeight: sizes.fold(0, (h, s) => s.height > h ? s.height : h),
    );
  }
}

/// 차트 위 선 색 범례(가운데 정렬). y축 끝값 라벨은 값만 쓰고 월물은 이 범례로 읽는다(D-118).
class _Legend extends StatelessWidget {
  const new({required this.model});

  final ContractModel model;

  @override
  Widget build(BuildContext context) => Padding(
    key: const Key('contracts-legend'),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.xs,
    ),
    child: Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.md,
      children: [
        for (final item in model.legend)
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.xs,
            children: [
              LegendLine(color: item.color),
              Text.rich(
                TextSpan(
                  text: item.label,
                  children: [
                    // 대표월물 표식은 A 목록과 같은 색(선 색을 따르지 않는다)
                    if (item.isFront)
                      const TextSpan(
                        text: frontMark,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                  ],
                ),
                style: chartInfoStyle,
              ),
            ],
          ),
      ],
    ),
  );
}

/// 십자선 상세: 날짜(오늘 잠정 값이면 표시), 그날 값이 있는 월물별 가격(선 색, 대표월물 ●은 회색),
/// 맨 아래 양끝 월물의 연환산 롤 수익률(값이 있는 월물이 둘 이상일 때, D-118).
class _CrosshairDetail extends StatelessWidget {
  const new({required this.model, required this.index});

  final ContractModel model;
  final int index;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chart = model.chart;
    final provisional = chart.provisional && index == chart.dates.length - 1;
    final rollYield = endsRollYieldPct(chart, index);
    return DetailBox(
      children: [
        DetailRow(
          label: chart.dates[index],
          value: provisional ? l10n.contractsProvisional : null,
        ),
        for (final (i, c) in chart.contracts.indexed)
          if (c.prices[index] case final price?)
            DetailRow(
              label: formatContractMonth(c.contractMonth),
              value: formatPrice(price, chart.priceDecimals),
              color: contractLineColor(i),
              mark: c.isFront ? frontMark : null,
            ),
        if (rollYield != null)
          DetailRow(
            label: l10n.contractsRollYield,
            value: l10n.chartPerYear(formatChangePct(rollYield)),
          ),
      ],
    );
  }
}
