import 'dart:math' as math;

import 'package:futureetp/core/theme/tokens.dart';
import 'package:material_ui/material_ui.dart';

/// 줄 높이를 최소로 둔다(글자 높이 + 위아래 1pt).
const double _lineHeight = AppFontSize.caption + 2;
const double _lineBlock = _lineHeight + 2;

/// 화면 최하단 안내 한 줄(A·C 기준 시각 줄, B 앱 번들 줄). RN `FooterLine`.
///
/// 높이를 아끼려고 홈 인디케이터 여백 위쪽에 겹쳐 둔다(여백 34pt면 줄 아래 18pt).
/// 내용이 없어도 빈 줄을 그려 위의 tab-bar가 흔들리거나 탭마다 위치가 달라지지 않게 한다.
/// 높이를 숫자로 고정하지 않아 기기 글자 크기를 따른다.
class FooterLine extends StatelessWidget {
  const new({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return ColoredBox(
      color: AppColors.background,
      child: Padding(
        padding: EdgeInsets.only(bottom: math.max(bottom - _lineBlock, 0)),
        child: child ?? const FooterText(' '),
      ),
    );
  }
}

/// [FooterLine] 안 글자. 한 줄로 자른다.
class FooterText extends StatelessWidget {
  const new(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 1),
    child: Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: AppFontSize.caption,
        height: _lineHeight / AppFontSize.caption,
      ),
    ),
  );
}
