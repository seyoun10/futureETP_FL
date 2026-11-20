import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart' hide Curve;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futureetp/core/api/app_error.dart';
import 'package:futureetp/core/api/error_text.dart';
import 'package:futureetp/core/api/models/curve.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/charts/chart_detail.dart';
import 'package:futureetp/core/charts/chart_layout.dart';
import 'package:futureetp/core/charts/chart_skeleton.dart';
import 'package:futureetp/core/charts/curve_chart.dart';
import 'package:futureetp/core/charts/legend_line.dart';
import 'package:futureetp/core/charts/period_chips.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:futureetp/core/util/format_number.dart';
import 'package:futureetp/core/util/orientation.dart';
import 'package:futureetp/core/widgets/query_state_view.dart';
import 'package:futureetp/features/commodity/chart_tab.dart';
import 'package:futureetp/features/commodity/curve/curve_format.dart';
import 'package:futureetp/features/commodity/curve/curve_provider.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart' hide Curve;

/// 휴장일을 골라 옮긴 기준일 안내를 띄워 두는 시간.
const curveMovedNotice = Duration(seconds: 3);

/// C-b 월물커브 탭(screens.md C-b, D-090, RN `CurveScreen`).
///
/// 기준일은 이 탭 State에 둔다(null = 서버 기본값 D-1). C를 떠나면 잊는다(기기 설정이 아님).
class CurveTab extends ConsumerStatefulWidget {
  const new({super.key, required this.codeText});

  /// 경로의 원자재 코드. 모르는 값이면 NOT_FOUND 문구다.
  final String codeText;

  @override
  ConsumerState<CurveTab> createState() => _CurveTabState();
}

class _CurveTabState extends ConsumerState<CurveTab> {
  String? _baseDate;

  /// 시트에서 고른 날짜. 응답 기준일이 다르면(휴장일) 옮긴 날짜를 잠깐 안내한다.
  String? _picked;
  Timer? _noticeTimer;

  /// 기준일을 옮기는 동안 이전 커브를 계속 보여 준다(버튼을 연달아 눌러도 화면이 비지 않게).
  Curve? _shown;

  final _crosshair = ValueNotifier<int?>(null);

  @override
  void dispose() {
    _noticeTimer?.cancel();
    _crosshair.dispose();
    super.dispose();
  }

  void _changeBaseDate(String? next) {
    _noticeTimer?.cancel();
    _noticeTimer = null;
    _crosshair.value = null;
    setState(() {
      _picked = null;
      _baseDate = next;
    });
  }

