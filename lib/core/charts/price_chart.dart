import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:futureetp/core/charts/chart_decor.dart';
import 'package:futureetp/core/charts/chart_series.dart';
import 'package:futureetp/core/charts/chart_viewport.dart';
import 'package:futureetp/core/charts/price_painter.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:material_ui/material_ui.dart';

/// 길게 누르기 시간(RN `activateAfterLongPress` 300ms, D-056).
const crosshairLongPress = Duration(milliseconds: 300);

/// 보이는 범위를 바꾼 제스처. 핀치는 기간 칩 선택 표시를 지우고, 이동은 남긴다(screens.md C-a).
enum ChartGesture { pan, zoom }

/// 봉차트와 제스처(D-056 보충).
///
/// - 한 손가락 끌기: 이동. 두 손가락: 손가락 가운데 날짜를 고정한 채 확대·축소하고 함께 움직이면 이동.
/// - 길게 누르기: 십자선. 봉에 붙을 때마다 햅틱. 손을 떼도 남고, 그동안 끌면 길게 누르지 않아도 십자선이 따라온다.
/// - 십자선이 있을 때 누르기: 십자선을 지운다.
///
/// [viewport]·[crosshair]는 부모가 갖는다(기간 버튼·상세 박스). 바뀌어도 위젯은 다시 만들지 않고 다시 그리기만 한다.
class PriceChart extends StatefulWidget {
  const new({
    super.key,
    required this.series,
    required this.viewport,
    required this.crosshair,
    required this.palette,
    this.padding = EdgeInsets.zero,
    this.onGesture,
    this.onGestureEnd,
    this.formatPrice,
    this.decor,
    this.locked = false,
  });

  final ChartSeries series;
  final ValueNotifier<ChartViewport> viewport;

  /// 십자선이 붙은 봉 순번. null이면 없다.
  final ValueNotifier<int?> crosshair;
  final UpDownPalette palette;

  /// 봉·선을 비켜 그릴 여백(위 정보 줄, 아래 x축, 오른쪽 y축). 손가락 위치도 이 안 기준이다.
  final EdgeInsets padding;

  /// 끌기·핀치가 보이는 범위를 실제로 바꿨을 때. 범위가 그대로인 제스처(끝에서 더 밀기 등)로는 부르지 않는다.
  final ValueChanged<ChartGesture>? onGesture;

  /// 끌기·핀치가 끝났을 때(범위가 그대로여도). 가장 과거 끝에서 다시 끌면 이전 데이터를 다시 받는다(D-139).
  final VoidCallback? onGestureEnd;

  /// 십자선 가격 라벨. 없으면 소수 셋째 자리.
  final String Function(double price)? formatPrice;

  /// 축·라벨·롤 표시.
  final ChartDecor? decor;

  /// 이전 데이터를 받는 동안 터치를 막는다(D-108, D-139).
  final bool locked;

  @override
  State<PriceChart> createState() => _PriceChartState();
}

class _PriceChartState extends State<PriceChart> {
  var _width = 1.0;

  // 이동·핀치 시작 상태. 손가락 수가 바뀌면 지금 상태에서 다시 시작한다
  ChartViewport? _startViewport;
  Offset _startFocal = Offset.zero;
  var _startScale = 1.0;
  var _pointers = 0;

  ValueNotifier<ChartViewport> get _viewport => widget.viewport;

  void _rebase(Offset focal, double scale, int pointers) {
    _startViewport = _viewport.value;
    _startFocal = focal;
    _startScale = scale;
    _pointers = pointers;
  }

  // 한 손가락 끌기는 판정 거리를 넘은 뒤에도 누른 자리부터 따라오게 한다(RN Gesture Handler 이동량과 같다).
  // ScaleGestureRecognizer는 판정을 넘은 자리를 시작점으로 주므로 누른 자리를 따로 기억한다.
  Offset? _down;

  /// 차트 위젯 좌표 → 봉 영역 x.
  double _x(Offset p) => p.dx - widget.padding.left;

  void _onScaleStart(ScaleStartDetails d) => _rebase(
    d.pointerCount == 1 ? _down ?? d.localFocalPoint : d.localFocalPoint,
    1,
    d.pointerCount,
  );

  void _onScaleUpdate(ScaleUpdateDetails d) {
    if (d.pointerCount != _pointers || _startViewport == null) {
      _rebase(d.localFocalPoint, d.horizontalScale, d.pointerCount);
      return;
    }
    if (d.pointerCount == 1 && widget.crosshair.value != null) {
      _moveCrosshair(_x(d.localFocalPoint));
      return;
    }
    final start = _startViewport!;
    final zoom = d.pointerCount >= 2;
    final next = zoom
        ? start.zoomed(
            d.horizontalScale / _startScale,
            _x(_startFocal),
            _x(d.localFocalPoint),
            _width,
          )
        : start.panned(d.localFocalPoint.dx - _startFocal.dx, _width);
    if (next == _viewport.value) return;
    _viewport.value = next;
    widget.onGesture?.call(zoom ? ChartGesture.zoom : ChartGesture.pan);
  }

  void _onScaleEnd(ScaleEndDetails d) {
    _startViewport = null;
    widget.onGestureEnd?.call();
  }

  void _onLongPressStart(LongPressStartDetails d) =>
      _moveCrosshair(_x(d.localPosition));

  void _onLongPressMove(LongPressMoveUpdateDetails d) =>
      _moveCrosshair(_x(d.localPosition));

