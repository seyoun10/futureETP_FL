import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:futureetp/core/api/models/enums.dart';
import 'package:futureetp/core/api/models/freshness.dart';

part 'curve.freezed.dart';
part 'curve.g.dart';

/// `GET /v1/commodities/:code/curve`(C-b, D-090).
@freezed
abstract class Curve with _$Curve {
  const factory({
    required Freshness freshness,
    required int priceDecimals,

    /// 서버가 거래일로 맞춘 기준일.
    required String baseDate,
    required int baseOffset,
    required String? prevBaseDate,
    required String? nextBaseDate,
    required String minBaseDate,
    required String maxBaseDate,

    /// 기준일 다음 거래일(D-114).
    required String compareDate,
    required List<CurvePoint> points,
    required CurveSpread? current,
    required CurveSpread? base,
  }) = _Curve;

  factory fromJson(Map<String, dynamic> json) => _$CurveFromJson(json);
}

@freezed
abstract class CurvePoint with _$CurvePoint {
  const factory({
    required String symbol,
    required String contractMonth,
    required double? basePrice,
    required double? currentPrice,
    required double? changePct,
  }) = _CurvePoint;

  factory fromJson(Map<String, dynamic> json) => _$CurvePointFromJson(json);
}

/// M1 → M2 스프레드·롤 수익률.
@freezed
abstract class CurveSpread with _$CurveSpread {
  const factory({
    required String m1ContractMonth,
    required String m2ContractMonth,
    required CurveState state,
    required double spreadPct,
    required double rollYieldPct,
  }) = _CurveSpread;

  factory fromJson(Map<String, dynamic> json) => _$CurveSpreadFromJson(json);
}
