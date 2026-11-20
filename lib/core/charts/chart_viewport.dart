import 'dart:math' as math;

import 'package:futureetp/core/charts/chart_layout.dart';
import 'package:futureetp/core/charts/chart_series.dart';
import 'package:material_ui/material_ui.dart';

/// 차트의 보이는 x 범위. 봉 순번 단위(소수)로 둔다(RN `fitTransform`의 x 배율·이동 대응, D-056).
///
/// 화면 x는 `(i + 0.5 − start) × 봉 폭`이고 봉 폭은 `차트 폭 / span`이다.
/// 행렬 대신 순번 범위로 두면 이전 3년을 앞에 붙일 때 `start`에 붙인 봉 수만 더하면 된다(D-104).
@immutable
class ChartViewport {
  const new({required this.count, required this.start, required this.span});

  /// 마지막 [bars]개 봉이 보이는 범위(기간 버튼, 첫 화면).
  factory latest(int count, int bars) {
    final span = bars.toDouble();
    return ChartViewport(
      count: count,
      start: count - span,
      span: span,
    ).clamped();
  }

  /// 최대 확대에서도 보이는 최소 봉 수(RN `MIN_VISIBLE_BARS`).
  static const minBars = 20;

  /// 전체 봉 수.
  final int count;

  /// 왼쪽 끝의 봉 순번(소수).
  final double start;

  /// 보이는 봉 수(소수).
  final double span;

  double get end => start + span;

  /// 축소는 전체까지, 확대는 [minBars]까지, 이동은 데이터 처음부터 끝까지.
  ChartViewport clamped() {
    if (count == 0) return this;
    final s = span.clamp(math.min(minBars, count).toDouble(), count.toDouble());
    return ChartViewport(
      count: count,
      start: start.clamp(0, count - s).toDouble(),
      span: s,
    );
  }

  /// 봉 폭(px).
  double barWidth(double width) => width / span;

  /// 봉 [i] 가운데의 화면 x.
  double xOf(int i, double width) => (i + 0.5 - start) * barWidth(width);

  /// 화면 [x]에 가장 가까운 봉 순번.
  int indexAt(double x, double width) =>
      (start + x / barWidth(width) - 0.5).round().clamp(0, count - 1);

  /// 일부라도 보이는 첫 봉·마지막 봉. 봉이 없으면 `first > last`.
  int get first => math.max(0, start.floor());
  int get last => math.min(count - 1, end.ceil() - 1);

  /// 가장 과거 봉이 화면에 들어왔는지(이전 3년 받기 조건, D-104).
  bool get showsOldest => count > 0 && start < 1;

  /// 화면에서 [dx]px 끌었을 때(오른쪽이 +, 과거로 감).
  ChartViewport panned(double dx, double width) => ChartViewport(
    count: count,
    start: start - dx / barWidth(width),
    span: span,
  ).clamped();

  /// 핀치. 시작 범위(이 객체)에서 손가락 가운데 [startFocal]에 있던 지점을 [scale]배 확대한 뒤
  /// 지금 손가락 가운데 [focal]에 둔다. 배율을 먼저 제한해 최대·최소에서 더 벌려도 밀리지 않는다.
  ChartViewport zoomed(
    double scale,
    double startFocal,
    double focal,
    double width,
  ) {
    final anchor = start + startFocal / width * span;
    final s = (span / scale).clamp(
      math.min(minBars, count).toDouble(),
      math.max(count, 1).toDouble(),
    );
    return ChartViewport(
      count: count,
      start: anchor - focal / width * s,
      span: s,
    ).clamped();
  }

  /// 과거 봉 [shift]개를 앞에 붙인 뒤에도 같은 날짜 범위가 보이게 한다(D-104).
  ChartViewport prepended(int shift) =>
      ChartViewport(count: count + shift, start: start + shift, span: span);

  @override
  bool operator ==(Object other) =>
      other is ChartViewport &&
      other.count == count &&
      other.start == start &&
      other.span == span;

  @override
  int get hashCode => Object.hash(count, start, span);

  @override
  String toString() => 'ChartViewport($count, $start, $span)';
}

