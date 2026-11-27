// RN 교차 테스트(FL-036). 같은 입력을 RN 순수 함수와 Flutter 함수에 넣어 결과가 같은지 본다.
// fixtures/rn_outputs.json은 `tool/sync_rn_cross.sh`가 RN 코드로 만든 기준값이다.
// 옆에 RN 저장소가 있으면 fixture를 만든 RN 원본이 지금과 같은지도 본다(CI도 RN 저장소를 함께 받는다).
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/charts/chart_layout.dart';
import 'package:futureetp/core/charts/chart_periods.dart';
import 'package:futureetp/core/charts/curve_layout.dart';
import 'package:futureetp/core/util/format_amount.dart';
import 'package:futureetp/core/util/format_number.dart';

const _fixturePath = 'test/cross/fixtures/rn_outputs.json';
const _rnDir = '../futureETP_ReactNative/apps/mobile';

/// 차이를 보일 불일치 수.
const _shownMismatches = 5;

final _fixture =
    jsonDecode(File(_fixturePath).readAsStringSync()) as Map<String, dynamic>;

List<List<dynamic>> _cases(String name) => [
  for (final row in (_fixture['cases'] as Map<String, dynamic>)[name] as List)
    row as List<dynamic>,
];

double _d(Object? v) => (v! as num).toDouble();

List<double> _ds(Object? v) => [for (final x in v! as List) _d(x)];

/// 부동소수 마지막 자리 차이는 같은 값으로 본다(RN은 toPrecision, Flutter는 나눗셈으로 만든다).
bool _near(double a, double b) => (a - b).abs() <= 1e-9 * (a.abs() + 1);

bool _sameList(List<double> a, List<double> b) =>
    a.length == b.length &&
    Iterable<int>.generate(a.length).every((i) => _near(a[i], b[i]));

/// [name]의 모든 행을 [check]로 보고, 다르면 처음 몇 개를 실패 메시지로 보인다.
/// [check]는 같으면 null, 다르면 차이 설명을 돌려준다.
void _expectAll(String name, String? Function(List<dynamic> row) check) {
  final rows = _cases(name);
  expect(rows, isNotEmpty, reason: '$name 기준값이 없다');
  final mismatches = [for (final row in rows) ?check(row)];
  expect(
    mismatches,
    isEmpty,
    reason:
        '$name: ${mismatches.length}/${rows.length}개가 RN과 다르다\n'
        '${mismatches.take(_shownMismatches).join('\n')}',
  );
}

/// 값이 다르면 차이 설명. 리스트는 요소로 비교하도록 글자로 바꿔 비교한다.
String? _diff(Object? input, Object? rn, Object? fl) =>
    '$rn' == '$fl' ? null : '  $input → RN $rn, Flutter $fl';

void main() {
  group('RN 원본', () {
    final rnExists = Directory(_rnDir).existsSync();
    test('fixture를 만든 RN 코드가 옆 저장소와 같다(다르면 tool/sync_rn_cross.sh)', () {
      final sources = _fixture['sources'] as Map<String, dynamic>;
      for (final MapEntry(:key, :value) in sources.entries) {
        expect(
          File('$_rnDir/$key').readAsStringSync(),
          value,
          reason: '$key가 바뀌었다. tool/sync_rn_cross.sh로 다시 만든 뒤 차이를 맞춘다',
        );
      }
    }, skip: rnExists ? false : 'RN 저장소 없음');
  });

  group('숫자 표기', () {
    test('formatPrice', () {
      _expectAll('formatPrice', (r) {
        return _diff(r.take(2), r[2], formatPrice(_d(r[0]), r[1] as int));
      });
    });

    test('formatChange', () {
      _expectAll('formatChange', (r) {
        return _diff(r.take(2), r[2], formatChange(_d(r[0]), r[1] as int));
      });
    });

    test('formatChangePct', () {
      _expectAll('formatChangePct', (r) {
        return _diff(r[0], r[1], formatChangePct(_d(r[0])));
      });
    });

    test('compactAmount(억·SI)', () {
      _expectAll('compactAmount', (r) {
        final value = _d(r[0]);
        return _diff(
          r[0],
          [r[1], r[2]],
          [
            compactAmount(value, AmountScheme.eok),
            compactAmount(value, AmountScheme.si),
          ],
        );
      });
    });

    test('월물 표기', () {
      _expectAll('contractMonth', (r) {
        final month = r[0] as String;
        return _diff(
          month,
          [r[1], r[2]],
          [formatContractMonth(month), formatContractMonthShort(month)],
        );
      });
    });
  });

  group('차트', () {
    test('nearestPeriod', () {
      _expectAll('nearestPeriod', (r) {
        return _diff(
          r.take(2),
          r[2],
          nearestPeriod(_d(r[0]), r[1] as int).label,
        );
      });
    });

    // 행: lo, hi, count, 가격 자릿수, RN 눈금, RN 자릿수
    String? ticks(
      List<dynamic> r,
      List<double> Function(double lo, double hi, int count) flTicks,
    ) {
      final rnTicks = _ds(r[4]);
      final fl = flTicks(_d(r[0]), _d(r[1]), r[2] as int);
      final decimals = tickDecimals(fl, r[3] as int);
      return _sameList(fl, rnTicks) && decimals == r[5]
          ? null
          : '  ${r.take(4)} → RN $rnTicks/${r[5]}자리, Flutter $fl/$decimals자리';
    }

    test('C-b 커브 y축 눈금·자릿수(RN niceTicks)', () {
      _expectAll('curveTicks', (r) => ticks(r, linearTicks));
    });

    test('C-c 선형 y축 눈금·자릿수(d3 scaleLinear)', () {
      _expectAll('linearTicks', (r) => ticks(r, linearTicks));
    });

    test('C-a·C-c log y축 눈금·자릿수(d3 scaleLog)', () {
      _expectAll('logTicks', (r) => ticks(r, logTicks));
    });

    test('특수 라벨 밀기(stackLabels)', () {
      _expectAll('stackLabels', (r) {
        final rn = [
          for (final p in r[4] as List) ((p as List)[0] as int, _d(p[1])),
        ];
        final fl = stackLabels(_ds(r[0]), _d(r[1]), _d(r[2]), _d(r[3]));
        final same =
            fl.length == rn.length &&
            Iterable<int>.generate(
              fl.length,
            ).every((i) => fl[i].$1 == rn[i].$1 && _near(fl[i].$2, rn[i].$2));
        return same ? null : '  ${r.take(4)} → RN $rn, Flutter $fl';
      });
    });

    test('labelStride', () {
      _expectAll('labelStride', (r) {
        return _diff(r.take(2), r[2], labelStride(_d(r[0]), _d(r[1])));
      });
    });

    test('nearestSlot', () {
      _expectAll('nearestSlot', (r) {
        return _diff(
          r.take(4),
          r[4],
          nearestSlot(_d(r[0]), _d(r[1]), _d(r[2]), r[3] as int),
        );
      });
    });

    test('segmentHitsBox', () {
      _expectAll('segmentHitsBox', (r) {
        final [x0, y0, x1, y1] = _ds(r[0]);
        final [left, right, top, bottom] = _ds(r[1]);
        return _diff(
          r.take(2),
          r[2],
          segmentHitsBox(
            (x0: x0, y0: y0, x1: x1, y1: y1),
            left,
            right,
            top,
            bottom,
          ),
        );
      });
    });
  });
}
