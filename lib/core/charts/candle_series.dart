import 'dart:math' as math;
import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';

/// 봉차트 위에 그리는 선(이평선·rare-level 밴드). 값이 없는 날은 NaN이다.
@immutable
class ChartLine {
  const new(this.values, {required this.color, this.width = 1});

  final Float64List values;
  final Color color;
  final double width;
}

/// 봉차트 입력. 열 배열로 둔다(프레임마다 보이는 구간만 순회).
@immutable
class CandleSeries {
  new({
    required this.opens,
    required this.highs,
    required this.lows,
    required this.closes,
    this.lines = const [],
  }) : assert(
         opens.length == highs.length &&
             highs.length == lows.length &&
             lows.length == closes.length,
         'OHLC 길이가 같아야 한다',
       ),
       envelopeHigh = _envelope(highs, lines, math.max),
       envelopeLow = _envelope(lows, lines, math.min);

  final Float64List opens;
  final Float64List highs;
  final Float64List lows;
  final Float64List closes;
  final List<ChartLine> lines;

  /// 봉마다 그날 선까지 포함한 위·아래 끝. y 자동 맞춤 기준(D-087).
  final Float64List envelopeHigh;
  final Float64List envelopeLow;

  int get length => closes.length;

  static Float64List _envelope(
    Float64List bars,
    List<ChartLine> lines,
    double Function(double, double) pick,
  ) {
    final out = Float64List.fromList(bars);
    for (final line in lines) {
      for (var i = 0; i < out.length; i++) {
        final v = line.values[i];
        if (!v.isNaN) out[i] = pick(out[i], v);
      }
    }
    return out;
  }
}
