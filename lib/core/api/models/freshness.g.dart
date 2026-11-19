// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freshness.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Freshness _$FreshnessFromJson(Map<String, dynamic> json) => _Freshness(
  asOf: DateTime.parse(json['asOf'] as String),
  tradeDate: json['tradeDate'] as String,
  delayed: json['delayed'] as bool,
  marketState: $enumDecode(_$MarketStateEnumMap, json['marketState']),
  nextUpdateAt: json['nextUpdateAt'] == null
      ? null
      : DateTime.parse(json['nextUpdateAt'] as String),
);

Map<String, dynamic> _$FreshnessToJson(_Freshness instance) =>
    <String, dynamic>{
      'asOf': instance.asOf.toIso8601String(),
      'tradeDate': instance.tradeDate,
      'delayed': instance.delayed,
      'marketState': _$MarketStateEnumMap[instance.marketState]!,
      'nextUpdateAt': instance.nextUpdateAt?.toIso8601String(),
    };

const _$MarketStateEnumMap = {
  MarketState.open: 'OPEN',
  MarketState.closed: 'CLOSED',
  MarketState.settlementPending: 'SETTLEMENT_PENDING',
};
