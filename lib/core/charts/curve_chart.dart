import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:futureetp/core/charts/chart_decor.dart';
import 'package:futureetp/core/charts/chart_layout.dart';
import 'package:futureetp/core/charts/curve_layout.dart';
import 'package:futureetp/core/charts/price_chart.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:futureetp/core/util/format_number.dart';
import 'package:material_ui/material_ui.dart';

/// 만기순 월물 하나. 그 커브에 없는 값은 null.
typedef CurveChartPoint = ({
  /// 십자선 x축 라벨(`YYMM`).
  String label,

  /// `YYYY-MM`. x축 라벨은 월만 쓰고 1월은 연도다(C-a·C-c x축과 같다).
  String contractMonth,
  double? base,
  double? current,
  double? changePct,
});

/// 그림 영역 위 여백(맨 위 눈금 글자 자리).
const double _top = chartFontSize + AppSpacing.sm;

/// 점 반지름.
const _dot = 3.0;

/// 라벨 사이·점과 라벨 사이 여백.
const _labelGap = 4.0;

/// y축 눈금 글자와 그림 영역 사이.
const _yLabelGap = 4.0;

/// y축 눈금 개수 기준.
const _tickCount = 5;

/// 커브 차트 좌표(RN `CurveChart`의 layout). 확대·이동이 없어 크기·정보 줄 높이가 같으면 그대로다.
class CurveGeometry {
  new _({
    required this.points,
    required this.size,
    required this.topInset,
    required this.left,
    required this.right,
    required this.plotBottom,
    required this.slot,
    required this.ticks,
    required this.tickLabels,
    required this._yMax,
    required this._perPx,
    required this._log,
  });

  /// 값이 하나도 없으면 null.
  static CurveGeometry? compute({
    required List<CurveChartPoint> points,
    required Size size,
    required double topInset,
    required int priceDecimals,
  }) {
    final prices = [
      for (final p in points) ...[?p.base, ?p.current],
    ];
    if (prices.isEmpty || size.width <= 0) return null;
    final lo = prices.reduce(math.min);
    final hi = prices.reduce(math.max);
    // y축은 C-a처럼 log(값의 비율이 같은 높이). 0 이하 값이 있으면(2020-04 CL 음수 정산) 선형(D-113)
    final log = lo > 0;
    double toAxis(double v) => log ? math.log(v) : v;
    double fromAxis(double v) => log ? math.exp(v) : v;
    // 위아래 여백. 모두 같은 값이면 값의 2% 폭을 기준으로 둔다
    final span = toAxis(hi) - toAxis(lo);
    final basis = span > 0 ? span : (log ? 0.02 : hi.abs() * 0.02);
    final pad = (basis > 0 ? basis : 1) * 0.08;
    final yMin = toAxis(lo) - pad;
    final yMax = toAxis(hi) + pad;
    final plotBottom = size.height - xLabelHeight;
    // 선·점은 정보 줄 아래(dataTop~plotBottom)에 맞추고,
    // 격자·눈금은 그림 영역 전체(_top~plotBottom)에 그린다
    final dataTop = _top + topInset;
    final perPx = (yMax - yMin) / math.max(plotBottom - dataTop, 1);
    // 눈금은 1·2·5 간격(커브는 한 자릿수 배 안쪽이라 log 눈금 대신 고른 값)
    final ticks = linearTicks(
      fromAxis(yMin),
      fromAxis(yMax + (dataTop - _top) * perPx),
      _tickCount,
    );
    final decimals = tickDecimals(ticks, priceDecimals);
    final tickLabels = [for (final t in ticks) formatPrice(t, decimals)];
    // 축 폭은 눈금 글자와 십자선 가격 라벨(가격 자릿수 전부) 중 넓은 쪽
    final tickWidth = tickLabels.fold<double>(
      0,
      (w, l) => math.max(w, chartText(l, ChartColors.tick).width),
    );
    final crosshairWidth = points.fold<double>(0, (w, p) {
      final v = p.current ?? p.base;
      if (v == null) return w;
      return math.max(
        w,
        chartText(formatPrice(v, priceDecimals), ChartColors.tick).width,
      );
    });
    final right =
        size.width -
        math.max(tickWidth + yLabelPad, crosshairWidth + AppSpacing.xs * 2 + 1);
    return CurveGeometry._(
      points: points,
      size: size,
      topInset: topInset,
      left: 0,
      right: right,
      plotBottom: plotBottom,
      slot: right / points.length,
      ticks: ticks,
      tickLabels: tickLabels,
      yMax: yMax,
      perPx: perPx,
      log: log,
    );
  }

