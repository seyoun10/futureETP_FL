import 'package:futureetp/core/charts/chart_layout.dart';
import 'package:futureetp/core/charts/chart_series.dart';
import 'package:futureetp/core/charts/chart_viewport.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:material_ui/material_ui.dart';

/// 십자선 상세 박스 층(C-a·C-c 공용, screens.md C-a 길게 누르기, RN `useDetailPlacement`).
///
/// 십자선이 있으면 [builder]가 만든 박스를 차트 영역(위 정보 줄 제외) 네 귀퉁이 중 봉·선을 가장 적게
/// 가리는 곳에 둔다. 박스 크기를 레이아웃에서 바로 알 수 있어 따로 재지 않는다. 터치는 받지 않는다.
class ChartDetailOverlay extends StatelessWidget {
  const new({
    super.key,
    required this.series,
    required this.viewport,
    required this.crosshair,
    required this.padding,
    required this.builder,
  });

  final ChartSeries series;
  final ValueNotifier<ChartViewport> viewport;
  final ValueNotifier<int?> crosshair;

  /// 차트의 봉 영역 여백(PriceChart와 같다).
  final EdgeInsets padding;
  final Widget Function(BuildContext context, int index) builder;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: ListenableBuilder(
      listenable: Listenable.merge([viewport, crosshair]),
      builder: (context, _) {
        final index = crosshair.value;
        if (index == null || index >= series.length) {
          return const SizedBox.shrink();
        }
        return CustomSingleChildLayout(
          delegate: _DetailLayout(
            series: series,
            viewport: viewport.value,
            index: index,
            padding: padding,
          ),
          child: builder(context, index),
        );
      },
    ),
  );
}

class _DetailLayout extends SingleChildLayoutDelegate {
  new({
    required this.series,
    required this.viewport,
    required this.index,
    required this.padding,
  });

  final ChartSeries series;
  final ChartViewport viewport;
  final int index;
  final EdgeInsets padding;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final plot = padding.deflateRect(Offset.zero & size);
    final v = viewport;
    final range = PriceRange.fit(v, series);
    double x(int i) => plot.left + v.xOf(i, plot.width);
    double y(double price) => plot.top + range.yOf(price, plot.height);
    final area = (
      left: plot.left + AppSpacing.sm,
      top: plot.top + AppSpacing.sm,
      right: plot.right - AppSpacing.sm,
      bottom: plot.bottom - AppSpacing.sm,
    );
    final box = (width: childSize.width, height: childSize.height);
    final bw = v.barWidth(plot.width);
    final corner = leastCoveredCorner(
      area: area,
      box: box,
      crosshairX: x(index),
      marksIn: (x0, x1) sync* {
        final i0 = (v.start + (x0 - plot.left) / bw - 0.5).ceil();
        final i1 = (v.start + (x1 - plot.left) / bw - 0.5).floor();
        for (var i = i0 < 0 ? 0 : i0; i <= i1 && i < series.length; i++) {
          if (series.candles case final c?) {
            yield (y(c.highs[i]), y(c.lows[i]));
          }
          for (final line in series.lines) {
            final p = line.values[i];
            if (p.isNaN) continue;
            final ly = y(p);
            if (ly.isNaN) continue;
            yield (ly - line.width / 2, ly + line.width / 2);
          }
        }
      },
    );
    final r = cornerRect(area, box, corner);
    return Offset(r.left, r.top);
  }

  @override
  bool shouldRelayout(_DetailLayout old) =>
      old.series != series ||
      old.viewport != viewport ||
      old.index != index ||
      old.padding != padding;
}

/// 상세 박스(C-a·C-b·C-c 공용). 너비는 가장 긴 줄에 맞춘다.
class DetailBox extends StatelessWidget {
  const new({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
    key: const Key('chart-detail'),
    padding: const EdgeInsets.all(AppSpacing.sm),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.xs),
    ),
    child: IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 2,
        children: children,
      ),
    ),
  );
}

/// 상세 박스 한 줄: 이름은 왼쪽, 값은 오른쪽 정렬. 둘 사이는 최소 `spacing.md`.
class DetailRow extends StatelessWidget {
  const new({
    super.key,
    required this.label,
    this.value,
    this.color = AppColors.text,
    this.mark,
  });

  final String label;
  final String? value;
  final Color color;

  /// 이름 뒤 표식(C-c 대표월물 `●`). 선 색이 아니라 A 목록과 같은 `textSecondary`다(D-118).
  final String? mark;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: color,
      fontSize: AppFontSize.caption,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: AppSpacing.md,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            children: [
              if (mark case final m?)
                TextSpan(
                  text: m,
                  style: style.copyWith(color: AppColors.textSecondary),
                ),
            ],
          ),
          style: style,
        ),
        if (value case final v?) Text(v, style: style),
      ],
    );
  }
}