  void _pickBaseDate(String date, String maxBaseDate) {
    _noticeTimer?.cancel();
    _noticeTimer = null;
    _crosshair.value = null;
    setState(() {
      _picked = date;
      // D-1이면 기본값과 같은 조회를 쓴다
      _baseDate = date == maxBaseDate ? null : date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final code = CommodityCode.fromWire(widget.codeText);
    if (code == null) {
      return TabMessage(
        errorText(
          AppLocalizations.of(context),
          const AppError(AppErrorCode.notFound),
        ),
      );
    }
    final provider = curveProvider((code: code, baseDate: _baseDate));
    final value = ref.watch(provider);
    final fresh = value.hasValue ? value.requireValue : null;
    if (fresh != null) _shown = fresh;
    // 새 기준일을 받는 동안에는 이전 커브를 둔다. 실패하면 오류 화면이다
    final shown = fresh == null && value.isLoading ? _shown : null;
    final movedTo =
        _picked != null && fresh != null && fresh.baseDate != _picked
        ? fresh.baseDate
        : null;
    if (movedTo != null && _noticeTimer == null) {
      _noticeTimer = Timer(curveMovedNotice, () {
        if (mounted) setState(() => _picked = null);
      });
    }
    return ColoredBox(
      color: AppColors.background,
      child: QueryStateView(
        value: shown != null ? AsyncData(shown) : value,
        onRetry: () => ref.invalidate(provider),
        skeleton: const ChartSkeleton(footer: ChartSkeletonFooter.steps),
        builder: (context, curve) => _CurveView(
          curve: curve,
          movedTo: movedTo,
          crosshair: _crosshair,
          onChangeBaseDate: _changeBaseDate,
          onPickBaseDate: _pickBaseDate,
        ),
      ),
    );
  }
}

class _CurveView extends ConsumerWidget {
  const new({
    required this.curve,
    required this.movedTo,
    required this.crosshair,
    required this.onChangeBaseDate,
    required this.onPickBaseDate,
  });

  final Curve curve;

  /// 휴장일을 골라 서버가 옮긴 기준일.
  final String? movedTo;
  final ValueNotifier<int?> crosshair;
  final ValueChanged<String?> onChangeBaseDate;
  final void Function(String date, String maxBaseDate) onPickBaseDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final palette = ref.watch(upDownPaletteProvider);
    final currentDate = curve.freshness.tradeDate;
    final points = [
      for (final p in curve.points)
        (
          label: formatContractMonthShort(p.contractMonth),
          contractMonth: p.contractMonth,
          base: p.basePrice,
          current: p.currentPrice,
          changePct: p.changePct,
        ),
    ];
    final baseLabel = formatLegendDate(curve.baseDate, currentDate);
    final compareLabel = formatLegendDate(curve.compareDate, currentDate);
    // 롤 수익률은 비교일 커브 값만(범례와 같은 줄, D-118, D-119)
    final roll = l10n.curveRollYield(switch (curve.current) {
      final s? => l10n.chartPerYear(formatCurvePct(s.rollYieldPct)),
      null => l10n.curveUnavailable,
    });
    final atLatest = curve.baseDate == curve.maxBaseDate;
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: points.isEmpty
                ? TabMessage(l10n.curveNoData)
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final legendWidth = [
                        for (final d in [baseLabel, compareLabel])
                          legendLineWidth +
                              AppSpacing.xs +
                              measureInfoText(context, d).width,
                      ];
                      final rollSize = measureInfoText(context, roll);
                      final topInset = wrappedInfoHeight(
                        itemWidths: [
                          legendWidth[0] + AppSpacing.lg + legendWidth[1],
                          rollSize.width,
                        ],
                        available: constraints.maxWidth - AppSpacing.lg * 2,
                        spacing: AppSpacing.lg,
                        lineHeight: rollSize.height,
                      );
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: CurveChart(
                              points: points,
                              priceDecimals: curve.priceDecimals,
                              palette: palette,
                              crosshair: crosshair,
                              monthLabel: (year, month) =>
                                  monthLabel(l10n, year, month),
                              formatPct: formatCurvePct,
                              pctDecimals: curvePctDecimals,
                              topInset: topInset,
                              detailBuilder: (context, index) =>
                                  _CurveDetail(curve: curve, index: index),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            child: IgnorePointer(
                              child: ColoredBox(
                                color: AppColors.overlay,
                                child: _TopLine(
                                  baseLabel: baseLabel,
                                  compareLabel: compareLabel,
                                  roll: roll,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: xLabelHeight + AppSpacing.sm,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: AppSpacing.sm,
                              children: [
                                if (movedTo case final date?)
                                  _MovedNotice(
                                    text: l10n.curveMoved(
                                      formatLegendDate(date, currentDate),
                                      formatWeekday(date, l10n.localeName),
                                    ),
                                  ),
                                // 기준일을 과거로 옮겼을 때만 C-a·C-c 같은 되돌리기(D-115)
                                if (!atLatest)
                                  ChartResetButton(
                                    label: l10n.curveReset,
                                    onPressed: () => onChangeBaseDate(null),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ),
        // 가로 모드에서는 차트만 남긴다(D-103)
        if (!isLandscape(context))
          _BaseDateControls(
            curve: curve,
            onChangeBaseDate: onChangeBaseDate,
            onPickBaseDate: onPickBaseDate,
          ),
      ],
    );
  }
}

/// 위 정보 줄: 범례(날짜만, 실선·점선 견본) + 롤 수익률. 좁으면 롤 수익률이 다음 줄로 넘어간다.
class _TopLine extends StatelessWidget {
  const new({
    required this.baseLabel,
    required this.compareLabel,
    required this.roll,
  });

  final String baseLabel;
  final String compareLabel;
  final String roll;

  @override
  Widget build(BuildContext context) {
    Widget item(String label, {(double, double)? dash}) => Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.xs,
      children: [
        LegendLine(
          color: dash == null
              ? ChartColors.curveBase
              : ChartColors.curveCurrent,
          dash: dash,
          strokeWidth: 1,
        ),
        Text(label, style: chartInfoStyle),
      ],
    );
    return Padding(
      key: const Key('curve-legend'),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.lg,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.lg,
            children: [
              item(baseLabel),
              item(compareLabel, dash: curveDash),
            ],
          ),
          Text(
            roll,
            key: const Key('curve-roll-yield'),
            maxLines: 1,
            style: chartInfoStyle,
          ),
        ],
      ),
    );
  }
}

/// 휴장일 안내(x축 라벨 바로 위, 되돌리기 버튼이 있으면 그 위).
class _MovedNotice extends StatelessWidget {
  const new({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      key: const Key('curve-moved'),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: Text(text, style: chartInfoStyle),
    ),
  );
}

/// 아래 조작 줄: `<` 기준일 `>`. 기간 칩 줄과 높이가 같아 [↻] 자리가 세 차트 탭에서 같다(D-117).
class _BaseDateControls extends StatelessWidget {
  const new({
    required this.curve,
    required this.onChangeBaseDate,
    required this.onPickBaseDate,
  });

