import 'dart:math' as math;

// 차트 축·라벨 배치 계산. 모두 순수 함수다.
// RN `monthTicks.ts`·`priceLabels.ts`·`extremeTagLayout.ts`·`YAxisLayer` 눈금.

/// 아래 x축 라벨 자리.
const xLabelHeight = 20.0;

/// y축 라벨 자리 = 가장 넓은 라벨 폭 + 이 여백.
const yLabelPad = 10.0;

/// 차트 글자 크기(RN `CHART_FONT_SIZE`).
const chartFontSize = 11.0;

/// 가이드 점선(십자선·현재가·대표월물 전환일)의 선·빈칸 길이.
const guideDash = (2.0, 2.0);

// ---- y축 눈금 ----

const _e10 = 7.0710678118654755; // sqrt(50)
const _e5 = 3.1622776601683795; // sqrt(10)
const _e2 = 1.4142135623730951; // sqrt(2)

/// d3 `ticks(start, stop, count)`: 1·2·5×10ⁿ 간격의 보기 좋은 눈금.
List<double> linearTicks(double start, double stop, int count) {
  if (count <= 0 || !start.isFinite || !stop.isFinite) return const [];
  if (start == stop) return [start];
  final lo = math.min(start, stop);
  final hi = math.max(start, stop);
  final step = (hi - lo) / count;
  final power = (math.log(step) / math.ln10).floor();
  final error = step / math.pow(10, power);
  final factor = error >= _e10
      ? 10
      : error >= _e5
      ? 5
      : error >= _e2
      ? 2
      : 1;
  final out = <double>[];
  if (power < 0) {
    final inc = math.pow(10, -power) / factor;
    var i1 = (lo * inc).round();
    var i2 = (hi * inc).round();
    if (i1 / inc < lo) i1++;
    if (i2 / inc > hi) i2--;
    for (var i = i1; i <= i2; i++) {
      out.add(i / inc);
    }
  } else {
    final inc = math.pow(10, power) * factor;
    var i1 = (lo / inc).round();
    var i2 = (hi / inc).round();
    if (i1 * inc < lo) i1++;
    if (i2 * inc > hi) i2--;
    for (var i = i1; i <= i2; i++) {
      out.add(i * inc.toDouble());
    }
  }
  return out;
}

/// d3 log 스케일 `ticks(count)`(밑 10). 범위가 좁아 k×10ⁿ 눈금이 count/2개보다 적으면 선형 눈금이다.
List<double> logTicks(double lo, double hi, int count) {
  if (!(lo > 0) || !(hi > lo)) return linearTicks(lo, hi, count);
  final i = math.log(lo) / math.ln10;
  final j = math.log(hi) / math.ln10;
  if (j - i >= count) {
    return [
      for (final e in linearTicks(
        i,
        j,
        math.min(j - i, count.toDouble()).floor(),
      ))
        math.pow(10, e).toDouble(),
    ];
  }
  final out = <double>[];
  for (var e = i.floor(); e <= j.ceil(); e++) {
    for (var k = 1; k < 10; k++) {
      final t = e < 0 ? k / math.pow(10, -e) : k * math.pow(10, e).toDouble();
      if (t < lo) continue;
      if (t > hi) break;
      out.add(t);
    }
  }
  return out.length * 2 < count ? linearTicks(lo, hi, count) : out;
}

/// 눈금 간격에 맞춘 소수 자릿수. 가격 자릿수 [max]를 넘지 않는다.
int tickDecimals(List<double> ticks, int max) {
  var step = double.infinity;
  for (var i = 1; i < ticks.length; i++) {
    step = math.min(step, ticks[i] - ticks[i - 1]);
  }
  if (!step.isFinite || step <= 0) return max;
  return math.min(max, math.max(0, -(math.log(step) / math.ln10).floor()));
}

// ---- y축 특수 라벨 ----

/// 라벨은 가운데 y에 그려 차트 위·아래 끝에 붙으면 반이 잘린다. 반 높이만큼 안쪽으로 민다.
double clampLabelY(double y, double height, double top, double bottom) =>
    math.min(math.max(y, top + height / 2), bottom - height / 2);

bool overlapsAny(double y, Iterable<double> ys, double height) =>
    ys.any((other) => (other - y).abs() < height);

