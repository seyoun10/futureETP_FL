import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:futureetp/core/charts/chart_decor.dart';
import 'package:futureetp/core/charts/chart_series.dart';
import 'package:futureetp/core/charts/chart_viewport.dart';
import 'package:futureetp/core/charts/line_sampling.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:material_ui/material_ui.dart';

/// 봉(있으면)·선·격자를 그린다. [viewport]가 바뀌면 위젯 다시 만들기 없이 다시 그린다.
class PricePainter extends CustomPainter {
  new({
    required this.series,
    required this.viewport,
    required this.palette,
    this.padding = EdgeInsets.zero,
    this.decor,
  }) : super(repaint: viewport);

  final ChartSeries series;
  final ValueListenable<ChartViewport> viewport;
  final UpDownPalette palette;

  /// 봉·선을 비켜 그릴 여백(위 정보 줄, 아래 x축, 오른쪽 y축). 격자는 위·아래 여백까지 이어진다.
  final EdgeInsets padding;

  /// 축·라벨·롤 표시. 없으면 고정 격자만 그린다(스파이크).
  final ChartDecor? decor;

  /// 봉 몸통 폭 / 봉 폭.
  static const _bodyRatio = 0.7;

  /// 봉 폭이 이보다 좁으면 몸통 없이 꼬리만 그린다.
  static const _minBodyBarWidth = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final v = viewport.value;
    if (v.count == 0) return;
    final range = PriceRange.fit(v, series);
    final plot = padding.deflateRect(Offset.zero & size);
    final decor = this.decor;
    final frame = ChartFrame(size, padding, v, range);
    canvas
      ..save()
      ..clipRect(Rect.fromLTRB(0, 0, plot.right, size.height));
    if (decor == null) {
      _grid(canvas, Size(plot.right, size.height));
    } else {
      paintDecorUnder(canvas, frame, decor);
    }
    canvas.translate(plot.left, plot.top);
    if (series.candles case final candles?) {
      _candles(canvas, plot.size, v, range, candles);
    }
    for (final line in series.lines) {
      _line(canvas, plot.size, v, range, line);
    }
    canvas.restore();
    if (decor != null) {
      canvas
        ..save()
        ..clipRect(Offset.zero & size);
      paintDecorOver(canvas, frame, decor, series);
      canvas.restore();
    }
  }

  void _grid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ChartColors.grid
      ..strokeWidth = 1;
    for (var k = 1; k < 6; k++) {
      final y = size.height * k / 6;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _candles(
    Canvas canvas,
    Size size,
    ChartViewport v,
    PriceRange r,
    Candles candles,
  ) {
    final w = size.width;
    final h = size.height;
    final n = v.last - v.first + 1;
    final bw = v.barWidth(w);
    final withBody = bw >= _minBodyBarWidth;
    // 오르는 봉·내리는 봉을 각각 선분 목록(x0,y0,x1,y1)으로 모아 두 번에 그린다
    final upWick = Float32List(n * 4);
    final downWick = Float32List(n * 4);
    final upBody = Float32List(withBody ? n * 4 : 0);
    final downBody = Float32List(withBody ? n * 4 : 0);
    var u = 0;
    var d = 0;
    for (var i = v.first; i <= v.last; i++) {
      final x = v.xOf(i, w);
      final o = candles.opens[i];
      final c = candles.closes[i];
      final up = c >= o;
      final wick = up ? upWick : downWick;
      final j = up ? u : d;
      wick
        ..[j] = x
        ..[j + 1] = r.yOf(candles.highs[i], h)
        ..[j + 2] = x
        ..[j + 3] = r.yOf(candles.lows[i], h);
      if (withBody) {
        final body = up ? upBody : downBody;
        final yo = r.yOf(o, h);
        var yc = r.yOf(c, h);
        // 시가 = 종가인 봉도 1px 몸통을 보인다
        if ((yc - yo).abs() < 1) yc = yo + 1;
        body
          ..[j] = x
          ..[j + 1] = yo
          ..[j + 2] = x
          ..[j + 3] = yc;
      }
      if (up) {
        u += 4;
      } else {
        d += 4;
      }
    }
    // 꼬리는 헤어라인(strokeWidth 0 = 1 물리 픽셀)
    final wickPaint = Paint()..strokeWidth = 0;
    final bodyPaint = Paint()
      ..strokeWidth = bw * _bodyRatio
      ..strokeCap = StrokeCap.butt;
    canvas
      ..drawRawPoints(
        ui.PointMode.lines,
        Float32List.sublistView(upWick, 0, u),
        wickPaint..color = palette.up,
      )
      ..drawRawPoints(
        ui.PointMode.lines,
        Float32List.sublistView(downWick, 0, d),
        wickPaint..color = palette.down,
      );
    if (withBody) {
      canvas
        ..drawRawPoints(
          ui.PointMode.lines,
          Float32List.sublistView(upBody, 0, u),
          bodyPaint..color = palette.up,
        )
        ..drawRawPoints(
          ui.PointMode.lines,
          Float32List.sublistView(downBody, 0, d),
          bodyPaint..color = palette.down,
        );
    }
  }

  void _line(
    Canvas canvas,
    Size size,
    ChartViewport v,
    PriceRange r,
    ChartLine line,
  ) {
    final sample = lineSample(v, size.width);
    if (sample == null) return;
    final path = Path();
    var open = false;
    for (var i = sample.first; i <= sample.last; i += sample.step) {
      final value = line.values[i];
      if (value.isNaN) {
        open = false;
        continue;
      }
      final x = v.xOf(i, size.width);
      final y = r.yOf(value, size.height);
      if (y.isNaN) {
        open = false;
        continue;
      }
      if (open) {
        path.lineTo(x, y);
      } else {
        path.moveTo(x, y);
        open = true;
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = line.width
        ..color = line.color,
    );
  }

  @override
  bool shouldRepaint(PricePainter old) =>
      old.series != series ||
      old.palette != palette ||
      old.viewport != viewport ||
      old.padding != padding ||
      old.decor != decor;
}
