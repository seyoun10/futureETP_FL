import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/charts/chart_series.dart';
import 'package:futureetp/core/charts/chart_viewport.dart';
import 'package:material_ui/material_ui.dart';

const double _nan = double.nan;

ChartLine _line(List<double> values) =>
    ChartLine(Float64List.fromList(values), color: const Color(0xFFFFFFFF));

void main() {
  group('ChartSeries 선만(C-c)', () {
    test('envelope는 그날 값이 있는 선의 위·아래 끝이고, 값이 없는 날은 ∓∞다', () {
      final s = ChartSeries(
        lines: [
          _line([3.1, 3.2, _nan]),
          _line([_nan, 3.5, _nan]),
        ],
      );
      expect(s.length, 3);
      expect(s.envelopeHigh, [3.1, 3.5, double.negativeInfinity]);
      expect(s.envelopeLow, [3.1, 3.2, double.infinity]);
      expect(s.candles, isNull);
    });

    test('십자선 가격은 그날 값이 있는 첫 선이다(만기가 가장 가까운 월물)', () {
      final s = ChartSeries(
        lines: [
          _line([_nan, 3.2, _nan]),
          _line([3.4, 3.5, _nan]),
        ],
      );
      expect(s.crosshairPrices[0], 3.4);
      expect(s.crosshairPrices[1], 3.2);
      expect(s.crosshairPrices[2], isNaN);
    });

    test('0 이하 값이 있으면 선형, 모두 양수면 log 축이다(D-113)', () {
      expect(
        ChartSeries(
          lines: [
            _line([1, 2]),
          ],
        ).logScale,
        isTrue,
      );
      expect(
        ChartSeries(
          lines: [
            _line([10, -37.63]),
          ],
        ).logScale,
        isFalse,
      );
      final linear = ChartSeries(
        lines: [
          _line([10, -37.63]),
        ],
      );
      expect(
        PriceRange.fit(ChartViewport.latest(2, 2), linear),
        isA<LinearPriceRange>(),
      );
    });
  });

  group('LinearPriceRange', () {
    test('보이는 끝에 높이 6% 여백을 두고, 음수도 그린다', () {
      final v = ChartViewport.latest(2, 2);
      final r = LinearPriceRange.fit(v, const [20, 10], const [-10, 10]);
      const h = 100.0;
      expect(r.yOf(20, h), closeTo(6, 1e-9));
      expect(r.yOf(-10, h), closeTo(94, 1e-9));
      expect(r.priceAt(r.yOf(0, h), h), closeTo(0, 1e-9));
      expect(r.ticks(-10, 20, 6), [-10, -5, 0, 5, 10, 15, 20]);
    });

    test('값이 하나뿐이어도 범위가 0이 되지 않는다', () {
      final v = ChartViewport.latest(1, 1);
      final r = LinearPriceRange.fit(v, const [5], const [5]);
      expect(r.yOf(5, 100), closeTo(50, 1e-9));
    });
  });
}