  final List<CurveChartPoint> points;
  final Size size;
  final double topInset;
  final double left;
  final double right;
  final double plotBottom;

  /// 월물 칸 폭.
  final double slot;
  final List<double> ticks;
  final List<String> tickLabels;
  final double _yMax;
  final double _perPx;
  final bool _log;

  double get top => _top;
  double get dataTop => _top + topInset;

  double x(int i) => left + slot * (i + 0.5);
  double y(double v) => dataTop + (_yMax - (_log ? math.log(v) : v)) / _perPx;

  /// 점 가운데에 맞춘 글자 왼쪽. 첫·끝 칸에서 칸 반폭보다 넓으면 그림 영역 안으로 민다.
  double textX(int i, double width) =>
      math.min(math.max(x(i) - width / 2, left), right - width);

  /// 두 선의 선분. 값이 빠진 월물에서 끊긴다.
  late final List<Segment> segments = [
    for (final value in [
      (CurveChartPoint p) => p.base,
      (CurveChartPoint p) => p.current,
    ])
      for (var i = 0; i + 1 < points.length; i++)
        if ((value(points[i]), value(points[i + 1])) case (
          final v?,
          final next?,
        ))
          (x0: x(i), y0: y(v), x1: x(i + 1), y1: y(next)),
  ];
}

/// 변화율 라벨 하나(놓을 자리까지).
typedef PctLabel = ({String text, Color color, double x, double y});

/// 변화율 라벨: 모든 월물에 붙인다. 오르면 점 위, 내리면 점 아래(반올림해 0이면 위)이고, 이웃과 겹치면
/// 같은 쪽 바깥으로 밀어내고 선과 겹치면 좌우로 민다(D-118, D-122, D-123). `y`는 글자 아래 끝이다.
List<PctLabel> curvePctLabels(
  CurveGeometry g,
  UpDownPalette palette,
  String Function(double pct) formatPct,
  int pctDecimals,
) {
  final height = chartTextHeight;
  final items = <({String text, Color color, PctLabelInput input})>[];
  for (final (i, p) in g.points.indexed) {
    final pct = p.changePct;
    if (pct == null) continue;
    final ys = [
      for (final v in [?p.base, ?p.current]) g.y(v),
    ];
    final text = formatPct(pct);
    final width = chartText(text, ChartColors.tick).width;
    items.add((
      text: text,
      color: changeColor(pct, palette, decimals: pctDecimals),
      input: (
        x: g.textX(i, width),
        anchor: g.x(i),
        width: width,
        top: ys.reduce(math.min) - _dot,
        bottom: ys.reduce(math.max) + _dot,
        // 표시 자릿수로 반올림해 음수인지(0.0%는 방향 없음이라 위)
        below: double.parse(pct.toStringAsFixed(pctDecimals)) < 0,
      ),
    ));
  }
  final positions = placePctLabels(
    [for (final item in items) item.input],
    height: height,
    gap: _labelGap,
    minY: g.dataTop,
    maxY: g.plotBottom,
    minX: g.left,
    maxX: g.right,
    segments: g.segments,
  );
  return [
    for (final (i, item) in items.indexed)
      (
        text: item.text,
        color: item.color,
        x: positions[i].x,
        y: positions[i].y,
      ),
  ];
}

/// C-b 월물커브 선차트(screens.md C-b, RN `CurveChart`).
///
/// 기준일은 흰 실선 + 빈 점, 비교일은 회색 점선 + 찬 점, 점마다 변화율(등락 색). 확대·이동이 없다.
/// 십자선은 C-a와 같다(D-056): 길게 누르면 나타나 끄는 대로 월물에 붙고(햅틱), 손을 떼도 남아 있는 동안은
/// 길게 누르지 않고 끌어도 따라오며, 한 번 더 누르면 사라진다. 가로선·가격 라벨은 현재가(없으면 기준일 값).
class CurveChart extends StatefulWidget {
  const new({
    super.key,
    required this.points,
    required this.priceDecimals,
    required this.palette,
    required this.crosshair,
    required this.monthLabel,
    required this.formatPct,
    required this.pctDecimals,
    required this.detailBuilder,
    this.topInset = 0,
  });

