import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/charts/chart_layout.dart';
import 'package:futureetp/core/charts/curve_layout.dart';

PctLabelInput _l(double x, {bool below = false, double top = 100}) =>
    (x: x, anchor: x + 15, width: 30, top: top, bottom: top + 10, below: below);

List<double> _ys(
  List<PctLabelInput> labels, {
  double minY = 0,
  double maxY = 200,
}) => [
  for (final p in placePctLabels(
    labels,
    height: 10,
    gap: 4,
    minY: minY,
    maxY: maxY,
  ))
    p.y,
];

void main() {
  test('커브 y 눈금은 1·2·5 간격이다(RN niceTicks와 같은 결과)', () {
    expect(linearTicks(2.7, 3.5, 5), [2.8, 3, 3.2, 3.4]);
    expect(linearTicks(61.3, 74.9, 6), [62, 64, 66, 68, 70, 72, 74]);
    expect(linearTicks(2400, 2600, 5), [2400, 2450, 2500, 2550, 2600]);
    expect(linearTicks(70, 70, 5), [70]);
  });

  test('labelStride: 칸이 라벨보다 좁으면 건너뛴다', () {
    expect(labelStride(40, 30), 1);
    expect(labelStride(14, 30), 3);
  });

  test('nearestSlot: x의 칸을 고르고 칸 밖은 양끝 칸이다', () {
    expect(nearestSlot(45, 40, 20, 3), 0);
    expect(nearestSlot(99, 40, 20, 3), 2);
    expect(nearestSlot(39, 40, 20, 3), 0);
    expect(nearestSlot(100, 40, 20, 3), 2);
    expect(nearestSlot(50, 40, 20, 0), isNull);
  });

  test('segmentHitsBox: 상자 x 구간 안 선분의 세로 범위로 판정한다', () {
    const s = (x0: 0.0, y0: 0.0, x1: 10.0, y1: 10.0);
    expect(segmentHitsBox(s, 4, 6, 3, 7), isTrue);
    expect(segmentHitsBox(s, 4, 6, 7, 9), isFalse);
    expect(segmentHitsBox(s, 11, 20, 0, 10), isFalse);
  });

  group('placePctLabels', () {
    test('겹치지 않으면 모두 점 위에 둔다', () {
      expect(_ys([_l(0), _l(40)]), [96, 96]);
    });

    test('이웃과 겹치면 반대쪽으로 넘기지 않고 같은 쪽 바깥으로 밀어낸다', () {
      expect(_ys([_l(0), _l(20), _l(10)]), [96, 82, 68]);
    });

    test('하락(below)은 점 아래에 두고, 겹치면 더 아래로 민다', () {
      expect(_ys([_l(0, below: true), _l(40), _l(20, below: true)]), [
        124,
        96,
        138,
      ]);
    });

    test('위·아래 라벨은 가로로 겹쳐도 서로 밀지 않는다', () {
      expect(_ys([_l(0), _l(10, below: true)]), [96, 124]);
    });

    test('밀려서 범위를 벗어나면 그 끝에 붙인다', () {
      expect(_ys([_l(0), _l(10)], minY: 80, maxY: 120), [96, 90]);
    });

    test('선과 겹치면 점 x가 글자 안에 남는 만큼 좌우로 가장 덜 민다', () {
      // 점(15, 100)에서 오른쪽 위로 오르는 선: 위 라벨은 왼쪽으로 비킨다
      final [p] = placePctLabels(
        [_l(0, top: 97)],
        height: 10,
        gap: 4,
        minY: 0,
        maxY: 200,
        minX: -100,
        segments: const [(x0: 15, y0: 100, x1: 45, y1: 70)],
      );
      expect(p.y, 93);
      expect(p.x, lessThan(0));
      expect(p.x, greaterThanOrEqualTo(-15));
    });

    test('비킬 자리가 없으면 그대로 둔다', () {
      // 점 양쪽으로 가파르게 오르는 골짜기
      expect(
        placePctLabels(
          [_l(0, top: 97)],
          height: 10,
          gap: 4,
          minY: 0,
          maxY: 200,
          minX: -100,
          segments: const [
            (x0: -15, y0: 0, x1: 15, y1: 100),
            (x0: 15, y0: 100, x1: 45, y1: 0),
          ],
        ),
        [(x: 0.0, y: 93.0)],
      );
    });

    test('왼쪽 끝을 넘어 밀지 않는다', () {
      expect(
        placePctLabels(
          [_l(0, top: 97)],
          height: 10,
          gap: 4,
          minY: 0,
          maxY: 200,
          minX: 0,
          segments: const [(x0: 15, y0: 100, x1: 45, y1: 70)],
        ),
        [(x: 0.0, y: 93.0)],
      );
    });
  });
}
