import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/features/calendar/month_grid.dart';

// RN `monthGrid.test.ts`와 같은 예시.
void main() {
  test('오늘이 속한 달부터 3개월이고 연도를 넘긴다', () {
    final months = monthsFrom(DateTime(2026, 11, 21, 9), 3);
    expect(months, [
      (year: 2026, month: 11),
      (year: 2026, month: 12),
      (year: 2027, month: 1),
    ]);
    expect(monthsRange(months), (from: '2026-11-01', to: '2027-01-31'));
  });

  test('말일에 열어도 다음 달을 건너뛰지 않는다', () {
    expect(monthsFrom(DateTime(2027, 1, 31), 2), [
      (year: 2027, month: 1),
      (year: 2027, month: 2),
    ]);
    expect(monthsRange([(year: 2028, month: 2)]).to, '2028-02-29');
  });

  test('칸은 일요일 시작이고 앞뒤를 빈칸으로 채운다', () {
    // 2026-11-01은 일요일, 30일은 월요일
    final nov = monthCells((year: 2026, month: 11));
    expect(nov.first, '2026-11-01');
    expect(nov, hasLength(35));
    expect(nov[29], '2026-11-30');
    expect(nov.sublist(30), [null, null, null, null, null]);
    // 2027-01-01은 금요일
    final jan = monthCells((year: 2027, month: 1));
    expect(jan.sublist(0, 6), [null, null, null, null, null, '2027-01-01']);
    expect(jan.length % 7, 0);
  });

  test('로컬 날짜 키와 요일', () {
    expect(localDateKey(DateTime(2026, 11, 21, 23, 59)), '2026-11-21');
    expect(weekdayOf('2026-11-26'), 4);
    expect(shiftDate('2027-03-01', -1), '2027-02-28');
  });

  test('빈 목록의 범위는 실패한다', () {
    expect(() => monthsRange([]), throwsArgumentError);
  });
}
