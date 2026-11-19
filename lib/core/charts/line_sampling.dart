import 'dart:math' as math;

import 'package:futureetp/core/charts/chart_viewport.dart';

/// 선을 그릴 봉 순번(D-106, RN `lineSampling.ts`).
///
/// 화면 밖은 앞뒤 1봉만 남기고, 봉 폭이 1px보다 좁으면 2의 거듭제곱 간격으로 건너뛰어
/// 화면 1px에 점이 하나 이하가 되게 한다. 시작 순번을 간격의 배수로 맞춰 드래그 중 선 모양이 흔들리지 않는다.
typedef LineSample = ({int first, int last, int step});

LineSample? lineSample(ChartViewport viewport, double width) {
  if (viewport.count == 0) return null;
  final px = viewport.barWidth(width);
  final lo = math.max(0, viewport.first - 1);
  final hi = math.min(viewport.count - 1, viewport.last + 1);
  if (hi < lo) return null;
  final step = px >= 1 ? 1 : math.pow(2, (math.log(1 / px) / math.ln2).floor());
  final s = step.toInt();
  return (first: lo ~/ s * s, last: hi, step: s);
}
