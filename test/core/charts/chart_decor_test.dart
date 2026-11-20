import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/charts/chart_decor.dart';
import 'package:futureetp/core/charts/chart_viewport.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('y 눈금은 위쪽 정보 줄 뒤(차트 맨 위)까지 이어진다(D-117)', () {
    // 봉 영역 위 80px은 정보 줄 자리. 가격 100~200이 봉 영역 높이에 맞는다
    final f = ChartFrame(
      const Size(300, 400),
      const EdgeInsets.only(top: 80, right: 40, bottom: 20),
      ChartViewport.latest(100, 50),
      LogPriceRange(math.log(100), math.log(200)),
    );
    final ticks = yTicks(f);
    final plotTop = f.priceAt(f.plot.top);
    expect(ticks.where((t) => t > plotTop), isNotEmpty);
    for (final t in ticks) {
      expect(f.y(t), inInclusiveRange(f.full.top, f.plot.bottom));
    }
  });
}
