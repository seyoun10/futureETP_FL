import 'package:futureetp/core/charts/chart_periods.dart';
import 'package:futureetp/core/theme/mdi_icons.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/util/haptics.dart';
import 'package:futureetp/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// C-a·C-c 기간 칩 한 줄(screens.md C-a 기간과 제스처, RN `PeriodChips`).
/// 칩이 줄 너비를 똑같이 나눠 스크롤 없이 다 보인다. 높이는 44pt다(D-102).
class PeriodChips extends StatelessWidget {
  const new({
    super.key,
    required this.selected,
    required this.onSelect,
    this.nearest,
  });

  /// 핀치로 범위를 바꿨으면 null(선택 표시 없음).
  final ChartPeriod? selected;

  /// 핀치 뒤 보이는 범위와 가장 가까운 기간. 선택과 구분해 테두리로 표시한다.
  final ChartPeriod? nearest;
  final ValueChanged<ChartPeriod> onSelect;

  @override
  Widget build(BuildContext context) => Semantics(
    label: AppLocalizations.of(context).chartPeriodsLabel,
    container: true,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Row(
        children: [
          for (final period in ChartPeriod.values)
            Expanded(child: _chip(period)),
        ],
      ),
    ),
  );

  Widget _chip(ChartPeriod period) {
    final isSelected = period == selected;
    final isNearest = !isSelected && period == nearest;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: isSelected,
      button: true,
      child: Material(
        key: Key('period-${period.label}'),
        color: isSelected ? AppColors.surfaceSelected : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: isNearest
              ? const BorderSide(color: AppColors.surfaceSelected)
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            if (!isSelected) tapHaptic();
            onSelect(period);
          },
          child: SizedBox(
            height: AppSize.touchTarget,
            child: Center(
              child: Text(
                period.label,
                style: TextStyle(
                  fontSize: AppFontSize.body,
                  color: isSelected ? AppColors.text : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 차트 하단 가운데 [되돌리기](restore 아이콘, 새로고침과 구분, RN `ChartResetButton`).
/// 드래그·핀치로 바꾼 범위를 선택한 기간의 최근 위치로 되돌린다. 누르면 선택 햅틱(D-109).
class ChartResetButton extends StatelessWidget {
  const new({super.key, required this.onPressed, this.label});

  final VoidCallback onPressed;

  /// 없으면 기간 차트 문구(C-b는 기준일 되돌리기 문구를 넘긴다).
  final String? label;

  static const _size = 40.0;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label ?? AppLocalizations.of(context).chartResetView,
    excludeSemantics: true,
    child: Material(
      color: AppColors.surface,
      shape: const CircleBorder(side: BorderSide(color: AppColors.separator)),
      child: InkWell(
        key: const Key('chart-reset'),
        customBorder: const CircleBorder(),
        onTap: () {
          tapHaptic();
          onPressed();
        },
        child: const SizedBox.square(
          dimension: _size,
          child: Icon(
            MdiIcons.restore,
            color: AppColors.text,
            size: AppFontSize.headline,
          ),
        ),
      ),
    ),
  );
}