  final List<CurveChartPoint> points;
  final int priceDecimals;
  final UpDownPalette palette;

  /// 십자선이 붙은 월물 순번. 부모가 갖는다(기준일을 옮기면 지운다).
  final ValueNotifier<int?> crosshair;

  /// x축 월 라벨(1월은 연도, D-121).
  final String Function(int year, int month) monthLabel;
  final String Function(double pct) formatPct;

  /// 변화율 표시 소수 자릿수(반올림해 0이면 방향 없는 색·위).
  final int pctDecimals;

  /// 십자선 월물의 상세 박스.
  final Widget Function(BuildContext context, int index) detailBuilder;

  /// 위에 겹친 정보 줄 높이. 선·점은 이만큼 비켜 그리고 격자는 뒤까지 이어진다(D-117).
  final double topInset;

  @override
  State<CurveChart> createState() => _CurveChartState();
}

class _CurveChartState extends State<CurveChart> {
  CurveGeometry? _geometry;
  (List<CurveChartPoint>, Size, double, int)? _geometryKey;

  CurveGeometry? _geometryFor(Size size) {
    final key = (widget.points, size, widget.topInset, widget.priceDecimals);
    final old = _geometryKey;
    if (old != null &&
        identical(old.$1, key.$1) &&
        old.$2 == key.$2 &&
        old.$3 == key.$3 &&
        old.$4 == key.$4) {
      return _geometry;
    }
    _geometryKey = key;
    return _geometry = CurveGeometry.compute(
      points: widget.points,
      size: size,
      topInset: widget.topInset,
      priceDecimals: widget.priceDecimals,
    );
  }

  ValueNotifier<int?> get _crosshair => widget.crosshair;

  @override
  void initState() {
    super.initState();
    _crosshair.addListener(_onCrosshair);
  }

  @override
  void didUpdateWidget(CurveChart old) {
    super.didUpdateWidget(old);
    if (old.crosshair != widget.crosshair) {
      old.crosshair.removeListener(_onCrosshair);
      widget.crosshair.addListener(_onCrosshair);
    }
  }

  @override
  void dispose() {
    _crosshair.removeListener(_onCrosshair);
    super.dispose();
  }

  // 십자선이 생기거나 사라지면 인식기(끌기)를 바꾼다
  bool _hadCrosshair = false;
  void _onCrosshair() {
    final has = _crosshair.value != null;
    if (has != _hadCrosshair) setState(() => _hadCrosshair = has);
  }

