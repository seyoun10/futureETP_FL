import 'package:material_ui/material_ui.dart';

/// 범례 선 견본 너비(RN `LEGEND_LINE_WIDTH`).
const legendLineWidth = 18.0;

/// 범례 줄 앞 선 견본(C-b·C-c, RN `LegendLine`). [dash]가 있으면 점선이고, 실선과 길이가 같게 마디를 나눈다.
class LegendLine extends StatelessWidget {
  const new({super.key, required this.color, this.dash, this.strokeWidth = 2});

  final Color color;

  /// 점선의 선·빈칸 길이(차트 점선과 같은 값). 없으면 실선.
  final (double, double)? dash;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final dash = this.dash;
    if (dash == null) {
      return SizedBox(
        width: legendLineWidth,
        height: strokeWidth,
        child: ColoredBox(color: color),
      );
    }
    final (on, off) = dash;
    final count = ((legendLineWidth + off) / (on + off)).floor().clamp(1, 99);
    return SizedBox(
      width: legendLineWidth,
      height: strokeWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < count; i++)
            SizedBox(
              width: on,
              height: strokeWidth,
              child: ColoredBox(color: color),
            ),
        ],
      ),
    );
  }
}
