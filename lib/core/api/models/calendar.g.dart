// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MarketCalendar _$MarketCalendarFromJson(Map<String, dynamic> json) =>
    _MarketCalendar(
      from: json['from'] as String,
      to: json['to'] as String,
      exceptions: (json['exceptions'] as List<dynamic>)
          .map((e) => CalendarException.fromJson(e as Map<String, dynamic>))
          .toList(),
      missing: (json['missing'] as List<dynamic>)
          .map((e) => CalendarMissing.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MarketCalendarToJson(_MarketCalendar instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'exceptions': instance.exceptions.map((e) => e.toJson()).toList(),
      'missing': instance.missing.map((e) => e.toJson()).toList(),
    };

_CalendarException _$CalendarExceptionFromJson(Map<String, dynamic> json) =>
    _CalendarException(
      market: $enumDecode(_$CalendarMarketEnumMap, json['market']),
      date: json['date'] as String,
      kind: $enumDecode(_$CalendarExceptionKindEnumMap, json['kind']),
      at: json['at'] as String?,
      note: json['note'] as String,
    );

Map<String, dynamic> _$CalendarExceptionToJson(_CalendarException instance) =>
    <String, dynamic>{
      'market': _$CalendarMarketEnumMap[instance.market]!,
      'date': instance.date,
      'kind': _$CalendarExceptionKindEnumMap[instance.kind]!,
      'at': instance.at,
      'note': instance.note,
    };

const _$CalendarMarketEnumMap = {
  CalendarMarket.cme: 'CME',
  CalendarMarket.krx: 'KRX',
  CalendarMarket.nyse: 'NYSE',
};

const _$CalendarExceptionKindEnumMap = {
  CalendarExceptionKind.closed: 'CLOSED',
  CalendarExceptionKind.halt: 'HALT',
  CalendarExceptionKind.earlyClose: 'EARLY_CLOSE',
  CalendarExceptionKind.lateOpen: 'LATE_OPEN',
};

_CalendarMissing _$CalendarMissingFromJson(Map<String, dynamic> json) =>
    _CalendarMissing(
      market: $enumDecode(_$CalendarMarketEnumMap, json['market']),
      year: (json['year'] as num).toInt(),
    );

Map<String, dynamic> _$CalendarMissingToJson(_CalendarMissing instance) =>
    <String, dynamic>{
      'market': _$CalendarMarketEnumMap[instance.market]!,
      'year': instance.year,
    };
