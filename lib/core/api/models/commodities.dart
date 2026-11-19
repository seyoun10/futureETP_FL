import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/freshness.dart';

part 'commodities.freezed.dart';
part 'commodities.g.dart';

/// `GET /v1/commodities`(A, D-085).
@freezed
abstract class CommodityList with _$CommodityList {
  const factory({
    required Freshness freshness,
    required List<CommodityQuotes> commodities,
  }) = _CommodityList;

  factory fromJson(Map<String, dynamic> json) => _$CommodityListFromJson(json);
}

/// 원자재 한 줄: 월물 시세 목록과 알림 표시.
@freezed
abstract class CommodityQuotes with _$CommodityQuotes {
  const factory({
    required CommodityCode code,
    required int priceDecimals,
    required bool alert,
    required List<ContractQuote> contracts,
  }) = _CommodityQuotes;

  factory fromJson(Map<String, dynamic> json) =>
      _$CommodityQuotesFromJson(json);
}

@freezed
abstract class ContractQuote with _$ContractQuote {
  const factory({
    /// 서버 표준형(`GCZ26`).
    required String symbol,

    /// `YYYY-MM`.
    required String contractMonth,
    required double? price,
    required double? change,
    required double? changePct,
    required bool noTrade,
    required bool isFront,
  }) = _ContractQuote;

  factory fromJson(Map<String, dynamic> json) => _$ContractQuoteFromJson(json);
}
