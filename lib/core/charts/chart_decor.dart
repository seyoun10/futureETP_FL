import 'dart:math' as math;

import 'package:futureetp/core/charts/chart_layout.dart';
import 'package:futureetp/core/charts/chart_series.dart';
import 'package:futureetp/core/charts/chart_viewport.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/util/format_number.dart';
import 'package:material_ui/material_ui.dart';

/// y축 특수 라벨(현재가·이평선·rare-level·C-c 끝값). 선 색으로 쓴다.
typedef PriceLabel = ({double price, Color color});

/// 차트 둘레 표시(RN `YAxisLayer`·`XAxisLayer`·`ExtremeTagsLayer`·`RollLayer`).
/// 현재가 점선·고가·저가 꼬리표는 봉이 있을 때만 그린다.
@immutable
class ChartDecor {
  const new({
    required this.dates,
    required this.priceDecimals,
    required this.monthLabel,
    required this.labelsIn,
    this.extremeText,
    this.rollShading = const [],
    this.switches = const [],
  });

  /// 봉마다 거래일(`YYYY-MM-DD`). x축 월 눈금과 십자선 날짜 라벨.
  final List<String> dates;
  final int priceDecimals;

  /// x축 월 라벨: 1월은 연도, 나머지는 월 이름(D-121).
  final String Function(int year, int month) monthLabel;

  /// 가운데가 화면 안에 있는 봉 `first`~`last` 기준 특수 라벨(현재가 제외).
  /// C-a는 보이는 마지막 봉 값(이평선·rare-level), C-c는 범위 안 선마다 마지막 값이다(D-093).
  final List<PriceLabel> Function(int first, int last) labelsIn;

  /// 봉차트 고가·저가 꼬리표 글자(화살표 제외). 인자는 종류와 그 봉 순번. 없으면 꼬리표가 없다.
  final String Function(ExtremeKind kind, int index)? extremeText;

  /// 롤 기간 음영 [시작, 끝] 봉 순번(한국형·미국형).
  final List<(int, int)> rollShading;

  /// 대표월물 전환일 봉 순번(세로 점선, D-103).
  final List<int> switches;
}

/// 한 프레임의 좌표 변환. 봉·선은 [plot] 안, 격자는 위·아래 여백까지.
class ChartFrame {
  new(Size size, EdgeInsets padding, this.viewport, this.range)
    : full = Offset.zero & size,
      plot = padding.deflateRect(Offset.zero & size);

  final Rect full;
  final Rect plot;
  final ChartViewport viewport;
  final PriceRange range;

  double x(int i) => plot.left + viewport.xOf(i, plot.width);
  double y(double price) => plot.top + range.yOf(price, plot.height);
  double priceAt(double y) => range.priceAt(y - plot.top, plot.height);

  /// 가운데(꼬리)가 화면 안에 있는 첫 봉·마지막 봉. 없으면 first > last.
  int get centerFirst => math.max(0, (viewport.start - 0.5).ceil());
  int get centerLast =>
      math.min(viewport.count - 1, (viewport.end - 0.5).floor());
}

const _labelStyle = TextStyle(
  fontSize: chartFontSize,
  fontFeatures: [FontFeature.tabularFigures()],
);

/// 같은 글자·색의 TextPainter를 다시 쓴다(프레임마다 레이아웃하지 않게).
final _textCache = <(String, int), TextPainter>{};

TextPainter chartText(String text, Color color) {
  final key = (text, color.toARGB32());
  final cached = _textCache[key];
  if (cached != null) return cached;
  if (_textCache.length > 400) {
    for (final p in _textCache.values) {
      p.dispose();
    }
    _textCache.clear();
  }
  return _textCache[key] = TextPainter(
    text: TextSpan(
      text: text,
      style: _labelStyle.copyWith(color: color),
    ),
    textDirection: TextDirection.ltr,
    maxLines: 1,
  )..layout();
}

/// 차트 글자 한 줄 높이(라벨 겹침 판정).
double get chartTextHeight => chartText('0', ChartColors.tick).height;

