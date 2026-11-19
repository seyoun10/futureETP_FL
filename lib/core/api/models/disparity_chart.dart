import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/freshness.dart';

part 'disparity_chart.freezed.dart';
part 'disparity_chart.g.dart';

/// `GET /v1/commodities/:code/disparity`(C-a, D-086).
@freezed
abstract class DisparityChart with _$DisparityChart {
  const factory({
    required Freshness freshness,
    required int priceDecimals,
    required Basis basis,

    /// 요청 기준 지수가 없어 대체했는지.
    required bool fallback,
    required MaPeriod maPeriod,
    required DistributionWindow window,
    required DisparityDistribution? distribution,
    required List<RareLevel> rareLevels,
    required CurrentTail? currentTail,

    /// 마지막 봉이 오늘 잠정 값인지.
    required bool provisional,
    required List<DisparityBar> bars,

    /// 이전 3년을 더 받을 수 있는지(D-104).
    required bool hasMore,
  }) = _DisparityChart;

  factory fromJson(Map<String, dynamic> json) => _$DisparityChartFromJson(json);
}

@freezed
abstract class DisparityDistribution with _$DisparityDistribution {
  const factory({required String actualStartDate, required int sampleCount}) =
      _DisparityDistribution;

  factory fromJson(Map<String, dynamic> json) =>
      _$DisparityDistributionFromJson(json);
}

@freezed
abstract class RareLevel with _$RareLevel {
  const factory({
    required Direction direction,

    /// 꼬리 백분율(설정의 rareLevels 값).
    required double level,
    required double disparity,
    required double? price,
  }) = _RareLevel;

  factory fromJson(Map<String, dynamic> json) => _$RareLevelFromJson(json);
}

@freezed
abstract class CurrentTail with _$CurrentTail {
  const factory({required Direction side, required double pct}) = _CurrentTail;

  factory fromJson(Map<String, dynamic> json) => _$CurrentTailFromJson(json);
}

@freezed
abstract class DisparityBar with _$DisparityBar {
  const factory({
    required String tradeDate,
    required double? open,
    required double? high,
    required double? low,
    required double? close,
    required double? ma,
    required double? disparity,
    required bool inRoll,
    required List<Holding> holdings,
  }) = _DisparityBar;

  factory fromJson(Map<String, dynamic> json) => _$DisparityBarFromJson(json);
}

/// 그날 지수가 보유한 월물과 비중.
@freezed
abstract class Holding with _$Holding {
  const factory({required String contractMonth, required double weight}) =
      _Holding;

  factory fromJson(Map<String, dynamic> json) => _$HoldingFromJson(json);
}
