import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/charts/chart_viewport.dart';
import 'package:futureetp/core/charts/price_chart.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/synthetic_bars.dart';

const _size = Size(300, 400);

late ValueNotifier<ChartViewport> _viewport;
late ValueNotifier<int?> _crosshair;

Future<void> _pump(WidgetTester tester, {bool locked = false}) async {
  final series = SyntheticBars(total: 756).latest(756);
  _viewport = ValueNotifier(ChartViewport.latest(series.length, 126));
  _crosshair = ValueNotifier(null);
  addTearDown(_viewport.dispose);
  addTearDown(_crosshair.dispose);
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: SizedBox.fromSize(
          size: _size,
          child: PriceChart(
            series: series,
            viewport: _viewport,
            crosshair: _crosshair,
            palette: UpDownPalette.kr,
            locked: locked,
          ),
        ),
      ),
    ),
  );
}

Offset _at(WidgetTester tester, double x) =>
    tester.getTopLeft(find.byType(PriceChart)) + Offset(x, _size.height / 2);

/// 햅틱 호출을 센다.
List<String> _haptics(WidgetTester tester) {
  final calls = <String>[];
  final messenger = tester.binding.defaultBinaryMessenger
    ..setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'HapticFeedback.vibrate') {
        calls.add('${call.arguments}');
      }
      return null;
    });
  addTearDown(
    () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
  );
  return calls;
}

/// [x]에서 [dx]만큼 10번에 나눠 끈다.
Future<void> _drag(WidgetTester tester, double x, double dx) async {
  final g = await tester.startGesture(_at(tester, x));
  for (var i = 1; i <= 10; i++) {
    await g.moveTo(_at(tester, x + dx * i / 10));
    await tester.pump(const Duration(milliseconds: 16));
  }
  await g.up();
}

void main() {
  testWidgets('한 손가락으로 오른쪽으로 끌면 과거로 간다', (tester) async {
    await _pump(tester);
    final before = _viewport.value.start;
    await _drag(tester, 100, 150);
    // 판정 거리를 넘은 뒤에도 누른 자리부터 따라온다
    expect(before - _viewport.value.start, closeTo(150 / 300 * 126, 1e-6));
    expect(_viewport.value.span, 126);
  });

  testWidgets('두 손가락을 벌리면 확대한다', (tester) async {
    await _pump(tester);
    final a = await tester.startGesture(_at(tester, 120), pointer: 10);
    final b = await tester.startGesture(_at(tester, 180), pointer: 11);
    for (var i = 1; i <= 10; i++) {
      await a.moveTo(_at(tester, 120 - i * 6.0));
      await b.moveTo(_at(tester, 180 + i * 6.0));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await a.up();
    await b.up();
    // 손가락 사이 60 → 180px, 3배
    expect(_viewport.value.span, closeTo(126 / 3, 3));
  });

  testWidgets('길게 누르면 십자선이 봉에 붙고, 끌면 따라오며 붙을 때마다 햅틱, 누르면 사라진다', (tester) async {
    await _pump(tester);
    final calls = _haptics(tester);
    final g = await tester.startGesture(_at(tester, 150));
    await tester.pump(crosshairLongPress + const Duration(milliseconds: 50));
    final first = _crosshair.value;
    expect(first, _viewport.value.indexAt(150, 300));
    await g.moveTo(_at(tester, 200));
    await tester.pump();
    await g.up();
    expect(_crosshair.value, _viewport.value.indexAt(200, 300));
    expect(calls, [
      'HapticFeedbackType.selectionClick',
      'HapticFeedbackType.selectionClick',
    ]);

    // 손을 뗀 뒤 끌면 차트는 그대로이고 십자선이 따라온다
    final start = _viewport.value;
    await _drag(tester, 200, -100);
    expect(_viewport.value, start);
    expect(_crosshair.value, lessThan(_viewport.value.indexAt(150, 300)));

    await tester.tapAt(_at(tester, 50));
    expect(_crosshair.value, isNull);
  });

  testWidgets('locked면 터치를 받지 않는다', (tester) async {
    await _pump(tester, locked: true);
    final before = _viewport.value;
    await _drag(tester, 100, 150);
    expect(_viewport.value, before);
  });
}
