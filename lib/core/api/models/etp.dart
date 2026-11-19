import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:futureetp/core/api/models/enums.dart';

part 'etp.freezed.dart';
part 'etp.g.dart';

/// `GET /v1/commodities/:code/etps`(C-d). 필터·정렬은 앱에서(D-017).
@freezed
abstract class EtpList with _$EtpList {
  const factory({
    /// 상품 수집 시각 중 가장 늦은 값.
    required DateTime? asOf,
    required List<EtpSummary> etps,
  }) = _EtpList;

  factory fromJson(Map<String, dynamic> json) => _$EtpListFromJson(json);
}

@freezed
abstract class EtpSummary with _$EtpSummary {
  const factory({
    required String id,
    required EtpMarket market,
    required EtpType type,
    required double leverage,
    required FxHedge fxHedge,
    required String name,
    required List<String> tickers,
    required double? aum,
    required double? avgTradingValue,
  }) = _EtpSummary;

  factory fromJson(Map<String, dynamic> json) => _$EtpSummaryFromJson(json);
}

/// `GET /v1/etps/:id`(C-d-a). 목록 행 + 상세 필드.
@freezed
abstract class EtpDetail with _$EtpDetail {
  const factory({
    required String id,
    required EtpMarket market,
    required EtpType type,
    required double leverage,
    required FxHedge fxHedge,
    required String name,
    required List<String> tickers,
    required double? aum,
    required double? avgTradingValue,
    required CommodityCode commodityCode,
    required AppLanguage nameLang,
    required String? issuer,
    required String? underlyingIndex,
    required double? expenseRatio,
    required String? issuerUrl,
    required String? listedDate,
    required List<EtpSeries> series,
    required DateTime collectedAt,
  }) = _EtpDetail;

  factory fromJson(Map<String, dynamic> json) => _$EtpDetailFromJson(json);
}

/// 상장 중 시리즈 줄(ETN 등).
@freezed
abstract class EtpSeries with _$EtpSeries {
  const factory({
    required String ticker,
    required String? seriesCode,
    required String? maturityDate,
  }) = _EtpSeries;

  factory fromJson(Map<String, dynamic> json) => _$EtpSeriesFromJson(json);
}
