import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/charts/chart_viewport.dart';
import 'package:futureetp/core/charts/line_sampling.dart';

const _w = 300.0;

void main() {
  group('ChartViewport', () {
    test('latest는 마지막 봉 수만큼 보이고, 데이터보다 길면 전체다', () {
      final v = ChartViewport.latest(756, 126);
      expect((v.start, v.span), (630, 126));
      expect((v.first, v.last), (630, 755));
      expect(ChartViewport.latest(100, 252).span, 100);
    });

    test('봉 가운데 x와 x의 봉 순번이 서로 맞는다', () {
      final v = ChartViewport.latest(756, 126);
      // 봉 폭 300/126, 첫 보이는 봉 가운데는 반 칸
      expect(v.xOf(630, _w), closeTo(_w / 126 / 2, 1e-9));
      expect(v.indexAt(v.xOf(700, _w), _w), 700);
      // 화면 밖 왼쪽: 630 − 50/(300/126) − 0.5 = 608.5
      expect(v.indexAt(-50, _w), 609);
      expect(v.indexAt(1000000, _w), 755);
    });

    test('끌기는 데이터 처음·끝을 넘지 않는다', () {
      final v = ChartViewport.latest(756, 126);
      // 오른쪽으로 한 화면 끌면 126봉 과거
      expect(v.panned(_w, _w).start, closeTo(504, 1e-9));
      expect(v.panned(-_w, _w).start, 630);
      expect(v.panned(_w * 100, _w).start, 0);
    });

    test('핀치는 손가락 가운데 날짜를 그대로 두고, 20봉~전체로 제한한다', () {
      final v = ChartViewport.latest(756, 126).panned(_w, _w);
      const focal = 100.0;
      final anchor = v.start + focal / _w * v.span;
      final z = v.zoomed(2, focal, focal, _w);
      expect(z.span, closeTo(63, 1e-9));
      expect(z.start + focal / _w * z.span, closeTo(anchor, 1e-9));
      expect(v.zoomed(100, focal, focal, _w).span, ChartViewport.minBars);
      expect(v.zoomed(0.01, focal, focal, _w).span, 756);
      expect(v.zoomed(0.01, focal, focal, _w).start, 0);
    });

    test('핀치 중 손가락을 함께 움직이면 그만큼 이동한다', () {
      final v = ChartViewport.latest(756, 126).panned(_w, _w);
      final still = v.zoomed(1, 100, 100, _w);
      final moved = v.zoomed(1, 100, 130, _w);
      expect(moved.start, closeTo(still.start - 30 / _w * v.span, 1e-9));
    });

    test('앞에 봉을 붙이면 보던 순번 범위가 그만큼 밀린다(같은 날짜)', () {
      final v = ChartViewport.latest(756, 126).panned(_w * 6, _w);
      expect(v.showsOldest, isTrue);
      final p = v.prepended(756);
      expect((p.count, p.start, p.span), (1512, v.start + 756, v.span));
      expect(p.showsOldest, isFalse);
    });
  });

  group('LogPriceRange', () {
    test('보이는 봉의 위·아래 끝에 높이 6% 여백을 둔다', () {
      // 봉이 20개 미만이면 전체가 보인다
      final v = ChartViewport.latest(2, 1);
      final r = LogPriceRange.fit(v, const [20, 10], const [5, 10]);
      const h = 100.0;
      expect(r.yOf(20, h), closeTo(6, 1e-9));
      expect(r.yOf(5, h), closeTo(94, 1e-9));
      expect(r.priceAt(r.yOf(7, h), h), closeTo(7, 1e-9));
    });

    test('log 축: 가격 비율이 같으면 높이도 같다', () {
      final v = ChartViewport.latest(2, 2);
      final r = LogPriceRange.fit(v, const [8, 8], const [1, 1]);
      expect(
        r.yOf(2, 1) - r.yOf(4, 1),
        closeTo(r.yOf(1, 1) - r.yOf(2, 1), 1e-9),
      );
      expect(r.yOf(0, 1), isNaN);
    });
  });

  group('lineSample', () {
    test('봉 폭이 1px 이상이면 보이는 구간 앞뒤 1봉까지 모두', () {
      final v = ChartViewport.latest(756, 126).panned(_w, _w);
      expect(lineSample(v, _w), (first: 503, last: 630, step: 1));
    });

    test('1px보다 좁으면 2의 거듭제곱 간격, 시작은 간격의 배수', () {
      final v = ChartViewport.latest(4000, 4000);
      final s = lineSample(v, _w)!;
      // 봉 폭 0.075px → 1/0.075 = 13.3 → 8
      expect(s.step, 8);
      expect(s.first % s.step, 0);
      expect(_w / 4000 * s.step, lessThanOrEqualTo(1));
      expect(math.pow(2, 4) * _w / 4000, greaterThan(1));
    });
  });
}
