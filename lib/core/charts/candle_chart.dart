import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:futureetp/core/charts/candle_painter.dart';
import 'package:futureetp/core/charts/candle_series.dart';
import 'package:futureetp/core/charts/chart_viewport.dart';
import 'package:futureetp/core/theme/tokens.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:material_ui/material_ui.dart';

/// 길게 누르기 시간(RN `activateAfterLongPress` 300ms, D-056).
const crosshairLongPress = Duration(milliseconds: 300);

/// 봉차트와 제스처(D-056 보충).
///
/// - 한 손가락 끌기: 이동. 두 손가락: 손가락 가운데 날짜를 고정한 채 확대·축소하고 함께 움직이면 이동.
/// - 길게 누르기: 십자선. 봉에 붙을 때마다 햅틱. 손을 떼도 남고, 그동안 끌면 길게 누르지 않아도 십자선이 따라온다.
/// - 십자선이 있을 때 누르기: 십자선을 지운다.
///
/// [viewport]·[crosshair]는 부모가 갖는다(기간 버튼·상세 박스). 바뀌어도 위젯은 다시 만들지 않고 다시 그리기만 한다.
class CandleChart extends StatefulWidget {
  const new({
    super.key,
    required this.series,
    required this.viewport,
    required this.crosshair,
    required this.palette,
    this.locked = false,
  });

  final CandleSeries series;
  final ValueNotifier<ChartViewport> viewport;

  /// 십자선이 붙은 봉 순번. null이면 없다.
  final ValueNotifier<int?> crosshair;
  final UpDownPalette palette;

  /// 이전 데이터를 받는 동안 터치를 막는다(D-108, D-139).
  final bool locked;

  @override
  State<CandleChart> createState() => _CandleChartState();
}

class _CandleChartState extends State<CandleChart> {
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
      _moveCrosshair(d.localFocalPoint.dx);
      return;
    }
    final start = _startViewport!;
    _viewport.value = d.pointerCount >= 2
        ? start.zoomed(
            d.horizontalScale / _startScale,
            _startFocal.dx,
            d.localFocalPoint.dx,
            _width,
          )
        : start.panned(d.localFocalPoint.dx - _startFocal.dx, _width);
  }

  void _onScaleEnd(ScaleEndDetails d) => _startViewport = null;

  void _onLongPressStart(LongPressStartDetails d) =>
      _moveCrosshair(d.localPosition.dx);

  void _onLongPressMove(LongPressMoveUpdateDetails d) =>
      _moveCrosshair(d.localPosition.dx);

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
        _width = constraints.maxWidth;
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
                    painter: CandlePainter(
                      series: widget.series,
                      viewport: _viewport,
                      palette: widget.palette,
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

/// 십자선: 붙은 봉 가운데 세로선, 그 봉 종가 가로선과 가격 라벨(RN `CrosshairLayer`).
class _CrosshairPainter extends CustomPainter {
  new({required this.series, required this.viewport, required this.crosshair})
    : super(repaint: Listenable.merge([viewport, crosshair]));

  final CandleSeries series;
  final ValueNotifier<ChartViewport> viewport;
  final ValueNotifier<int?> crosshair;

  @override
  void paint(Canvas canvas, Size size) {
    final i = crosshair.value;
    final v = viewport.value;
    if (i == null || i >= v.count) return;
    final range = LogPriceRange.fit(v, series.envelopeHigh, series.envelopeLow);
    final x = v.xOf(i, size.width);
    final close = series.closes[i];
    final y = range.yOf(close, size.height);
    final line = Paint()
      ..color = ChartColors.crosshairLine
      ..strokeWidth = 1;
    canvas
      ..drawLine(Offset(x, 0), Offset(x, size.height), line)
      ..drawLine(Offset(0, y), Offset(size.width, y), line);
    final text = TextPainter(
      text: TextSpan(
        text: close.toStringAsFixed(3),
        style: const TextStyle(
          color: ChartColors.crosshairText,
          fontSize: AppFontSize.caption,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final box = Rect.fromLTWH(
      size.width - text.width - AppSpacing.sm,
      y - text.height / 2 - 2,
      text.width + AppSpacing.sm,
      text.height + 4,
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
      old.crosshair != crosshair;
}
