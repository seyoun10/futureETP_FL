import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:futureetp/core/api/models/enums.dart';

part 'freshness.freezed.dart';
part 'freshness.g.dart';

/// 데이터 기준 정보(D-048, D-075). A·C 화면 조회 응답에 들어 있다.
///
/// 거래일(`tradeDate` 등 `YYYY-MM-DD`)은 CME 거래일이라 달력 시각이 아닌 문자열로 둔다.
@freezed
abstract class Freshness with _$Freshness {
  const factory({
    required DateTime asOf,
    required String tradeDate,
    required bool delayed,
    required MarketState marketState,

    /// 다음 데이터 갱신 예상 시각. null이면 자동 새로고침하지 않는다.
    required DateTime? nextUpdateAt,
  }) = _Freshness;

  factory fromJson(Map<String, dynamic> json) => _$FreshnessFromJson(json);
}
