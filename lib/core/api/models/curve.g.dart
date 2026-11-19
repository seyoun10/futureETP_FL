// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curve.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Curve _$CurveFromJson(Map<String, dynamic> json) => _Curve(
  freshness: Freshness.fromJson(json['freshness'] as Map<String, dynamic>),
  priceDecimals: (json['priceDecimals'] as num).toInt(),
  baseDate: json['baseDate'] as String,
  baseOffset: (json['baseOffset'] as num).toInt(),
  prevBaseDate: json['prevBaseDate'] as String?,
  nextBaseDate: json['nextBaseDate'] as String?,
  minBaseDate: json['minBaseDate'] as String,
  maxBaseDate: json['maxBaseDate'] as String,
  compareDate: json['compareDate'] as String,
  points: (json['points'] as List<dynamic>)
      .map((e) => CurvePoint.fromJson(e as Map<String, dynamic>))
      .toList(),
  current: json['current'] == null
      ? null
      : CurveSpread.fromJson(json['current'] as Map<String, dynamic>),
  base: json['base'] == null
      ? null
      : CurveSpread.fromJson(json['base'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CurveToJson(_Curve instance) => <String, dynamic>{
  'freshness': instance.freshness.toJson(),
  'priceDecimals': instance.priceDecimals,
  'baseDate': instance.baseDate,
  'baseOffset': instance.baseOffset,
  'prevBaseDate': instance.prevBaseDate,
  'nextBaseDate': instance.nextBaseDate,
  'minBaseDate': instance.minBaseDate,
  'maxBaseDate': instance.maxBaseDate,
  'compareDate': instance.compareDate,
  'points': instance.points.map((e) => e.toJson()).toList(),
  'current': instance.current?.toJson(),
  'base': instance.base?.toJson(),
};

_CurvePoint _$CurvePointFromJson(Map<String, dynamic> json) => _CurvePoint(
  symbol: json['symbol'] as String,
  contractMonth: json['contractMonth'] as String,
  basePrice: (json['basePrice'] as num?)?.toDouble(),
  currentPrice: (json['currentPrice'] as num?)?.toDouble(),
  changePct: (json['changePct'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CurvePointToJson(_CurvePoint instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'contractMonth': instance.contractMonth,
      'basePrice': instance.basePrice,
      'currentPrice': instance.currentPrice,
      'changePct': instance.changePct,
    };

_CurveSpread _$CurveSpreadFromJson(Map<String, dynamic> json) => _CurveSpread(
  m1ContractMonth: json['m1ContractMonth'] as String,
  m2ContractMonth: json['m2ContractMonth'] as String,
  state: $enumDecode(_$CurveStateEnumMap, json['state']),
  spreadPct: (json['spreadPct'] as num).toDouble(),
  rollYieldPct: (json['rollYieldPct'] as num).toDouble(),
);

Map<String, dynamic> _$CurveSpreadToJson(_CurveSpread instance) =>
    <String, dynamic>{
      'm1ContractMonth': instance.m1ContractMonth,
      'm2ContractMonth': instance.m2ContractMonth,
      'state': _$CurveStateEnumMap[instance.state]!,
      'spreadPct': instance.spreadPct,
      'rollYieldPct': instance.rollYieldPct,
    };

const _$CurveStateEnumMap = {
  CurveState.contango: 'CONTANGO',
  CurveState.backwardation: 'BACKWARDATION',
  CurveState.flat: 'FLAT',
};