  /// 손가락 x에 가장 가까운 월물에 십자선을 붙인다. 다른 월물로 옮겨 붙을 때마다 햅틱.
  void _snapTo(double x) {
    final g = _geometry;
    if (g == null) return;
    final i = nearestSlot(x, g.left, g.slot, widget.points.length);
    if (i == null || i == _crosshair.value) return;
    _crosshair.value = i;
    HapticFeedback.selectionClick().ignore();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final g = _geometryFor(constraints.biggest);
      if (g == null) return const SizedBox.expand();
      final pctLabels = curvePctLabels(
        g,
        widget.palette,
        widget.formatPct,
        widget.pctDecimals,
      );
      final hasCrosshair = _crosshair.value != null;
      return RawGestureDetector(
        behavior: HitTestBehavior.opaque,
        gestures: {
          // 십자선이 있으면 길게 누르지 않고 끌어도 바로 따라온다
          if (hasCrosshair)
            PanGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
                  PanGestureRecognizer.new,
                  (r) => r
                    ..onStart = ((d) => _snapTo(d.localPosition.dx))
                    ..onUpdate = ((d) => _snapTo(d.localPosition.dx)),
                )
          else
            LongPressGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<
                  LongPressGestureRecognizer
                >(
                  () =>
                      LongPressGestureRecognizer(duration: crosshairLongPress),
                  (r) => r
                    ..onLongPressStart = ((d) => _snapTo(d.localPosition.dx))
                    ..onLongPressMoveUpdate = ((d) =>
                        _snapTo(d.localPosition.dx)),
                ),
          TapGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
                TapGestureRecognizer.new,
                (r) => r.onTap = () => _crosshair.value = null,
              ),
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            RepaintBoundary(
              child: CustomPaint(
                key: const Key('curve-chart'),
                painter: _CurvePainter(
                  geometry: g,
                  pctLabels: pctLabels,
                  monthLabel: widget.monthLabel,
                  crosshair: _crosshair,
                  priceDecimals: widget.priceDecimals,
                ),
              ),
            ),
            IgnorePointer(
              child: ValueListenableBuilder(
                valueListenable: _crosshair,
                builder: (context, index, _) {
                  if (index == null || index >= widget.points.length) {
                    return const SizedBox.shrink();
                  }
                  return CustomSingleChildLayout(
                    delegate: _CurveDetailLayout(g, pctLabels, index),
                    child: widget.detailBuilder(context, index),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _CurvePainter extends CustomPainter {
  new({
    required this.geometry,
    required this.pctLabels,
    required this.monthLabel,
    required this.crosshair,
    required this.priceDecimals,
  }) : super(repaint: crosshair);

  final CurveGeometry geometry;
  final List<PctLabel> pctLabels;
  final String Function(int year, int month) monthLabel;
  final ValueNotifier<int?> crosshair;
  final int priceDecimals;

  @override
  void paint(Canvas canvas, Size size) {
    final g = geometry;
    final points = g.points;
    // 격자·y 눈금
    final grid = Paint()
      ..color = ChartColors.grid
      ..strokeWidth = 0;
    for (final (i, t) in g.ticks.indexed) {
      final ty = g.y(t);
      if (ty < g.top || ty > g.plotBottom) continue;
      canvas.drawLine(Offset(g.left, ty), Offset(g.right, ty), grid);
      final p = chartText(g.tickLabels[i], ChartColors.tick);
      p.paint(canvas, Offset(g.right + _yLabelGap, ty - p.height / 2));
    }

    // 기준일 실선, 비교일 점선
    final base = Path();
    var drawing = false;
    for (final (i, p) in points.indexed) {
      final v = p.base;
      if (v == null) {
        drawing = false;
        continue;
      }
      if (drawing) {
        base.lineTo(g.x(i), g.y(v));
      } else {
        base.moveTo(g.x(i), g.y(v));
      }
      drawing = true;
    }
    canvas.drawPath(
      base,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..strokeJoin = StrokeJoin.round
        ..color = ChartColors.curveBase,
    );
    final currentPaint = Paint()
      ..strokeWidth = 1
      ..color = ChartColors.curveCurrent;
    for (var i = 0; i + 1 < points.length; i++) {
      final (v, next) = (points[i].current, points[i + 1].current);
      if (v == null || next == null) continue;
      dashedLine(
        canvas,
        Offset(g.x(i), g.y(v)),
        Offset(g.x(i + 1), g.y(next)),
        currentPaint,
        dash: curveDash,
      );
    }

    // 점: 기준일 빈 점, 비교일 찬 점
    final hollow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = ChartColors.curveBase;
    final filled = Paint()..color = ChartColors.curveCurrent;
    for (final (i, p) in points.indexed) {
      if (p.base case final v?) {
        canvas.drawCircle(Offset(g.x(i), g.y(v)), _dot, hollow);
      }
      if (p.current case final v?) {
        canvas.drawCircle(Offset(g.x(i), g.y(v)), _dot, filled);
      }
    }

    _monthLabels(canvas);
    for (final l in pctLabels) {
      final p = chartText(l.text, l.color);
      p.paint(canvas, Offset(l.x, l.y - p.height));
    }
    _crosshair(canvas, size);
  }

  /// x축 월 라벨. 겹치지 않게 n개마다 하나씩 쓰고, 첫 1월(연도)이 빠지지 않게 그 칸에 맞춘다(D-121).
  void _monthLabels(Canvas canvas) {
    final g = geometry;
    final points = g.points;
    final widest = [
      for (var m = 1; m <= 12; m++)
        chartText(monthLabel(2000, m), ChartColors.tick).width,
    ].reduce(math.max);
    final stride = labelStride(g.slot, widest + _labelGap);
    final firstJanuary = points.indexWhere(
      (p) => p.contractMonth.endsWith('-01'),
    );
    final anchor = firstJanuary < 0 ? 0 : firstJanuary % stride;
    for (final (i, p) in points.indexed) {
      if (i % stride != anchor) continue;
      final text = chartText(
        monthLabel(
          int.parse(p.contractMonth.substring(0, 4)),
          int.parse(p.contractMonth.substring(5, 7)),
        ),
        ChartColors.tick,
      );
      text.paint(canvas, Offset(g.textX(i, text.width), g.plotBottom + 4));
    }
  }

  /// 십자선: 점선 세로·가로선, 우측 가격 상자, 아래 월물(`YYMM`) 상자.
  void _crosshair(Canvas canvas, Size size) {
    final g = geometry;
    final i = crosshair.value;
    if (i == null || i >= g.points.length) return;
    final p = g.points[i];
    final value = p.current ?? p.base;
    if (value == null) return;
    final x = g.x(i);
    final y = g.y(value);
    final line = Paint()
      ..color = ChartColors.crosshairLine
      ..strokeWidth = 1;
    dashedLine(canvas, Offset(x, g.top), Offset(x, g.plotBottom), line);
    dashedLine(canvas, Offset(g.left, y), Offset(g.right, y), line);
    final box = Paint()..color = ChartColors.crosshair;
    final price = chartText(
      formatPrice(value, priceDecimals),
      ChartColors.crosshairText,
    );
    final priceBox = Rect.fromLTRB(
      g.right + 1,
      y - price.height / 2 - 2,
      size.width,
      y + price.height / 2 + 2,
    );
    canvas.drawRect(priceBox, box);
    price.paint(canvas, priceBox.topLeft + const Offset(AppSpacing.xs, 2));
    final month = chartText(p.label, ChartColors.crosshairText);
    final w = month.width + AppSpacing.xs * 2;
    final left = math.min(math.max(x - w / 2, g.left), g.right - w);
    final monthBox = Rect.fromLTWH(left, g.plotBottom + 2, w, month.height + 4);
    canvas.drawRect(monthBox, box);
    month.paint(canvas, monthBox.topLeft + const Offset(AppSpacing.xs, 2));
  }

  @override
  bool shouldRepaint(_CurvePainter old) =>
      old.geometry != geometry ||
      old.pctLabels != pctLabels ||
      old.crosshair != crosshair ||
      old.priceDecimals != priceDecimals;
}

/// 상세 박스: 정보 줄 아래 그림 영역의 네 귀퉁이 중 점·선·변화율을 가장 적게 가리는 곳(C-a와 같다).
class _CurveDetailLayout extends SingleChildLayoutDelegate {
  new(this.geometry, this.pctLabels, this.index);

  final CurveGeometry geometry;
  final List<PctLabel> pctLabels;
  final int index;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final g = geometry;
    final area = (
      left: g.left + AppSpacing.sm,
      top: g.dataTop + AppSpacing.sm,
      right: g.right - AppSpacing.sm,
      bottom: g.plotBottom - AppSpacing.sm,
    );
    final box = (width: childSize.width, height: childSize.height);
    final height = chartTextHeight;
    final corner = leastCoveredCorner(
      area: area,
      box: box,
      crosshairX: g.x(index),
      marksIn: (x0, x1) sync* {
        for (final (i, p) in g.points.indexed) {
          final px = g.x(i);
          if (px < x0 - _dot || px > x1 + _dot) continue;
          for (final v in [?p.base, ?p.current]) {
            final py = g.y(v);
            yield (py - _dot, py + _dot);
          }
        }
        // 선분 중 x0~x1 안 부분의 세로 구간
        for (final s in g.segments) {
          final a = math.max(s.x0, x0);
          final b = math.min(s.x1, x1);
          if (a > b) continue;
          double at(double x) =>
              s.y0 + (s.y1 - s.y0) * (x - s.x0) / (s.x1 - s.x0);
          yield (math.min(at(a), at(b)), math.max(at(a), at(b)));
        }
        for (final l in pctLabels) {
          final width = chartText(l.text, l.color).width;
          if (l.x + width >= x0 && l.x <= x1) yield (l.y - height, l.y);
        }
      },
    );
    final r = cornerRect(area, box, corner);
    return Offset(r.left, r.top);
  }

  @override
  bool shouldRelayout(_CurveDetailLayout old) =>
      old.geometry != geometry || old.index != index;
}
