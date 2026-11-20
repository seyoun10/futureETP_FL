import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:futureetp/core/api/models/enums.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

/// rare 레벨 입력 범위(shared `RARE_LEVEL_*`). 소수 첫째 자리까지, 서로 다른 5개.
const rareLevelCount = 5;
const rareLevelMin = 0.1;
const rareLevelMax = 49.9;

/// 알림 거부 시간: 현지 자정 기준 분, 30분 단위(shared `QUIET_*`).
const quietStepMin = 30;
const int quietMaxMin = 24 * 60 - quietStepMin;

/// 이격도차트 설정 기본값(shared `DISPARITY_SETTINGS_DEFAULTS`). B [초기화]가 이 값으로 PATCH한다.
const SettingsPatch disparitySettingsDefaults = SettingsPatch(
  basis: Basis.front,
  maPeriod: MaPeriod.ma100,
  window: DistributionWindow.y10,
  rareLevels: [1, 2, 4, 8, 16],
);

/// shared `rareLevelSchema`: 범위 안이고 소수 첫째 자리까지(부동소수 오차는 허용).
bool isValidRareLevel(double level) =>
    level >= rareLevelMin &&
    level <= rareLevelMax &&
    (level * 10 - (level * 10).roundToDouble()).abs() < 1e-9;

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

  /// [settings]에 이 변경을 얹은 값(낙관적 표시). rare 레벨 정렬은 서버가 하므로 화면이 정렬해 보낸다.
  DeviceSettings applyTo(DeviceSettings settings) => settings.copyWith(
    locale: locale ?? settings.locale,
    timezone: timezone ?? settings.timezone,
    basis: basis ?? settings.basis,
    maPeriod: maPeriod ?? settings.maPeriod,
    window: window ?? settings.window,
    rareLevels: rareLevels ?? settings.rareLevels,
    alertCommodity: switch (alertCommodity) {
      PatchValue(:final value) => value,
      null => settings.alertCommodity,
    },
    quietTime: switch (quietTime) {
      PatchValue(:final value) => value,
      null => settings.quietTime,
    },
  );

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
