// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disparity_chart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DisparityChart _$DisparityChartFromJson(Map<String, dynamic> json) =>
    _DisparityChart(
      freshness: Freshness.fromJson(json['freshness'] as Map<String, dynamic>),
      priceDecimals: (json['priceDecimals'] as num).toInt(),
      basis: $enumDecode(_$BasisEnumMap, json['basis']),
      fallback: json['fallback'] as bool,
      maPeriod: $enumDecode(_$MaPeriodEnumMap, json['maPeriod']),
      window: $enumDecode(_$DistributionWindowEnumMap, json['window']),
      distribution: json['distribution'] == null
          ? null
          : DisparityDistribution.fromJson(
              json['distribution'] as Map<String, dynamic>,
            ),
      rareLevels: (json['rareLevels'] as List<dynamic>)
          .map((e) => RareLevel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentTail: json['currentTail'] == null
          ? null
          : CurrentTail.fromJson(json['currentTail'] as Map<String, dynamic>),
      provisional: json['provisional'] as bool,
      bars: (json['bars'] as List<dynamic>)
          .map((e) => DisparityBar.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: json['hasMore'] as bool,
    );

Map<String, dynamic> _$DisparityChartToJson(_DisparityChart instance) =>
    <String, dynamic>{
      'freshness': instance.freshness.toJson(),
      'priceDecimals': instance.priceDecimals,
      'basis': _$BasisEnumMap[instance.basis]!,
      'fallback': instance.fallback,
      'maPeriod': _$MaPeriodEnumMap[instance.maPeriod]!,
      'window': _$DistributionWindowEnumMap[instance.window]!,
      'distribution': instance.distribution?.toJson(),
      'rareLevels': instance.rareLevels.map((e) => e.toJson()).toList(),
      'currentTail': instance.currentTail?.toJson(),
      'provisional': instance.provisional,
      'bars': instance.bars.map((e) => e.toJson()).toList(),
      'hasMore': instance.hasMore,
    };

const _$BasisEnumMap = {Basis.front: 'FRONT', Basis.kr: 'KR', Basis.us: 'US'};

const _$MaPeriodEnumMap = {
  MaPeriod.ma20: 20,
  MaPeriod.ma50: 50,
  MaPeriod.ma100: 100,
  MaPeriod.ma200: 200,
};

const _$DistributionWindowEnumMap = {
  DistributionWindow.y3: 'Y3',
  DistributionWindow.y5: 'Y5',
  DistributionWindow.y10: 'Y10',
  DistributionWindow.all: 'ALL',
};

_DisparityDistribution _$DisparityDistributionFromJson(
  Map<String, dynamic> json,
) => _DisparityDistribution(
  actualStartDate: json['actualStartDate'] as String,
  sampleCount: (json['sampleCount'] as num).toInt(),
);

Map<String, dynamic> _$DisparityDistributionToJson(
  _DisparityDistribution instance,
) => <String, dynamic>{
  'actualStartDate': instance.actualStartDate,
  'sampleCount': instance.sampleCount,
};

_RareLevel _$RareLevelFromJson(Map<String, dynamic> json) => _RareLevel(
  direction: $enumDecode(_$DirectionEnumMap, json['direction']),
  level: (json['level'] as num).toDouble(),
  disparity: (json['disparity'] as num).toDouble(),
  price: (json['price'] as num?)?.toDouble(),
);

Map<String, dynamic> _$RareLevelToJson(_RareLevel instance) =>
    <String, dynamic>{
      'direction': _$DirectionEnumMap[instance.direction]!,
      'level': instance.level,
      'disparity': instance.disparity,
      'price': instance.price,
    };

const _$DirectionEnumMap = {Direction.up: 'UP', Direction.down: 'DOWN'};

_CurrentTail _$CurrentTailFromJson(Map<String, dynamic> json) => _CurrentTail(
  side: $enumDecode(_$DirectionEnumMap, json['side']),
  pct: (json['pct'] as num).toDouble(),
);

Map<String, dynamic> _$CurrentTailToJson(_CurrentTail instance) =>
    <String, dynamic>{
      'side': _$DirectionEnumMap[instance.side]!,
      'pct': instance.pct,
    };

_DisparityBar _$DisparityBarFromJson(Map<String, dynamic> json) =>
    _DisparityBar(
      tradeDate: json['tradeDate'] as String,
      open: (json['open'] as num?)?.toDouble(),
      high: (json['high'] as num?)?.toDouble(),
      low: (json['low'] as num?)?.toDouble(),
      close: (json['close'] as num?)?.toDouble(),
      ma: (json['ma'] as num?)?.toDouble(),
      disparity: (json['disparity'] as num?)?.toDouble(),
      inRoll: json['inRoll'] as bool,
      holdings: (json['holdings'] as List<dynamic>)
          .map((e) => Holding.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DisparityBarToJson(_DisparityBar instance) =>
    <String, dynamic>{
      'tradeDate': instance.tradeDate,
      'open': instance.open,
      'high': instance.high,
      'low': instance.low,
      'close': instance.close,
      'ma': instance.ma,
      'disparity': instance.disparity,
      'inRoll': instance.inRoll,
      'holdings': instance.holdings.map((e) => e.toJson()).toList(),
    };

_Holding _$HoldingFromJson(Map<String, dynamic> json) => _Holding(
  contractMonth: json['contractMonth'] as String,
  weight: (json['weight'] as num).toDouble(),
);

Map<String, dynamic> _$HoldingToJson(_Holding instance) => <String, dynamic>{
  'contractMonth': instance.contractMonth,
  'weight': instance.weight,
};
