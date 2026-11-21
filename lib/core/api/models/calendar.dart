import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:futureetp/core/api/models/enums.dart';

part 'calendar.freezed.dart';
part 'calendar.g.dart';

/// `GET /v1/calendar`(A-a, D-143). 날짜는 `YYYY-MM-DD`(포함).
@freezed
abstract class MarketCalendar with _$MarketCalendar {
  const factory({
    required String from,
    required String to,
    required List<CalendarException> exceptions,

    /// 범위에 걸친 연도 중 휴장 일정이 입력되지 않은 (시장, 연도).
    required List<CalendarMissing> missing,
  }) = _MarketCalendar;

  factory fromJson(Map<String, dynamic> json) => _$MarketCalendarFromJson(json);
}

/// 한 시장의 하루 예외 일정.
@freezed
abstract class CalendarException with _$CalendarException {
  const factory({
    required CalendarMarket market,
    required String date,
    required CalendarExceptionKind kind,

    /// 그 시장 현지 시각 `HH:mm`(CME CT, KRX KST, NYSE ET). `CLOSED`는 null.
    required String? at,

    /// 휴일 이름. 입력 원문(CME·NYSE 영어, KRX 한국어).
    required String note,
  }) = _CalendarException;

  factory fromJson(Map<String, dynamic> json) =>
      _$CalendarExceptionFromJson(json);
}

@freezed
abstract class CalendarMissing with _$CalendarMissing {
  const factory({required CalendarMarket market, required int year}) =
      _CalendarMissing;

  factory fromJson(Map<String, dynamic> json) =>
      _$CalendarMissingFromJson(json);
}