/// 겹치면 모두 남긴 채 위·아래로 민다. 위에서부터 아래로 밀고, 아래 끝을 넘으면 위로 되민다.
/// 차트 위·아래 밖 라벨은 뺀다. 결과는 위에서 아래 순서의 (원래 순번, y)다.
List<(int, double)> stackLabels(
  List<double> ys,
  double height,
  double top,
  double bottom,
) {
  final sorted = [
    for (final (i, y) in ys.indexed)
      if (y >= top && y <= bottom) (i, clampLabelY(y, height, top, bottom)),
  ]..sort((a, b) => a.$2.compareTo(b.$2));
  for (var i = 1; i < sorted.length; i++) {
    sorted[i] = (
      sorted[i].$1,
      math.max(sorted[i].$2, sorted[i - 1].$2 + height),
    );
  }
  for (var i = sorted.length - 1; i >= 0; i--) {
    final limit = i == sorted.length - 1
        ? bottom - height / 2
        : sorted[i + 1].$2 - height;
    sorted[i] = (sorted[i].$1, math.min(sorted[i].$2, limit));
  }
  return sorted;
}

// ---- x축 월 눈금 ----

typedef MonthTick = ({int index, int year, int month});

const _monthSteps = [1, 2, 3, 6, 12, 24, 48];

/// 보이는 봉 [i0, i1]의 월 경계 눈금. 라벨이 겹치지 않는 가장 촘촘한 월 간격(1·2·3·6·12개월…)으로 고른다.
/// [minGap]은 이웃 눈금 사이 최소 봉 수(라벨 너비 + 여백 / 봉 간격)(D-121).
List<MonthTick> monthTicks(List<String> dates, int i0, int i1, double minGap) {
  final boundaries = <MonthTick>[];
  for (var i = math.max(i0, 1); i <= i1 && i < dates.length; i++) {
    final prev = dates[i - 1];
    final cur = dates[i];
    if (prev.substring(0, 7) == cur.substring(0, 7)) continue;
    boundaries.add((
      index: i,
      year: int.parse(cur.substring(0, 4)),
      month: int.parse(cur.substring(5, 7)),
    ));
  }
  var ticks = <MonthTick>[];
  for (final step in _monthSteps) {
    ticks = [
      for (final t in boundaries)
        if ((t.year * 12 + t.month - 1) % step == 0) t,
    ];
    var fits = true;
    for (var j = 1; j < ticks.length; j++) {
      if (ticks[j].index - ticks[j - 1].index < minGap) fits = false;
    }
    if (fits) break;
  }
  return ticks;
}

// ---- 고가·저가 꼬리표 ----

enum ExtremeKind { high, low }

/// 꼬리표 위쪽 y. 봉 위(고가)·아래(저가)에 두고 차트 위·아래 끝 안으로 민다.
/// 현재가 점선([lineY])이 글자를 지나가면 점선 바깥(봉 반대쪽)으로 옮기고, 그쪽이 차트를 넘으면 봉 쪽으로 옮긴다.
double extremeTagTop(
  ExtremeKind kind,
  double y,
  double height,
  double gap,
  double? lineY,
  double top,
  double bottom,
) {
  double clamp(double v) => math.min(math.max(v, top), bottom - height);
  final placed = clamp(kind == ExtremeKind.high ? y - height - gap : y + gap);
  if (lineY == null || lineY < placed - gap || lineY > placed + height + gap) {
    return placed;
  }
  final above = lineY - height - gap;
  final below = lineY + gap;
  final (first, second) = kind == ExtremeKind.high
      ? (above, below)
      : (below, above);
  if (first >= top && first <= bottom - height) return first;
  return clamp(second);
}

/// 꼬리표 왼쪽 x와 화살표가 앞인지. 화살표 글자 가운데를 봉 [x]에 맞춘다.
/// 화살표는 고가면 글자 뒤, 저가면 앞이 기본이고, 그쪽으로 두면 차트 끝을 넘을 때 반대쪽에 붙인다.
/// 양쪽 다 넘으면 덜 넘치는 쪽에 두고 차트 안으로 민다.
({double left, bool arrowFirst}) extremeTagLeft(
  ExtremeKind kind,
  double x,
  double width,
  double arrowWidth,
  double left,
  double right,
) {
  double overflow(double v) =>
      math.max(0, left - v) + math.max(0, v + width - right);
  double at({required bool first}) =>
      first ? x - arrowWidth / 2 : x + arrowWidth / 2 - width;
  final preferred = kind == ExtremeKind.low;
  final arrowFirst =
      overflow(at(first: !preferred)) < overflow(at(first: preferred))
      ? !preferred
      : preferred;
  return (
    left: math.min(math.max(at(first: arrowFirst), left), right - width),
    arrowFirst: arrowFirst,
  );
}
