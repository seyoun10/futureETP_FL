import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/util/haptics.dart';
import 'package:material_ui/material_ui.dart';

/// 세그먼트 선택지 하나.
typedef SegmentOption<T> = ({T value, String label});

/// 설정 행: 이름 + [a|b|c] 중 하나 고르기(RN `SegmentedControl`).
/// 고른 값을 다시 누르면 아무것도 하지 않는다.
class SegmentedControl<T> extends StatelessWidget {
  const new({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
    this.stacked = false,
    this.description,
  });

  final String label;
  final List<SegmentOption<T>> options;

  /// 지금 값. 아직 모르면(설정 조회 중) 어느 선택지와도 다른 값(null 등)을 넘겨 아무것도 고르지 않는다.
  final T value;
  final ValueChanged<T> onChanged;

  /// 선택지가 많으면 이름을 위에 두고 선택지가 전체 폭을 나눠 쓴다.
  final bool stacked;

  /// 행 아래 한 줄 설명.
  final String? description;

  @override
  Widget build(BuildContext context) {
    final group = Semantics(
      label: label,
      container: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        child: ColoredBox(
          color: AppColors.surface,
          child: Row(
            mainAxisSize: stacked ? MainAxisSize.max : MainAxisSize.min,
            children: [
              for (final option in options)
                if (stacked)
                  Expanded(child: _segment(option))
                else
                  _segment(option),
            ],
          ),
        ),
      ),
    );
    final labelText = Text(
      label,
      style: const TextStyle(color: AppColors.text, fontSize: AppFontSize.body),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSize.touchTarget),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: stacked
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: AppSpacing.sm,
                      children: [labelText, group],
                    )
                  : Row(
                      spacing: AppSpacing.sm,
                      children: [
                        Expanded(child: labelText),
                        group,
                      ],
                    ),
            ),
          ),
          if (description case final d?)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                d,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppFontSize.caption,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _segment(SegmentOption<T> option) {
    final selected = option.value == value;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      child: Material(
        color: selected ? AppColors.surfaceSelected : Colors.transparent,
        child: InkWell(
          onTap: () {
            if (selected) return;
            tapHaptic();
            onChanged(option.value);
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 36,
              minWidth: AppSize.touchTarget,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: stacked ? AppSpacing.xs : AppSpacing.md,
              ),
              child: Center(
                widthFactor: 1,
                child: Text(
                  option.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: AppFontSize.body,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
