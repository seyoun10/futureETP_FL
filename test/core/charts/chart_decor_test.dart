import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/charts/chart_decor.dart';
import 'package:futureetp/core/charts/chart_layout.dart';
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

  test('x축 월 경계는 봉 가운데 기준 화면 양끝 바로 바깥 봉까지 본다(RN XAxisLayer)', () {
    // 봉 10.3~60.3이 보이면 가운데가 왼쪽 밖인 봉 9, 오른쪽 밖인 봉 60까지
    const v = ChartViewport(count: 100, start: 10.3, span: 50);
    expect(xTickRange(v), (9, 60));
    expect(xTickRange(ChartViewport.latest(100, 50)), (49, 99));
  });

  test('y축 눈금 글자 겹침은 십자선 라벨 상자 높이로 본다(RN crosshairLabelHeight)', () {
    expect(crosshairLabelHeight, chartFontSize + 6);
  });
}