  final Curve curve;
  final ValueChanged<String?> onChangeBaseDate;
  final void Function(String date, String maxBaseDate) onPickBaseDate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final prev = curve.prevBaseDate;
    final next = curve.nextBaseDate;
    return SizedBox(
      height: AppSize.touchTarget,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppSpacing.sm,
        children: [
          _StepButton(
            key: const Key('curve-prev'),
            label: l10n.curvePrev,
            icon: Icons.chevron_left,
            onPressed: prev == null ? null : () => onChangeBaseDate(prev),
          ),
          Semantics(
            button: true,
            hint: l10n.curvePickTitle,
            child: Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
              child: InkWell(
                key: const Key('curve-base-date'),
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                onTap: () async {
                  final date = await showBaseDateSheet(context, curve);
                  if (date != null) onPickBaseDate(date, curve.maxBaseDate);
                },
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: AppSize.touchTarget,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Center(
                      widthFactor: 1,
                      child: Text(
                        formatFullDate(curve.baseDate),
                        style: chartInfoStyle.copyWith(
                          fontSize: AppFontSize.body,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _StepButton(
            key: const Key('curve-next'),
            label: l10n.curveNext,
            icon: Icons.chevron_right,
            // D-1로 오면 기본값과 같은 조회를 쓴다
            onPressed: next == null
                ? null
                : () =>
                      onChangeBaseDate(next == curve.maxBaseDate ? null : next),
          ),
        ],
      ),
    );
  }
}

/// `−`·`+`. 범위 끝이면([onPressed] null) 흐리게 비활성.
class _StepButton extends StatelessWidget {
  const new({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            onTap: onPressed,
            child: SizedBox.square(
              dimension: AppSize.touchTarget,
              child: Icon(
                icon,
                color: enabled ? AppColors.text : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 기준일 선택 시트(년·월·일 휠, screens.md C-b). 고른 날짜(`YYYY-MM-DD`)를 돌려준다.
/// 취소·시트 밖을 누르면 null. 휴장일도 고를 수 있고 서버가 거래일로 옮긴다(D-090, D-091).
Future<String?> showBaseDateSheet(BuildContext context, Curve curve) {
  final l10n = AppLocalizations.of(context);
  final min = toPickerDate(curve.minBaseDate);
  final max = toPickerDate(curve.maxBaseDate);
  var picked = toPickerDate(curve.baseDate);
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: AppColors.surface,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.sm,
          children: [
            Text(
              l10n.curvePickTitle,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: AppFontSize.title,
              ),
            ),
            SizedBox(
              height: 180,
              child: CupertinoTheme(
                data: const CupertinoThemeData(brightness: Brightness.dark),
                child: CupertinoDatePicker(
                  key: const Key('base-date-picker'),
                  mode: CupertinoDatePickerMode.date,
                  dateOrder: DatePickerDateOrder.ymd,
                  initialDateTime: picked,
                  minimumDate: min,
                  maximumDate: max,
                  minimumYear: min.year,
                  maximumYear: max.year,
                  onDateTimeChanged: (date) => picked = date,
                ),
              ),
            ),
            Text(
              l10n.curvePickRange(
                formatFullDate(curve.minBaseDate),
                formatFullDate(curve.maxBaseDate),
              ),
              style: chartInfoStyle.copyWith(color: AppColors.textSecondary),
            ),
            TextButtonTheme(
              // 기본 강조색은 어두운 표면에서 잘 보이지 않는다(RN 시트 버튼도 본문 색)
              data: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.text,
                  minimumSize: const Size(96, AppSize.touchTarget),
                  textStyle: const TextStyle(fontSize: AppFontSize.body),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.cancel),
                  ),
                  TextButton(
                    key: const Key('base-date-confirm'),
                    onPressed: () =>
                        Navigator.of(context).pop(fromPickerDate(picked)),
                    child: Text(l10n.confirm),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// 상세 박스: 월물 / 기준일 값 / 비교일 값 / 변화율. 항목은 범례와 같은 날짜다(D-116).
/// 그 커브에 없는 값은 줄을 뺀다.
class _CurveDetail extends StatelessWidget {
  const new({required this.curve, required this.index});

  final Curve curve;
  final int index;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = curve.points[index];
    String price(double v) => formatPrice(v, curve.priceDecimals);
    String date(String d) => formatLegendDate(d, curve.freshness.tradeDate);
    return DetailBox(
      children: [
        DetailRow(label: formatContractMonth(p.contractMonth)),
        if (p.basePrice case final v?)
          DetailRow(label: date(curve.baseDate), value: price(v)),
        if (p.currentPrice case final v?)
          DetailRow(label: date(curve.compareDate), value: price(v)),
        if (p.changePct case final pct?)
          DetailRow(label: l10n.curveTooltipChange, value: formatCurvePct(pct)),
      ],
    );
  }
}
