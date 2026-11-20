import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/features/commodity/curve/curve_format.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(initializeDateFormatting);

  test('기준일 버튼은 연도를 늘 쓴다', () {
    expect(formatFullDate('2026-10-21'), '2026/10/21');
  });

  test('범례 날짜는 D와 같은 해면 MM/DD, 아니면 연도를 붙인다', () {
    expect(formatLegendDate('2026-10-21', '2026-10-22'), '10/21');
    expect(formatLegendDate('2024-03-15', '2026-10-22'), '2024/03/15');
  });

  test('휴장일 안내 요일은 언어를 따른다', () {
    expect(formatWeekday('2026-10-16', 'ko'), '금');
    expect(formatWeekday('2026-10-16', 'en'), 'Fri');
  });

  test('커브 변화율은 소수 첫째 자리', () {
    expect(formatCurvePct(0.512), '+0.5%');
    expect(formatCurvePct(-1.04), '-1.0%');
    expect(formatCurvePct(0.04), '0.0%');
  });

  test('날짜 선택기 값과 날짜 문자열을 오간다', () {
    expect(toPickerDate('2026-03-05'), DateTime(2026, 3, 5));
    expect(fromPickerDate(DateTime(2026, 3, 5)), '2026-03-05');
  });
}