  void _moveCrosshair(double x) {
    final i = _viewport.value.indexAt(x, _width);
    if (i == widget.crosshair.value) return;
    widget.crosshair.value = i;
    // 봉에 붙을 때마다
    HapticFeedback.selectionClick().ignore();
  }

  @override
  Widget build(BuildContext context) {
    final locked = widget.locked;
    return LayoutBuilder(
      builder: (context, constraints) {
        _width = widget.padding.deflateSize(constraints.biggest).width;
        return RawGestureDetector(
          behavior: HitTestBehavior.opaque,
          gestures: locked
              ? const {}
              : {
                  ScaleGestureRecognizer:
                      GestureRecognizerFactoryWithHandlers<
                        ScaleGestureRecognizer
                      >(
                        ScaleGestureRecognizer.new,
                        (r) => r
                          ..onStart = _onScaleStart
                          ..onUpdate = _onScaleUpdate
                          ..onEnd = _onScaleEnd,
                      ),
                  LongPressGestureRecognizer:
                      GestureRecognizerFactoryWithHandlers<
                        LongPressGestureRecognizer
                      >(
                        () => LongPressGestureRecognizer(
                          duration: crosshairLongPress,
                        ),
                        (r) => r
                          ..onLongPressStart = _onLongPressStart
                          ..onLongPressMoveUpdate = _onLongPressMove,
                      ),
                  TapGestureRecognizer:
                      GestureRecognizerFactoryWithHandlers<
                        TapGestureRecognizer
                      >(
                        TapGestureRecognizer.new,
                        (r) => r.onTap = () => widget.crosshair.value = null,
                      ),
                },
          child: Listener(
            onPointerDown: (e) => _down = e.localPosition,
            child: Stack(
              fit: StackFit.expand,
              children: [
                RepaintBoundary(
                  child: CustomPaint(
                    painter: PricePainter(
                      series: widget.series,
                      viewport: _viewport,
                      palette: widget.palette,
                      padding: widget.padding,
                      decor: widget.decor,
                    ),
                  ),
                ),
                // 십자선만 움직일 때 봉을 다시 그리지 않게 층을 나눈다
                RepaintBoundary(
                  child: CustomPaint(
                    painter: _CrosshairPainter(
                      series: widget.series,
                      viewport: _viewport,
                      crosshair: widget.crosshair,
                      padding: widget.padding,
                      formatPrice:
                          widget.formatPrice ?? (p) => p.toStringAsFixed(3),
                      dates: widget.decor?.dates,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 십자선: 붙은 봉 가운데 세로선, 그날 [ChartSeries.crosshairPrices] 가로선과 가격 라벨
/// (RN `CrosshairLayer`). 그날 값이 없으면 가로선은 없다.
class _CrosshairPainter extends CustomPainter {
  new({
    required this.series,
    required this.viewport,
    required this.crosshair,
    required this.padding,
    required this.formatPrice,
    this.dates,
  }) : super(repaint: Listenable.merge([viewport, crosshair]));

  final ChartSeries series;
  final ValueNotifier<ChartViewport> viewport;
  final ValueNotifier<int?> crosshair;
  final EdgeInsets padding;
  final String Function(double) formatPrice;

  /// 있으면 x축 자리에 십자선 날짜 라벨을 단다.
  final List<String>? dates;

  @override
  void paint(Canvas canvas, Size size) {
    final i = crosshair.value;
    final v = viewport.value;
    if (i == null || i >= v.count) return;
    final range = PriceRange.fit(v, series);
    final plot = padding.deflateRect(Offset.zero & size);
    final x = plot.left + v.xOf(i, plot.width);
    final line = Paint()
      ..color = ChartColors.crosshairLine
      ..strokeWidth = 1;
    canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    final price = series.crosshairPrices[i];
    final y = plot.top + range.yOf(price, plot.height);
    if (!y.isNaN) _priceLabel(canvas, size, plot, y, price, line);
    final dates = this.dates;
    if (dates != null && i < dates.length) {
      final date = TextPainter(
        text: TextSpan(
          text: dates[i],
          style: const TextStyle(
            color: ChartColors.crosshairText,
            fontSize: AppFontSize.caption,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final w = date.width + AppSpacing.sm;
      final left = math.max(0, math.min(x - w / 2, plot.right - w)).toDouble();
      final dateBox = Rect.fromLTWH(left, plot.bottom + 1, w, date.height + 4);
      canvas.drawRect(dateBox, Paint()..color = ChartColors.crosshair);
      date
        ..paint(canvas, dateBox.topLeft + const Offset(AppSpacing.xs, 2))
        ..dispose();
    }
  }

  /// 가로선과 우측 y축 자리 전체 너비의 가격 라벨.
  void _priceLabel(
    Canvas canvas,
    Size size,
    Rect plot,
    double y,
    double price,
    Paint line,
  ) {
    canvas.drawLine(Offset(0, y), Offset(plot.right, y), line);
    final text = TextPainter(
      text: TextSpan(
        text: formatPrice(price),
        style: const TextStyle(
          color: ChartColors.crosshairText,
          fontSize: AppFontSize.caption,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final box = Rect.fromLTRB(
      math.min(plot.right, size.width - text.width - AppSpacing.sm),
      y - text.height / 2 - 2,
      size.width,
      y + text.height / 2 + 2,
    );
    canvas.drawRect(box, Paint()..color = ChartColors.crosshair);
    text
      ..paint(canvas, box.topLeft + const Offset(AppSpacing.xs, 2))
      ..dispose();
  }

  @override
  bool shouldRepaint(_CrosshairPainter old) =>
      old.series != series ||
      old.viewport != viewport ||
      old.crosshair != crosshair ||
      old.padding != padding;
}
