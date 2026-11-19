// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contracts_chart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContractsChart _$ContractsChartFromJson(Map<String, dynamic> json) =>
    _ContractsChart(
      freshness: Freshness.fromJson(json['freshness'] as Map<String, dynamic>),
      priceDecimals: (json['priceDecimals'] as num).toInt(),
      dates: (json['dates'] as List<dynamic>).map((e) => e as String).toList(),
      hasMore: json['hasMore'] as bool,
      provisional: json['provisional'] as bool,
      contracts: (json['contracts'] as List<dynamic>)
          .map((e) => ContractLine.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContractsChartToJson(_ContractsChart instance) =>
    <String, dynamic>{
      'freshness': instance.freshness.toJson(),
      'priceDecimals': instance.priceDecimals,
      'dates': instance.dates,
      'hasMore': instance.hasMore,
      'provisional': instance.provisional,
      'contracts': instance.contracts.map((e) => e.toJson()).toList(),
    };

_ContractLine _$ContractLineFromJson(Map<String, dynamic> json) =>
    _ContractLine(
      symbol: json['symbol'] as String,
      contractMonth: json['contractMonth'] as String,
      lastTradeDate: json['lastTradeDate'] as String,
      isFront: json['isFront'] as bool,
      prices: (json['prices'] as List<dynamic>)
          .map((e) => (e as num?)?.toDouble())
          .toList(),
    );

Map<String, dynamic> _$ContractLineToJson(_ContractLine instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'contractMonth': instance.contractMonth,
      'lastTradeDate': instance.lastTradeDate,
      'isFront': instance.isFront,
      'prices': instance.prices,
    };
