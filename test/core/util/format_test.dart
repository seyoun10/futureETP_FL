import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/util/format_amount.dart';
import 'package:futureetp/core/util/format_date_time.dart';
import 'package:futureetp/core/util/format_number.dart';

// RN apps/mobile/src/lib/format*.test.ts와 같은 경우. 결과가 RN과 같아야 한다.
void main() {
  group('formatPrice', () {
    test('천 단위 쉼표와 소수 자릿수를 맞춘다', () {
      expect(formatPrice(2405.1, 1), '2,405.1');
      expect(formatPrice(1234567.891, 2), '1,234,567.89');
      expect(formatPrice(2.7656, 3), '2.766');
      expect(formatPrice(80, 2), '80.00');
      expect(formatPrice(999, 0), '999');
    });

    test('음수는 앞에 -를 붙이고, 반올림해 0이면 붙이지 않는다', () {
      expect(formatPrice(-1234.5, 1), '-1,234.5');
      expect(formatPrice(-0.001, 2), '0.00');
    });
  });

  group('formatChange', () {
    test('상승은 +, 하락은 -를 붙인다', () {
      expect(formatChange(12.15, 1), '+12.2');
      expect(formatChange(-0.029, 3), '-0.029');
      expect(formatChange(-1250, 1), '-1,250.0');
    });

    test('0이거나 반올림해 0이면 부호가 없다', () {
      expect(formatChange(0, 2), '0.00');
      expect(formatChange(0.004, 2), '0.00');
    });
  });

  test('formatChangePct는 소수 둘째 자리 등락률', () {
    expect(formatChangePct(0.5075), '+0.51%');
    expect(formatChangePct(-1.04), '-1.04%');
  });

  test('formatContractMonth는 YYYY-MM을 CME 표기 월물로 쓴다', () {
    expect(formatContractMonth('2026-12'), 'DEC26');
    expect(formatContractMonth('2027-01'), 'JAN27');
  });

  test('formatContractMonthShort는 연도 두 자리 + 월 두 자리', () {
    expect(formatContractMonthShort('2026-12'), '2612');
    expect(formatContractMonthShort('2027-02'), '2702');
  });

  group('formatLocalDateTime', () {
    test('UTC 시각을 현지 MM/DD HH:mm으로 바꾼다', () {
      // Asia/Seoul +9, America/Chicago 10월은 CDT -5
      expect(
        formatLocalDateTime(
          DateTime.parse('2026-10-22T00:00:00Z'),
          utcOffset: const Duration(hours: 9),
        ),
        '10/22 09:00',
      );
      expect(
        formatLocalDateTime(
          DateTime.parse('2026-10-22T14:05:00Z'),
          utcOffset: const Duration(hours: -5),
        ),
        '10/22 09:05',
      );
    });

    test('자정은 00으로, 날짜가 바뀌면 현지 날짜로 쓴다', () {
      expect(
        formatLocalDateTime(
          DateTime.parse('2026-10-22T15:00:00Z'),
          utcOffset: const Duration(hours: 9),
        ),
        '10/23 00:00',
      );
    });

    test('오프셋이 없으면 기기 현지 시각', () {
      final instant = DateTime.parse('2026-10-22T15:00:00Z');
      expect(
        formatLocalDateTime(instant),
        formatLocalDateTime(
          instant,
          utcOffset: instant.toLocal().timeZoneOffset,
        ),
      );
    });
  });

  test('formatTradeDate는 거래일을 MM/DD로 쓴다', () {
    expect(formatTradeDate('2026-01-05'), '01/05');
  });

  group('compactAmount', () {
    test('억·만은 정수로 줄인다', () {
      expect(compactAmount(1555015000000, AmountScheme.eok), '15,550억');
      expect(compactAmount(1198418445, AmountScheme.eok), '12억');
      expect(compactAmount(45000000, AmountScheme.eok), '4,500만');
      expect(compactAmount(9999, AmountScheme.eok), '9,999');
    });

    test('T·B·M·K는 소수 한 자리로 줄인다', () {
      expect(compactAmount(12345678, AmountScheme.si), '12.3M');
      expect(compactAmount(1555015000000, AmountScheme.si), '1.6T');
      expect(compactAmount(850, AmountScheme.si), '850');
    });

    test('반올림해 위 단위에 닿으면 위 단위로 쓴다', () {
      expect(compactAmount(99999999, AmountScheme.eok), '1억');
      expect(compactAmount(999960, AmountScheme.si), '1.0M');
      expect(compactAmount(999940, AmountScheme.si), '999.9K');
    });
  });
}
