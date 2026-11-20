import 'package:futureetp/core/theme/tokens.dart';
import 'package:material_ui/material_ui.dart';

/// B와 하위 화면의 묶음 제목. 화면 폭 전체의 surface 띠로 그려 묶음 경계가 한눈에 보이게 한다
/// (RN `SectionHeader`).
class SectionHeader extends StatelessWidget {
  const new(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: AppFontSize.body,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

/// 화면 위 저장 실패 줄(B·B-a). 빨간 글자, 가운데 정렬.
class SaveErrorLine extends StatelessWidget {
  const new(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.error,
          fontSize: AppFontSize.caption,
        ),
      ),
    ),
  );
}
