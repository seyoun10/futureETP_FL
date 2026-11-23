import 'package:flutter_test/flutter_test.dart';
import 'package:futureetp/core/api/models/calendar.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/features/calendar/local_schedule.dart';
import 'package:timezone/data/latest_10y.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

// RN `localSchedule.test.ts`와 같은 예시.
CalendarException _ex(
  CalendarMarket market,
  String date, {
  CalendarExceptionKind kind = CalendarExceptionKind.closed,
  String? at,
}) =>
    CalendarException(market: market, date: date, kind: kind, at: at, note: '');

/// [zone]에 있는 기기.
ToLocal _in(String zone) =>
    (instant) => tz.TZDateTime.from(instant, tz.getLocation(zone));

void main() {
  setUpAll(tz_data.initializeTimeZones);

  test('시장 벽시계 시각을 서머타임에 맞춰 UTC로 바꾼다', () {
    expect(
      zonedTimeToInstant('2026-11-27', 13, 0, 'America/New_York'),
      DateTime.utc(2026, 11, 27, 18),
    );
    expect(
      zonedTimeToInstant('2026-07-03', 13, 30, 'America/Chicago'),
      DateTime.utc(2026, 7, 3, 18, 30),
    );
    // 서머타임 시작일(3/8 02:00 CST → 03:00 CDT) 당일 오후
    expect(
      zonedTimeToInstant('2026-03-08', 17, 0, 'America/Chicago'),
      DateTime.utc(2026, 3, 8, 22),
    );
  });

  test('기기 시간대 변환은 tz.local이 아니라 기기 시간대를 따른다', () {
    // TZDateTime을 돌려주면 toLocal()이 tz.local(UTC)로 바뀌어 기기에서 UTC 시각이 보였다
    final instant = zonedTimeToInstant('2026-11-19', 10, 0, 'Asia/Seoul');
    expect(instant, isNot(isA<tz.TZDateTime>()));
    expect(deviceLocal(instant), DateTime.utc(2026, 11, 19, 1).toLocal());
    expect(deviceLocal(instant).isUtc, isFalse);
  });

  test('시각이 있는 일정은 그 시각의 로컬 날짜·시각으로 옮긴다', () {
    final halt = _ex(
      CalendarMarket.cme,
      '2026-11-26',
      kind: CalendarExceptionKind.halt,
      at: '13:30',
    );
    final seoul = toLocalException(halt, toLocal: _in('Asia/Seoul'));
    expect((seoul.localDate, seoul.localTime), ('2026-11-27', '04:30'));
    final la = toLocalException(halt, toLocal: _in('America/Los_Angeles'));
    expect((la.localDate, la.localTime), ('2026-11-26', '11:30'));
    final lateOpen = toLocalException(
      _ex(
        CalendarMarket.krx,
        '2027-01-04',
        kind: CalendarExceptionKind.lateOpen,
        at: '10:00',
      ),
      toLocal: _in('America/New_York'),
    );
    expect((lateOpen.localDate, lateOpen.localTime), ('2027-01-03', '20:00'));
  });

  test('휴장은 그 시장 정규 개장 시각의 로컬 날짜에 둔다', () {
    final nyse = toLocalException(
      _ex(CalendarMarket.nyse, '2026-11-26'),
      toLocal: _in('Asia/Seoul'),
    );
    expect((nyse.localDate, nyse.localTime), ('2026-11-26', null));
    // CME 거래일 세션은 전날 17:00 CT에 열린다
    final cme = _ex(CalendarMarket.cme, '2026-12-25');
    expect(
      toLocalException(cme, toLocal: _in('Asia/Seoul')).localDate,
      '2026-12-25',
    );
    expect(
      toLocalException(cme, toLocal: _in('America/Chicago')).localDate,
      '2026-12-24',
    );
    expect(
      toLocalException(
        _ex(CalendarMarket.krx, '2026-12-31'),
        toLocal: _in('America/New_York'),
      ).localDate,
      '2026-12-30',
    );
  });

  test('로컬 시각순으로 정렬하고, 휴장은 정규 개장 시각으로 센다', () {
    final list = toLocalExceptions([
      _ex(CalendarMarket.krx, '2026-12-25'),
      _ex(
        CalendarMarket.cme,
        '2026-12-24',
        kind: CalendarExceptionKind.earlyClose,
        at: '12:45',
      ),
      _ex(CalendarMarket.nyse, '2026-12-25'),
      _ex(CalendarMarket.cme, '2026-12-25'),
      _ex(
        CalendarMarket.nyse,
        '2026-12-24',
        kind: CalendarExceptionKind.earlyClose,
        at: '13:00',
      ),
    ], toLocal: _in('Asia/Seoul'));
    // 03:00 NYSE 조기 마감, 03:45 CME 조기 마감,
    // 08:00 CME 개장, 09:00 KRX 개장, 23:30 NYSE 개장
    expect(list.map((e) => (e.localDate, e.market, e.kind)), [
      ('2026-12-25', CalendarMarket.nyse, CalendarExceptionKind.earlyClose),
      ('2026-12-25', CalendarMarket.cme, CalendarExceptionKind.earlyClose),
      ('2026-12-25', CalendarMarket.cme, CalendarExceptionKind.closed),
      ('2026-12-25', CalendarMarket.krx, CalendarExceptionKind.closed),
      ('2026-12-25', CalendarMarket.nyse, CalendarExceptionKind.closed),
    ]);
  });

  test('같은 시각이면 시장 순이다', () {
    // 13:30 CT = 14:30 ET
    final list = toLocalExceptions([
      _ex(
        CalendarMarket.nyse,
        '2026-11-26',
        kind: CalendarExceptionKind.earlyClose,
        at: '14:30',
      ),
      _ex(
        CalendarMarket.cme,
        '2026-11-26',
        kind: CalendarExceptionKind.halt,
        at: '13:30',
      ),
    ], toLocal: _in('Asia/Seoul'));
    expect(list.map((e) => e.market), [
      CalendarMarket.cme,
      CalendarMarket.nyse,
    ]);
  });

  test('조회 범위를 앞뒤 하루씩 넓힌다', () {
    expect(widenRange((from: '2027-01-01', to: '2027-02-28')), (
      from: '2026-12-31',
      to: '2027-03-01',
    ));
  });
}
