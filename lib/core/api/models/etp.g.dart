// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'etp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EtpList _$EtpListFromJson(Map<String, dynamic> json) => _EtpList(
  asOf: json['asOf'] == null ? null : DateTime.parse(json['asOf'] as String),
  etps: (json['etps'] as List<dynamic>)
      .map((e) => EtpSummary.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$EtpListToJson(_EtpList instance) => <String, dynamic>{
  'asOf': instance.asOf?.toIso8601String(),
  'etps': instance.etps.map((e) => e.toJson()).toList(),
};

_EtpSummary _$EtpSummaryFromJson(Map<String, dynamic> json) => _EtpSummary(
  id: json['id'] as String,
  market: $enumDecode(_$EtpMarketEnumMap, json['market']),
  type: $enumDecode(_$EtpTypeEnumMap, json['type']),
  leverage: (json['leverage'] as num).toDouble(),
  fxHedge: $enumDecode(_$FxHedgeEnumMap, json['fxHedge']),
  name: json['name'] as String,
  tickers: (json['tickers'] as List<dynamic>).map((e) => e as String).toList(),
  aum: (json['aum'] as num?)?.toDouble(),
  avgTradingValue: (json['avgTradingValue'] as num?)?.toDouble(),
);

Map<String, dynamic> _$EtpSummaryToJson(_EtpSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'market': _$EtpMarketEnumMap[instance.market]!,
      'type': _$EtpTypeEnumMap[instance.type]!,
      'leverage': instance.leverage,
      'fxHedge': _$FxHedgeEnumMap[instance.fxHedge]!,
      'name': instance.name,
      'tickers': instance.tickers,
      'aum': instance.aum,
      'avgTradingValue': instance.avgTradingValue,
    };

const _$EtpMarketEnumMap = {EtpMarket.krx: 'KRX', EtpMarket.us: 'US'};

const _$EtpTypeEnumMap = {EtpType.etf: 'ETF', EtpType.etn: 'ETN'};

const _$FxHedgeEnumMap = {
  FxHedge.hedged: 'HEDGED',
  FxHedge.unhedged: 'UNHEDGED',
  FxHedge.na: 'NA',
};

_EtpDetail _$EtpDetailFromJson(Map<String, dynamic> json) => _EtpDetail(
  id: json['id'] as String,
  market: $enumDecode(_$EtpMarketEnumMap, json['market']),
  type: $enumDecode(_$EtpTypeEnumMap, json['type']),
  leverage: (json['leverage'] as num).toDouble(),
  fxHedge: $enumDecode(_$FxHedgeEnumMap, json['fxHedge']),
  name: json['name'] as String,
  tickers: (json['tickers'] as List<dynamic>).map((e) => e as String).toList(),
  aum: (json['aum'] as num?)?.toDouble(),
  avgTradingValue: (json['avgTradingValue'] as num?)?.toDouble(),
  commodityCode: $enumDecode(_$CommodityCodeEnumMap, json['commodityCode']),
  nameLang: $enumDecode(_$AppLanguageEnumMap, json['nameLang']),
  issuer: json['issuer'] as String?,
  underlyingIndex: json['underlyingIndex'] as String?,
  expenseRatio: (json['expenseRatio'] as num?)?.toDouble(),
  issuerUrl: json['issuerUrl'] as String?,
  listedDate: json['listedDate'] as String?,
  series: (json['series'] as List<dynamic>)
      .map((e) => EtpSeries.fromJson(e as Map<String, dynamic>))
      .toList(),
  collectedAt: DateTime.parse(json['collectedAt'] as String),
);

Map<String, dynamic> _$EtpDetailToJson(_EtpDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'market': _$EtpMarketEnumMap[instance.market]!,
      'type': _$EtpTypeEnumMap[instance.type]!,
      'leverage': instance.leverage,
      'fxHedge': _$FxHedgeEnumMap[instance.fxHedge]!,
      'name': instance.name,
      'tickers': instance.tickers,
      'aum': instance.aum,
      'avgTradingValue': instance.avgTradingValue,
      'commodityCode': _$CommodityCodeEnumMap[instance.commodityCode]!,
      'nameLang': _$AppLanguageEnumMap[instance.nameLang]!,
      'issuer': instance.issuer,
      'underlyingIndex': instance.underlyingIndex,
      'expenseRatio': instance.expenseRatio,
      'issuerUrl': instance.issuerUrl,
      'listedDate': instance.listedDate,
      'series': instance.series.map((e) => e.toJson()).toList(),
      'collectedAt': instance.collectedAt.toIso8601String(),
    };

const _$CommodityCodeEnumMap = {
  CommodityCode.gc: 'GC',
  CommodityCode.si: 'SI',
  CommodityCode.cl: 'CL',
  CommodityCode.ng: 'NG',
};

const _$AppLanguageEnumMap = {AppLanguage.ko: 'ko', AppLanguage.en: 'en'};

_EtpSeries _$EtpSeriesFromJson(Map<String, dynamic> json) => _EtpSeries(
  ticker: json['ticker'] as String,
  seriesCode: json['seriesCode'] as String?,
  maturityDate: json['maturityDate'] as String?,
);

Map<String, dynamic> _$EtpSeriesToJson(_EtpSeries instance) =>
    <String, dynamic>{
      'ticker': instance.ticker,
      'seriesCode': instance.seriesCode,
      'maturityDate': instance.maturityDate,
    };
