import 'package:futureetp/core/theme/tokens.dart';
import 'package:material_ui/material_ui.dart';

/// 아직 만들지 않은 C 탭 자리(C-b·C-c·C-d, 4단계에서 채운다).
class TabPlaceholder extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) =>
      const ColoredBox(color: AppColors.background, child: SizedBox.expand());
}
