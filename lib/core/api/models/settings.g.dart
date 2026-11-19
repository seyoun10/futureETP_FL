// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceSettings _$DeviceSettingsFromJson(Map<String, dynamic> json) =>
    _DeviceSettings(
      locale: $enumDecode(_$AppLanguageEnumMap, json['locale']),
      timezone: json['timezone'] as String,
      basis: $enumDecode(_$BasisEnumMap, json['basis']),
      maPeriod: $enumDecode(_$MaPeriodEnumMap, json['maPeriod']),
      window: $enumDecode(_$DistributionWindowEnumMap, json['window']),
      rareLevels: (json['rareLevels'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      alertCommodity: $enumDecodeNullable(
        _$CommodityCodeEnumMap,
        json['alertCommodity'],
      ),
      quietTime: json['quietTime'] == null
          ? null
          : QuietTime.fromJson(json['quietTime'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeviceSettingsToJson(_DeviceSettings instance) =>
    <String, dynamic>{
      'locale': _$AppLanguageEnumMap[instance.locale]!,
      'timezone': instance.timezone,
      'basis': _$BasisEnumMap[instance.basis]!,
      'maPeriod': _$MaPeriodEnumMap[instance.maPeriod]!,
      'window': _$DistributionWindowEnumMap[instance.window]!,
      'rareLevels': instance.rareLevels,
      'alertCommodity': _$CommodityCodeEnumMap[instance.alertCommodity],
      'quietTime': instance.quietTime?.toJson(),
    };

const _$AppLanguageEnumMap = {AppLanguage.ko: 'ko', AppLanguage.en: 'en'};

const _$BasisEnumMap = {Basis.front: 'FRONT', Basis.kr: 'KR', Basis.us: 'US'};

const _$MaPeriodEnumMap = {
  MaPeriod.ma20: 20,
  MaPeriod.ma50: 50,
  MaPeriod.ma100: 100,
  MaPeriod.ma200: 200,
};

const _$DistributionWindowEnumMap = {
  DistributionWindow.y3: 'Y3',
  DistributionWindow.y5: 'Y5',
  DistributionWindow.y10: 'Y10',
  DistributionWindow.all: 'ALL',
};

const _$CommodityCodeEnumMap = {
  CommodityCode.gc: 'GC',
  CommodityCode.si: 'SI',
  CommodityCode.cl: 'CL',
  CommodityCode.ng: 'NG',
};

_QuietTime _$QuietTimeFromJson(Map<String, dynamic> json) => _QuietTime(
  startMin: (json['startMin'] as num).toInt(),
  endMin: (json['endMin'] as num).toInt(),
);

Map<String, dynamic> _$QuietTimeToJson(_QuietTime instance) =>
    <String, dynamic>{'startMin': instance.startMin, 'endMin': instance.endMin};
