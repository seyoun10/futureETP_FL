import 'dart:math' as math;
import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';

/// 차트에 그리는 선(C-a 이평선·rare-level 밴드, C-c 월물). 값이 없는 날은 NaN이다.
@immutable
class ChartLine {
  const new(this.values, {required this.color, this.width = 1});

  final Float64List values;
  final Color color;
  final double width;
}

/// 일봉 시고저종. 열 배열로 둔다(프레임마다 보이는 구간만 순회).
@immutable
class Candles {
  const new({
    required this.opens,
    required this.highs,
    required this.lows,
    required this.closes,
  }) : assert(
         opens.length == highs.length &&
             highs.length == lows.length &&
             lows.length == closes.length,
         'OHLC 길이가 같아야 한다',
       );

  final Float64List opens;
  final Float64List highs;
  final Float64List lows;
  final Float64List closes;
}

/// 차트 입력: 봉과 그 위 선(C-a), 또는 선만(C-c, RN `LinesChart`).
@immutable
class ChartSeries {
  /// [candles]가 없으면 [lines]가 하나 이상 있어야 한다. 모든 선은 같은 길이다.
  new({this.candles, this.lines = const []})
    : assert(candles != null || lines.isNotEmpty, '봉이나 선이 있어야 한다'),
      length = candles?.closes.length ?? lines.first.values.length,
      envelopeHigh = _envelope(
        candles?.highs,
        lines,
        math.max,
        double.negativeInfinity,
      ),
      envelopeLow = _envelope(candles?.lows, lines, math.min, double.infinity),
      crosshairPrices = candles?.closes ?? _firstValues(lines);

  final Candles? candles;
  final List<ChartLine> lines;

  /// 봉 수(날짜 수).
  final int length;

  /// 날짜마다 그날 봉·선의 위·아래 끝. y 자동 맞춤 기준(D-087). 값이 없는 날은 ∓∞다.
  final Float64List envelopeHigh;
  final Float64List envelopeLow;

  /// 십자선 가로선 가격. 봉이면 종가, 선만이면 그날 값이 있는 첫 선(만기가 가장 가까운 월물, D-093).
  /// 값이 없는 날은 NaN이다.
  final Float64List crosshairPrices;

  /// y축이 log인지. 아니면 선형이다.
  /// C-a는 늘 log. 선만이면 0 이하 값이 있을 때(2020-04 CL 음수 정산) 선형이다(D-113).
  late final bool logScale = candles != null || envelopeLow.every((v) => v > 0);

  static Float64List _envelope(
    Float64List? bars,
    List<ChartLine> lines,
    double Function(double, double) pick,
    double empty,
  ) {
    final n = bars?.length ?? lines.first.values.length;
    final out = bars != null
        ? Float64List.fromList(bars)
        : (Float64List(n)..fillRange(0, n, empty));
    for (final line in lines) {
      for (var i = 0; i < n; i++) {
        final v = line.values[i];
        if (!v.isNaN) out[i] = pick(out[i], v);
      }
    }
    return out;
  }

  static Float64List _firstValues(List<ChartLine> lines) {
    final n = lines.first.values.length;
    final out = Float64List(n)..fillRange(0, n, double.nan);
    for (var i = 0; i < n; i++) {
      for (final line in lines) {
        final v = line.values[i];
        if (!v.isNaN) {
          out[i] = v;
          break;
        }
      }
    }
    return out;
  }
}