/// y축 라벨 자리 너비: [samples] 중 가장 넓은 글자 + 여백.
double yAxisWidth(Iterable<String> samples) =>
    samples.fold<double>(
      0,
      (w, s) => math.max(w, chartText(s, ChartColors.tick).width),
    ) +
    yLabelPad;

/// 봉 아래: 롤 음영, y·x 격자.
void paintDecorUnder(Canvas canvas, ChartFrame f, ChartDecor decor) {
  final v = f.viewport;
  final half = v.barWidth(f.plot.width) / 2;
  final shade = Paint()..color = ChartColors.rollShade;
  for (final (start, end) in decor.rollShading) {
    if (end < v.first || start > v.last) continue;
    canvas.drawRect(
      Rect.fromLTRB(
        f.x(start) - half,
        f.plot.top,
        f.x(end) + half,
        f.plot.bottom,
      ),
      shade,
    );
  }
  final grid = Paint()
    ..color = ChartColors.grid
    ..strokeWidth = 0;
  for (final t in _yTicks(f)) {
    final y = f.y(t);
    canvas.drawLine(Offset(0, y), Offset(f.plot.right, y), grid);
  }
  for (final t in _xTicks(f, decor)) {
    final x = f.x(t.index);
    canvas.drawLine(Offset(x, f.full.top), Offset(x, f.plot.bottom), grid);
  }
}

/// 봉 위: 현재가 점선·전환일 점선, y축 라벨, x축 월 라벨, 고가·저가 꼬리표.
void paintDecorOver(
  Canvas canvas,
  ChartFrame f,
  ChartDecor decor,
  ChartSeries series,
) {
  final v = f.viewport;
  final lastIndex = v.count - 1;
  final shownFirst = f.centerFirst.clamp(0, lastIndex);
  final shownLast = f.centerLast.clamp(0, lastIndex);

  // 대표월물 전환일 세로 점선(차트 위아래 전체)
  final switchPaint = Paint()
    ..color = ChartColors.rollSwitch
    ..strokeWidth = 1;
  for (final i in decor.switches) {
    if (i < v.first || i > v.last) continue;
    final x = f.x(i);
    dashedLine(
      canvas,
      Offset(x, f.full.top),
      Offset(x, f.plot.bottom),
      switchPaint,
    );
  }

  final candles = series.candles;
  if (candles == null) {
    _yLabels(canvas, f, decor, decor.labelsIn(shownFirst, shownLast));
    _xLabels(canvas, f, decor);
    return;
  }
  final lastClose = candles.closes[lastIndex];
  final shownClose = candles.closes[shownLast];

  // 보이는 마지막 봉 종가(회색) 위에 마지막 봉 종가(흰색). 같은 봉이면 흰색만
  final guides = [
    if (shownLast != lastIndex) (shownClose, ChartColors.currentPrice),
    (lastClose, ChartColors.lastPrice),
  ];
  for (final (price, color) in guides) {
    final y = f.y(price);
    if (y < f.plot.top || y > f.plot.bottom) continue;
    dashedLine(
      canvas,
      Offset(f.plot.left, y),
      Offset(f.plot.right, y),
      Paint()
        ..color = color
        ..strokeWidth = 1,
    );
  }

  _yLabels(canvas, f, decor, [
    (price: lastClose, color: ChartColors.lastPrice),
    if (shownLast != lastIndex)
      (price: shownClose, color: ChartColors.currentPrice),
    ...decor.labelsIn(shownFirst, shownLast),
  ]);
  _xLabels(canvas, f, decor);
  if (decor.extremeText case final text?) {
    _extremeTags(canvas, f, text, candles, shownClose);
  }
}

