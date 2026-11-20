import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/charts/curve_chart.dart';
import 'package:futureetp/core/theme/up_down_color.dart';
import 'package:material_ui/material_ui.dart';

CurveChartPoint _p(String month, double? base, double? current, double? pct) =>
    (
      label: month,
      contractMonth: month,
      base: base,
      current: current,
      changePct: pct,
    );

CurveGeometry _geometry(List<CurveChartPoint> points) => CurveGeometry.compute(
  points: points,
  size: const Size(360, 400),
  topInset: 20,
  priceDecimals: 3,
)!;

String _pct(double v) => '${v.toStringAsFixed(1)}%';

void main() {
  test('오르면 점 위, 내리면 점 아래, 반올림해 0이면 위다(D-118)', () {
    final g = _geometry([
      _p('2026-11', 3, 3.1, 3.3),
      _p('2026-12', 3.5, 3.2, -8.6),
      _p('2027-01', 3.4, 3.4, -0.04),
    ]);
    final labels = curvePctLabels(g, UpDownPalette.kr, _pct, 1);
    expect(labels, hasLength(3));
    // 글자 아래 끝이 점(위쪽 점)보다 위
    expect(labels[0].y, lessThan(g.y(3.1)));
    // 하락은 글자 아래 끝이 아래쪽 점보다 아래
    expect(labels[1].y, greaterThan(g.y(3.2)));
    expect(labels[1].color, UpDownPalette.kr.down);
    expect(labels[2].y, lessThan(g.y(3.4)));
  });

  test('변화율이 없는 월물(한쪽 값만)에는 라벨이 없고 선은 값이 빠진 곳에서 끊긴다', () {
    final g = _geometry([
      _p('2026-11', 3, null, null),
      _p('2026-12', 3.1, 3.2, 3.2),
      _p('2027-01', null, 3.3, null),
    ]);
    expect(curvePctLabels(g, UpDownPalette.kr, _pct, 1), hasLength(1));
    // 기준일 선 1개(11→12), 비교일 선 1개(12→01)
    expect(g.segments, hasLength(2));
  });

  test('0 이하 값이 있으면 선형 축이라 음수도 그린다(D-113)', () {
    final g = _geometry([
      _p('2020-05', -37.63, 10, null),
      _p('2020-06', 20, 25, null),
    ]);
    expect(g.y(-37.63).isFinite, isTrue);
    expect(g.y(-37.63), greaterThan(g.y(20)));
    // 선·점은 정보 줄 아래부터
    expect(g.y(25), greaterThanOrEqualTo(g.dataTop));
  });

  test('값이 하나도 없으면 그리지 않는다', () {
    expect(
      CurveGeometry.compute(
        points: [_p('2026-11', null, null, null)],
        size: const Size(360, 400),
        topInset: 0,
        priceDecimals: 3,
      ),
      isNull,
    );
  });
}
