import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/charts/chart_layout.dart';

void main() {
  group('y축 눈금(d3와 같다)', () {
    test('선형: 1·2·5 간격', () {
      expect(linearTicks(0, 10, 5), [0, 2, 4, 6, 8, 10]);
      expect(linearTicks(3.1, 3.9, 6), [
        closeTo(3.1, 1e-9),
        closeTo(3.2, 1e-9),
        closeTo(3.3, 1e-9),
        closeTo(3.4, 1e-9),
        closeTo(3.5, 1e-9),
        closeTo(3.6, 1e-9),
        closeTo(3.7, 1e-9),
        closeTo(3.8, 1e-9),
        closeTo(3.9, 1e-9),
      ]);
    });

    test('log: 범위가 좁으면 선형 눈금, 넓으면 k×10ⁿ', () {
      expect(logTicks(3700, 5600, 6), [4000, 4500, 5000, 5500]);
      expect(logTicks(2, 50, 6), [2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, 40, 50]);
    });

    test('소수 자릿수는 눈금 간격에 맞추되 가격 자릿수를 넘지 않는다', () {
      expect(tickDecimals([4000, 4500], 1), 0);
      expect(tickDecimals([3.1, 3.2], 3), 1);
      expect(tickDecimals([3.1, 3.2], 0), 0);
    });
  });

  group('특수 라벨 밀기', () {
    test('겹치면 아래로 밀고, 아래 끝을 넘으면 위로 되민다. 밖 라벨은 뺀다', () {
      // 높이 10, 차트 0~100
      expect(stackLabels([50, 52, 54], 10, 0, 100), [
        (0, 50),
        (1, 60),
        (2, 70),
      ]);
      // 둘 다 아래 끝(95)으로 당겨진 뒤 순번 순서로 위로 되민다
      expect(stackLabels([98, 96], 10, 0, 100), [(0, 85), (1, 95)]);
      expect(stackLabels([-5, 50], 10, 0, 100), [(1, 50)]);
    });
  });

  group('월 눈금', () {
    final dates = [
      for (var m = 1; m <= 12; m++) ...[
        '2026-${'$m'.padLeft(2, '0')}-01',
        '2026-${'$m'.padLeft(2, '0')}-15',
      ],
    ];

    test('여유가 있으면 매월, 좁으면 2·3개월 간격', () {
      expect(monthTicks(dates, 0, 23, 1).map((t) => t.month), [
        for (var m = 2; m <= 12; m++) m,
      ]);
      // 2개월 간격은 1월 기준(홀수 달)
      expect(monthTicks(dates, 0, 23, 3).map((t) => t.month), [3, 5, 7, 9, 11]);
      expect(monthTicks(dates, 0, 23, 5).map((t) => t.month), [4, 7, 10]);
    });
  });

  group('꼬리표', () {
    test('고가는 봉 위, 저가는 봉 아래. 현재가 점선이 지나가면 점선 바깥으로', () {
      expect(extremeTagTop(ExtremeKind.high, 50, 10, 3, null, 0, 100), 37);
      expect(extremeTagTop(ExtremeKind.low, 50, 10, 3, null, 0, 100), 53);
      // 점선이 꼬리표(37~47)를 지나면 점선 위로
      expect(extremeTagTop(ExtremeKind.high, 50, 10, 3, 40, 0, 100), 27);
    });

    test('화살표가 봉을 가리키고, 끝을 넘으면 반대쪽에 붙인다', () {
      // 고가는 화살표가 뒤: 글자 끝(화살표 가운데)이 봉 x
      expect(extremeTagLeft(ExtremeKind.high, 200, 100, 10, 0, 300), (
        left: 105,
        arrowFirst: false,
      ));
      // 왼쪽 끝 봉은 화살표를 앞으로
      expect(extremeTagLeft(ExtremeKind.high, 10, 100, 10, 0, 300), (
        left: 5,
        arrowFirst: true,
      ));
    });
  });
}
