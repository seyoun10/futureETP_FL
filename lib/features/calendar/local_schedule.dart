import 'package:futureetp/core/api/models/calendar.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/features/calendar/month_grid.dart';
import 'package:timezone/data/latest_10y.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

// 휴장 달력의 예외 일정(시장 현지 날짜·시각)을 기기 로컬 날짜·시각으로 옮긴다
// (D-144, RN `localSchedule.ts`). 시각이 있는 일정은 그 시각을, 휴장(CLOSED)은 그 시장
// 정규 개장 시각을 로컬로 바꾼 날짜에 둔다.

const Map<CalendarMarket, String> _marketTimeZones = {
  CalendarMarket.cme: 'America/Chicago',
  CalendarMarket.krx: 'Asia/Seoul',
  CalendarMarket.nyse: 'America/New_York',
};

/// 정규 개장 시각. CME 거래일 세션은 전날 17:00 CT에 열린다(D-061).
const Map<CalendarMarket, ({int dayOffset, int hour, int minute})>
_regularOpen = {
  CalendarMarket.cme: (dayOffset: -1, hour: 17, minute: 0),
  CalendarMarket.krx: (dayOffset: 0, hour: 9, minute: 0),
  CalendarMarket.nyse: (dayOffset: 0, hour: 9, minute: 30),
};

/// UTC 시각을 기기 벽시계 시각으로 바꾼다. 앱은 [DateTime.toLocal]이고, 테스트는 시간대를 고정한다.
typedef ToLocal = DateTime Function(DateTime instant);

DateTime deviceLocal(DateTime instant) => instant.toLocal();

bool _tzLoaded = false;

tz.Location _location(String name) {
  if (!_tzLoaded) {
    tz_data.initializeTimeZones();
    _tzLoaded = true;
  }
  return tz.getLocation(name);
}

/// [timeZone]의 벽시계 [date] [hour]:[minute] → UTC 시각. 서머타임 경계도 맞춘다.
DateTime zonedTimeToInstant(
  String date,
  int hour,
  int minute,
  String timeZone,
) {
  final d = DateTime.parse(date);
  return tz.TZDateTime(
    _location(timeZone),
    d.year,
    d.month,
    d.day,
    hour,
    minute,
  ).toUtc();
}

String _pad(int n) => n.toString().padLeft(2, '0');

/// 기기 로컬 날짜·시각으로 옮긴 예외 일정.
class LocalCalendarException {
  const new({
    required this.exception,
    required this.localDate,
    required this.localTime,
    required this.instant,
  });

  final CalendarException exception;

  /// 기기 로컬 `YYYY-MM-DD`.
  final String localDate;

  /// 기기 로컬 `HH:mm`. `at`이 없는 휴장은 null.
  final String? localTime;

  /// 정렬 기준 UTC 시각. `at`, 휴장은 정규 개장 시각.
  final DateTime instant;

  CalendarMarket get market => exception.market;
  CalendarExceptionKind get kind => exception.kind;

  /// 채운 점(휴장·거래 중단). 아니면 빈 점(조기 마감·개장 지연).
  bool get isClosed =>
      kind == CalendarExceptionKind.closed ||
      kind == CalendarExceptionKind.halt;
}

LocalCalendarException toLocalException(
  CalendarException e, {
  ToLocal toLocal = deviceLocal,
}) {
  final zone = _marketTimeZones[e.market]!;
  final at = e.at;
  final DateTime instant;
  if (at != null) {
    final [hour, minute] = at.split(':').map(int.parse).toList();
    instant = zonedTimeToInstant(e.date, hour, minute, zone);
  } else {
    final open = _regularOpen[e.market]!;
    instant = zonedTimeToInstant(
      shiftDate(e.date, open.dayOffset),
      open.hour,
      open.minute,
      zone,
    );
  }
  final local = toLocal(instant);
  return LocalCalendarException(
    exception: e,
    localDate: localDateKey(local),
    localTime: at == null ? null : '${_pad(local.hour)}:${_pad(local.minute)}',
    instant: instant,
  );
}

/// 로컬 시각순(휴장은 정규 개장 시각), 같은 시각은 시장 순.
List<LocalCalendarException> toLocalExceptions(
  List<CalendarException> exceptions, {
  ToLocal toLocal = deviceLocal,
}) =>
    [for (final e in exceptions) toLocalException(e, toLocal: toLocal)]
      ..sort((a, b) {
        final byTime = a.instant.compareTo(b.instant);
        return byTime != 0 ? byTime : a.market.index - b.market.index;
      });

/// 로컬 날짜로 옮기면 시장 날짜가 하루 앞뒤로 움직이므로 조회 범위를 하루씩 넓힌다.
({String from, String to}) widenRange(({String from, String to}) range) =>
    (from: shiftDate(range.from, -1), to: shiftDate(range.to, 1));
