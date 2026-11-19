import 'dart:math' as math;

/// C-a·C-c 기간 버튼. 한 줄에 다 들어가게 6개만 둔다. 더 긴 범위는 핀치로 본다(D-102).
/// 봉 수는 거래일(월 21일로 어림한다, RN `PERIOD_BARS`).
enum ChartPeriod {
  m2('2M', 42),
  m4('4M', 84),
  m6('6M', 126),
  m8('8M', 168),
  m10('10M', 210),
  m12('12M', 252);

  new(this.label, this.bars);

  /// 칩 글자(언어와 상관없이 같다).
  final String label;
  final int bars;

  /// 원자재에 들어올 때마다 이 기간으로 시작한다(D-107).
  static const ChartPeriod initial = m6;
}

/// 보이는 봉 수와 가장 가까운 기간(핀치 뒤 기간 칩 테두리 표시). 비율로 비교한다.
/// 전체 봉 수보다 긴 기간은 전체 봉 수로 줄여 비교하고, 같으면 짧은 기간을 고른다.
ChartPeriod nearestPeriod(double visibleBars, int totalBars) {
  var best = ChartPeriod.values.first;
  var bestDistance = double.infinity;
  for (final period in ChartPeriod.values) {
    final bars = math.min(period.bars, totalBars);
    final distance = math.log(visibleBars / bars).abs();
    if (distance < bestDistance) {
      best = period;
      bestDistance = distance;
    }
  }
  return best;
}
