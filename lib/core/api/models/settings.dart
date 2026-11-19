import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:futureetp/core/api/models/enums.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

/// `GET·PATCH /v1/settings`: 헤더 기기의 설정(D-120).
@freezed
abstract class DeviceSettings with _$DeviceSettings {
  const factory({
    required AppLanguage locale,

    /// IANA 시간대(`Asia/Seoul`).
    required String timezone,
    required Basis basis,
    required MaPeriod maPeriod,
    required DistributionWindow window,

    /// 꼬리 백분율 5개.
    required List<double> rareLevels,

    /// 알림 대상 원자재. null이면 알림 없음.
    required CommodityCode? alertCommodity,

    /// 알림 거부 시간. null이면 없음.
    required QuietTime? quietTime,
  }) = _DeviceSettings;

  factory fromJson(Map<String, dynamic> json) => _$DeviceSettingsFromJson(json);
}

/// 하루 안의 분(0~1439). start > end면 자정을 넘는다.
@freezed
abstract class QuietTime with _$QuietTime {
  const factory({required int startMin, required int endMin}) = _QuietTime;

  factory fromJson(Map<String, dynamic> json) => _$QuietTimeFromJson(json);
}

/// null로 지울 수 있는 PATCH 필드의 값. 필드가 null이면 보내지 않고, `PatchValue(null)`이면 지운다.
@immutable
final class PatchValue<T> {
  const new(this.value);

  final T value;
}

/// `PATCH /v1/settings` 본문(settingsPatch.json). 바꿀 필드만 보낸다(D-081).
@immutable
class SettingsPatch {
  const new({
    this.locale,
    this.timezone,
    this.basis,
    this.maPeriod,
    this.window,
    this.rareLevels,
    this.alertCommodity,
    this.quietTime,
  });

  final AppLanguage? locale;
  final String? timezone;
  final Basis? basis;
  final MaPeriod? maPeriod;
  final DistributionWindow? window;
  final List<double>? rareLevels;
  final PatchValue<CommodityCode?>? alertCommodity;
  final PatchValue<QuietTime?>? quietTime;

  Map<String, Object?> toJson() => {
    if (locale case final v?) 'locale': v.name,
    'timezone': ?timezone,
    if (basis case final v?) 'basis': _$BasisEnumMap[v],
    if (maPeriod case final v?) 'maPeriod': v.days,
    if (window case final v?) 'window': _$DistributionWindowEnumMap[v],
    'rareLevels': ?rareLevels,
    if (alertCommodity case PatchValue(:final value))
      'alertCommodity': value?.wire,
    if (quietTime case PatchValue(:final value)) 'quietTime': value?.toJson(),
  };
}
