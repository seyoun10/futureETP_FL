// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commodities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommodityList _$CommodityListFromJson(Map<String, dynamic> json) =>
    _CommodityList(
      freshness: Freshness.fromJson(json['freshness'] as Map<String, dynamic>),
      commodities: (json['commodities'] as List<dynamic>)
          .map((e) => CommodityQuotes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommodityListToJson(_CommodityList instance) =>
    <String, dynamic>{
      'freshness': instance.freshness.toJson(),
      'commodities': instance.commodities.map((e) => e.toJson()).toList(),
    };

_CommodityQuotes _$CommodityQuotesFromJson(Map<String, dynamic> json) =>
    _CommodityQuotes(
      code: $enumDecode(_$CommodityCodeEnumMap, json['code']),
      priceDecimals: (json['priceDecimals'] as num).toInt(),
      alert: json['alert'] as bool,
      contracts: (json['contracts'] as List<dynamic>)
          .map((e) => ContractQuote.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommodityQuotesToJson(_CommodityQuotes instance) =>
    <String, dynamic>{
      'code': _$CommodityCodeEnumMap[instance.code]!,
      'priceDecimals': instance.priceDecimals,
      'alert': instance.alert,
      'contracts': instance.contracts.map((e) => e.toJson()).toList(),
    };

const _$CommodityCodeEnumMap = {
  CommodityCode.gc: 'GC',
  CommodityCode.si: 'SI',
  CommodityCode.cl: 'CL',
  CommodityCode.ng: 'NG',
};

_ContractQuote _$ContractQuoteFromJson(Map<String, dynamic> json) =>
    _ContractQuote(
      symbol: json['symbol'] as String,
      contractMonth: json['contractMonth'] as String,
      price: (json['price'] as num?)?.toDouble(),
      change: (json['change'] as num?)?.toDouble(),
      changePct: (json['changePct'] as num?)?.toDouble(),
      noTrade: json['noTrade'] as bool,
      isFront: json['isFront'] as bool,
    );

Map<String, dynamic> _$ContractQuoteToJson(_ContractQuote instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'contractMonth': instance.contractMonth,
      'price': instance.price,
      'change': instance.change,
      'changePct': instance.changePct,
      'noTrade': instance.noTrade,
      'isFront': instance.isFront,
    };
