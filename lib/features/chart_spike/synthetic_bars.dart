import 'dart:math' as math;
import 'dart:typed_data';

import 'package:futureetp/core/charts/candle_series.dart';
import 'package:futureetp/core/theme/tokens.dart';

/// 스파이크용 합성 일봉(시드 고정). RN 스파이크처럼 4,000봉을 만들어 두고 뒤에서부터 잘라 쓴다.
class SyntheticBars {
  new({this.total = 4000, int seed = 42}) {
    final rnd = math.Random(seed);
    double gauss() {
      // Box–Muller
      final u = 1 - rnd.nextDouble();
      return math.sqrt(-2 * math.log(u)) *
          math.cos(2 * math.pi * rnd.nextDouble());
    }

    _o = Float64List(total);
    _h = Float64List(total);
    _l = Float64List(total);
    _c = Float64List(total);
    var prev = 3.0;
    for (var i = 0; i < total; i++) {
      final o = prev * (1 + gauss() * 0.005);
      final c = o * math.exp(gauss() * 0.025);
      _o[i] = o;
      _c[i] = c;
      _h[i] = math.max(o, c) * (1 + gauss().abs() * 0.01);
      _l[i] = math.min(o, c) * (1 - gauss().abs() * 0.01);
      prev = c;
    }
    _ma = _movingAverage(_c, maPeriod);
  }

  final int total;

  /// 이평선 기간(거래일).
  static const maPeriod = 200;

  /// rare-level 이격도(%). 위 5개·아래 5개, 덜 드문 것부터.
  static const upperLevels = [20.0, 30.0, 40.0, 50.0, 65.0];
  static const lowerLevels = [-10.0, -15.0, -20.0, -25.0, -32.0];

  late final Float64List _o;
  late final Float64List _h;
  late final Float64List _l;
  late final Float64List _c;
  late final Float64List _ma;

  /// 마지막 [count]개 봉(이전 받기면 더 길게 잘라 앞이 늘어난다).
  CandleSeries latest(int count) {
    final from = math.max(0, total - count);
    Float64List cut(Float64List a) => Float64List.sublistView(a, from);
    final ma = cut(_ma);
    ChartLine band(double pct, int rank) => ChartLine(
      Float64List.fromList([for (final m in ma) m * (1 + pct / 100)]),
      color: ChartColors.rareLevels[rank],
    );
    return CandleSeries(
      opens: cut(_o),
      highs: cut(_h),
      lows: cut(_l),
      closes: cut(_c),
      lines: [
        for (var r = 0; r < 5; r++) band(upperLevels[r], r),
        for (var r = 0; r < 5; r++) band(lowerLevels[r], r),
        ChartLine(ma, color: ChartColors.movingAverage, width: 2),
      ],
    );
  }

  static Float64List _movingAverage(Float64List c, int period) {
    final out = Float64List(c.length)..fillRange(0, c.length, double.nan);
    var sum = 0.0;
    for (var i = 0; i < c.length; i++) {
      sum += c[i];
      if (i >= period) sum -= c[i - period];
      if (i >= period - 1) out[i] = sum / period;
    }
    return out;
  }
}