void _yLabels(
  Canvas canvas,
  ChartFrame f,
  ChartDecor decor,
  List<PriceLabel> labels,
) {
  final height = chartTextHeight;
  final x = f.plot.right + 4;
  final special = stackLabels(
    [for (final l in labels) f.y(l.price)],
    height,
    f.plot.top,
    f.plot.bottom,
  );
  final specialYs = [for (final (_, y) in special) y];
  final ticks = _yTicks(f);
  final decimals = tickDecimals(ticks, decor.priceDecimals);
  for (final t in ticks) {
    final y = f.y(t);
    // 끝에 붙어 잘리는 눈금·특수 라벨과 겹치는 눈금은 글자를 숨긴다(격자선은 유지)
    if (y != clampLabelY(y, height, f.plot.top, f.plot.bottom) ||
        overlapsAny(y, specialYs, height)) {
      continue;
    }
    final p = chartText(formatPrice(t, decimals), ChartColors.tick);
    p.paint(canvas, Offset(x, y - p.height / 2));
  }
  for (final (i, y) in special) {
    final l = labels[i];
    final p = chartText(formatPrice(l.price, decor.priceDecimals), l.color);
    p.paint(canvas, Offset(x, y - p.height / 2));
  }
}

/// 이웃 x축 라벨 사이 최소 여백.
const _tickGap = 8.0;

void _xLabels(Canvas canvas, ChartFrame f, ChartDecor decor) {
  for (final t in _xTicks(f, decor)) {
    final p = chartText(decor.monthLabel(t.year, t.month), ChartColors.tick);
    final left = math.max(
      f.plot.left,
      math.min(f.x(t.index) - p.width / 2, f.plot.right - p.width),
    );
    p.paint(canvas, Offset(left, f.plot.bottom + 4));
  }
}

const _tagGap = 3.0;

void _extremeTags(
  Canvas canvas,
  ChartFrame f,
  String Function(ExtremeKind kind, int index) extremeText,
  Candles series,
  double guidePrice,
) {
  final i0 = f.centerFirst;
  final i1 = f.centerLast;
  if (i0 > i1) return;
  var hi = i0;
  var lo = i0;
  for (var i = i0; i <= i1; i++) {
    if (series.highs[i] > series.highs[hi]) hi = i;
    if (series.lows[i] < series.lows[lo]) lo = i;
  }
  final lineY = f.y(guidePrice);
  for (final (kind, index) in [(ExtremeKind.high, hi), (ExtremeKind.low, lo)]) {
    final text = extremeText(kind, index);
    final arrow = kind == ExtremeKind.high ? '↓' : '↑';
    final arrowWidth = chartText(arrow, ChartColors.extremeTag).width;
    final width = chartText('$arrow$text', ChartColors.extremeTag).width;
    final place = extremeTagLeft(
      kind,
      f.x(index),
      width,
      arrowWidth,
      f.plot.left,
      f.plot.right,
    );
    final p = chartText(
      place.arrowFirst ? '$arrow$text' : '$text$arrow',
      ChartColors.extremeTag,
    );
    final price = kind == ExtremeKind.high
        ? series.highs[index]
        : series.lows[index];
    final top = extremeTagTop(
      kind,
      f.y(price),
      p.height,
      _tagGap,
      lineY,
      f.plot.top,
      f.plot.bottom,
    );
    p.paint(canvas, Offset(place.left, top));
  }
}

/// y축 기본 눈금(6개 안팎, log·선형은 범위를 따른다). 봉 영역 위·아래 끝 가격 사이.
List<double> _yTicks(ChartFrame f) =>
    f.range.ticks(f.priceAt(f.plot.bottom), f.priceAt(f.plot.top), 6);

List<MonthTick> _xTicks(ChartFrame f, ChartDecor decor) {
  final v = f.viewport;
  final widest = [
    for (var m = 1; m <= 12; m++)
      chartText(decor.monthLabel(2000, m), ChartColors.tick).width,
  ].reduce(math.max);
  return monthTicks(
    decor.dates,
    v.first,
    v.last,
    (widest + _tickGap) / v.barWidth(f.plot.width),
  );
}

/// 점선. 기본은 가이드 점선(선·빈칸 2px).
void dashedLine(
  Canvas canvas,
  Offset a,
  Offset b,
  Paint paint, {
  (double, double) dash = guideDash,
}) {
  final (on, off) = dash;
  final d = b - a;
  final length = d.distance;
  if (length == 0) return;
  final u = d / length;
  for (var s = 0.0; s < length; s += on + off) {
    canvas.drawLine(a + u * s, a + u * math.min(s + on, length), paint);
  }
}
