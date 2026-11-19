import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:futureetp/core/api/models/freshness.dart';

part 'contracts_chart.freezed.dart';
part 'contracts_chart.g.dart';

/// `GET /v1/commodities/:code/contracts`(C-c, D-092).
@freezed
abstract class ContractsChart with _$ContractsChart {
  const factory({
    required Freshness freshness,
    required int priceDecimals,

    /// 모든 월물이 함께 쓰는 거래일 축.
    required List<String> dates,
    required bool hasMore,
    required bool provisional,
    required List<ContractLine> contracts,
  }) = _ContractsChart;

  factory fromJson(Map<String, dynamic> json) => _$ContractsChartFromJson(json);
}

@freezed
abstract class ContractLine with _$ContractLine {
  const factory({
    required String symbol,
    required String contractMonth,
    required String lastTradeDate,
    required bool isFront,

    /// [ContractsChart.dates]와 같은 길이. 상장 전은 null.
    required List<double?> prices,
  }) = _ContractLine;

  factory fromJson(Map<String, dynamic> json) => _$ContractLineFromJson(json);
}