/// 보이는 봉의 가격 범위. 화면 y와 가격을 서로 바꾸고 y축 기본 눈금을 낸다.
abstract interface class PriceRange {
  /// [series]의 y축 종류(log·선형)로 [viewport]에 보이는 봉의 위·아래 끝에 맞춘다(D-087, D-113).
  static PriceRange fit(ChartViewport viewport, ChartSeries series) =>
      series.logScale
      ? LogPriceRange.fit(viewport, series.envelopeHigh, series.envelopeLow)
      : LinearPriceRange.fit(viewport, series.envelopeHigh, series.envelopeLow);

  /// 가격 [price]의 화면 y(위가 0). 그릴 수 없는 값이면 NaN.
  double yOf(double price, double height);

  /// 화면 [y]의 가격.
  double priceAt(double y, double height);

  /// [lo]~[hi] 사이 기본 눈금(6개 안팎이면 [count] 6).
  List<double> ticks(double lo, double hi, int count);
}

/// 위·아래 여백 비율(RN `fitTransform`).
const _rangePadding = 0.06;

/// 보이는 봉의 [highs]·[lows] 끝. [skipNonPositive]면 0 이하 저가를 건너뛴다(log). 없으면 null.
(double, double)? _visibleExtent(
  ChartViewport viewport,
  List<double> highs,
  List<double> lows, {
  required bool skipNonPositive,
}) {
  var lo = double.infinity;
  var hi = double.negativeInfinity;
  for (var i = viewport.first; i <= viewport.last; i++) {
    final h = highs[i];
    final l = lows[i];
    if (h > hi) hi = h;
    if ((!skipNonPositive || l > 0) && l < lo) lo = l;
  }
  return lo.isFinite && hi.isFinite ? (lo, hi) : null;
}

/// 높이 h에 여백 p×h를 위·아래에 두면 값 span이 (1−2p)h를 차지한다.
double _pad(double span, double padding) => span * padding / (1 - 2 * padding);

/// log 가격 범위(C-a, C-c 기본). 봉마다 그날 선까지 포함한 위·아래 끝으로 맞춘다(D-087).
@immutable
class LogPriceRange implements PriceRange {
  const new(this.minLog, this.maxLog);

  /// [viewport]에 보이는 봉의 [highs]·[lows] 끝으로 맞춘다. 0 이하 값은 건너뛴다.
  /// 위·아래로 높이의 [padding]만큼 여백을 둔다.
  factory fit(
    ChartViewport viewport,
    List<double> highs,
    List<double> lows, {
    double padding = _rangePadding,
  }) {
    final extent = _visibleExtent(viewport, highs, lows, skipNonPositive: true);
    if (extent == null || extent.$2 <= 0) return const LogPriceRange(0, 1);
    final a = math.log(extent.$1);
    final b = math.log(extent.$2);
    final pad = _pad(math.max(b - a, 1e-9), padding);
    return LogPriceRange(a - pad, b + pad);
  }

  final double minLog;
  final double maxLog;

  /// 0 이하면 NaN.
  @override
  double yOf(double price, double height) => price > 0
      ? (maxLog - math.log(price)) / (maxLog - minLog) * height
      : double.nan;

  @override
  double priceAt(double y, double height) =>
      math.exp(maxLog - y / height * (maxLog - minLog));

  @override
  List<double> ticks(double lo, double hi, int count) =>
      logTicks(lo, hi, count);
}

/// 선형 가격 범위(C-c에 0 이하 값이 있을 때, D-113).
@immutable
class LinearPriceRange implements PriceRange {
  const new(this.min, this.max);

  factory fit(
    ChartViewport viewport,
    List<double> highs,
    List<double> lows, {
    double padding = _rangePadding,
  }) {
    final extent = _visibleExtent(
      viewport,
      highs,
      lows,
      skipNonPositive: false,
    );
    if (extent == null) return const LinearPriceRange(0, 1);
    final (lo, hi) = extent;
    // 값이 하나뿐이면 그 값 둘레 ±1을 보인다
    final span = hi - lo > 0 ? hi - lo : math.max(lo.abs(), 1).toDouble();
    final pad = _pad(span, padding);
    final mid = (lo + hi) / 2;
    return hi - lo > 0
        ? LinearPriceRange(lo - pad, hi + pad)
        : LinearPriceRange(mid - span / 2 - pad, mid + span / 2 + pad);
  }

  final double min;
  final double max;

  @override
  double yOf(double price, double height) =>
      (max - price) / (max - min) * height;

  @override
  double priceAt(double y, double height) => max - y / height * (max - min);

  @override
  List<double> ticks(double lo, double hi, int count) =>
      linearTicks(lo, hi, count);
}
