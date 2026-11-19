// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeviceSettings {

 AppLanguage get locale;/// IANA 시간대(`Asia/Seoul`).
 String get timezone; Basis get basis; MaPeriod get maPeriod; DistributionWindow get window;/// 꼬리 백분율 5개.
 List<double> get rareLevels;/// 알림 대상 원자재. null이면 알림 없음.
 CommodityCode? get alertCommodity;/// 알림 거부 시간. null이면 없음.
 QuietTime? get quietTime;
/// Create a copy of DeviceSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceSettingsCopyWith<DeviceSettings> get copyWith => _$DeviceSettingsCopyWithImpl<DeviceSettings>(this as DeviceSettings, _$identity);

  /// Serializes this DeviceSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeviceSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSettings&&(identical(other.locale, _this.locale) || other.locale == _this.locale)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.basis, _this.basis) || other.basis == _this.basis)&&(identical(other.maPeriod, _this.maPeriod) || other.maPeriod == _this.maPeriod)&&(identical(other.window, _this.window) || other.window == _this.window)&&const DeepCollectionEquality().equals(other.rareLevels, _this.rareLevels)&&(identical(other.alertCommodity, _this.alertCommodity) || other.alertCommodity == _this.alertCommodity)&&(identical(other.quietTime, _this.quietTime) || other.quietTime == _this.quietTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeviceSettings;
  return Object.hash(runtimeType,_this.locale,_this.timezone,_this.basis,_this.maPeriod,_this.window,const DeepCollectionEquality().hash(_this.rareLevels),_this.alertCommodity,_this.quietTime);
}

@override
String toString() {
  final _this = this as DeviceSettings;
  return 'DeviceSettings(locale: ${_this.locale}, timezone: ${_this.timezone}, basis: ${_this.basis}, maPeriod: ${_this.maPeriod}, window: ${_this.window}, rareLevels: ${_this.rareLevels}, alertCommodity: ${_this.alertCommodity}, quietTime: ${_this.quietTime})';
}


}

/// @nodoc
abstract mixin class $DeviceSettingsCopyWith<$Res>  {
  factory $DeviceSettingsCopyWith(DeviceSettings value, $Res Function(DeviceSettings) _then) = _$DeviceSettingsCopyWithImpl;
@useResult
$Res call({
 AppLanguage locale, String timezone, Basis basis, MaPeriod maPeriod, DistributionWindow window, List<double> rareLevels, CommodityCode? alertCommodity, QuietTime? quietTime
});


$QuietTimeCopyWith<$Res>? get quietTime;

}
/// @nodoc
class _$DeviceSettingsCopyWithImpl<$Res>
    implements $DeviceSettingsCopyWith<$Res> {
  _$DeviceSettingsCopyWithImpl(this._self, this._then);

  final DeviceSettings _self;
  final $Res Function(DeviceSettings) _then;

/// Create a copy of DeviceSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locale = null,Object? timezone = null,Object? basis = null,Object? maPeriod = null,Object? window = null,Object? rareLevels = null,Object? alertCommodity = freezed,Object? quietTime = freezed,}) {
  return _then(DeviceSettings(
locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as AppLanguage,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,basis: null == basis ? _self.basis : basis // ignore: cast_nullable_to_non_nullable
as Basis,maPeriod: null == maPeriod ? _self.maPeriod : maPeriod // ignore: cast_nullable_to_non_nullable
as MaPeriod,window: null == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as DistributionWindow,rareLevels: null == rareLevels ? _self.rareLevels : rareLevels // ignore: cast_nullable_to_non_nullable
as List<double>,alertCommodity: freezed == alertCommodity ? _self.alertCommodity : alertCommodity // ignore: cast_nullable_to_non_nullable
as CommodityCode?,quietTime: freezed == quietTime ? _self.quietTime : quietTime // ignore: cast_nullable_to_non_nullable
as QuietTime?,
  ));
}
/// Create a copy of DeviceSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuietTimeCopyWith<$Res>? get quietTime {
    if (_self.quietTime == null) {
    return null;
  }

  return $QuietTimeCopyWith<$Res>(_self.quietTime!, (value) {
    return _then(_self.copyWith(quietTime: value));
  });
}
}


/// Adds pattern-matching-related methods to [DeviceSettings].
extension DeviceSettingsPatterns on DeviceSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceSettings value)  $default,){
final _that = this;
switch (_that) {
case _DeviceSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceSettings value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppLanguage locale,  String timezone,  Basis basis,  MaPeriod maPeriod,  DistributionWindow window,  List<double> rareLevels,  CommodityCode? alertCommodity,  QuietTime? quietTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceSettings() when $default != null:
return $default(_that.locale,_that.timezone,_that.basis,_that.maPeriod,_that.window,_that.rareLevels,_that.alertCommodity,_that.quietTime);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppLanguage locale,  String timezone,  Basis basis,  MaPeriod maPeriod,  DistributionWindow window,  List<double> rareLevels,  CommodityCode? alertCommodity,  QuietTime? quietTime)  $default,) {final _that = this;
switch (_that) {
case _DeviceSettings():
return $default(_that.locale,_that.timezone,_that.basis,_that.maPeriod,_that.window,_that.rareLevels,_that.alertCommodity,_that.quietTime);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppLanguage locale,  String timezone,  Basis basis,  MaPeriod maPeriod,  DistributionWindow window,  List<double> rareLevels,  CommodityCode? alertCommodity,  QuietTime? quietTime)?  $default,) {final _that = this;
switch (_that) {
case _DeviceSettings() when $default != null:
return $default(_that.locale,_that.timezone,_that.basis,_that.maPeriod,_that.window,_that.rareLevels,_that.alertCommodity,_that.quietTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceSettings implements DeviceSettings {
  const _DeviceSettings({required this.locale, required this.timezone, required this.basis, required this.maPeriod, required this.window, required  List<double> rareLevels, required this.alertCommodity, required this.quietTime}): _rareLevels = rareLevels;
  factory _DeviceSettings.fromJson(Map<String, dynamic> json) => _$DeviceSettingsFromJson(json);

@override final  AppLanguage locale;
/// IANA 시간대(`Asia/Seoul`).
@override final  String timezone;
@override final  Basis basis;
@override final  MaPeriod maPeriod;
@override final  DistributionWindow window;
/// 꼬리 백분율 5개.
 final  List<double> _rareLevels;
/// 꼬리 백분율 5개.
@override List<double> get rareLevels {
  if (_rareLevels is EqualUnmodifiableListView) return _rareLevels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rareLevels);
}

/// 알림 대상 원자재. null이면 알림 없음.
@override final  CommodityCode? alertCommodity;
/// 알림 거부 시간. null이면 없음.
@override final  QuietTime? quietTime;

/// Create a copy of DeviceSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceSettingsCopyWith<_DeviceSettings> get copyWith => __$DeviceSettingsCopyWithImpl<_DeviceSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceSettings&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.basis, basis) || other.basis == basis)&&(identical(other.maPeriod, maPeriod) || other.maPeriod == maPeriod)&&(identical(other.window, window) || other.window == window)&&const DeepCollectionEquality().equals(other.rareLevels, _rareLevels)&&(identical(other.alertCommodity, alertCommodity) || other.alertCommodity == alertCommodity)&&(identical(other.quietTime, quietTime) || other.quietTime == quietTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,locale,timezone,basis,maPeriod,window,const DeepCollectionEquality().hash(_rareLevels),alertCommodity,quietTime);
}

@override
String toString() {
    return 'DeviceSettings(locale: $locale, timezone: $timezone, basis: $basis, maPeriod: $maPeriod, window: $window, rareLevels: $rareLevels, alertCommodity: $alertCommodity, quietTime: $quietTime)';
}


}

/// @nodoc
abstract mixin class _$DeviceSettingsCopyWith<$Res> implements $DeviceSettingsCopyWith<$Res> {
  factory _$DeviceSettingsCopyWith(_DeviceSettings value, $Res Function(_DeviceSettings) _then) = __$DeviceSettingsCopyWithImpl;
@override @useResult
$Res call({
 AppLanguage locale, String timezone, Basis basis, MaPeriod maPeriod, DistributionWindow window, List<double> rareLevels, CommodityCode? alertCommodity, QuietTime? quietTime
});


@override $QuietTimeCopyWith<$Res>? get quietTime;

}
/// @nodoc
class __$DeviceSettingsCopyWithImpl<$Res>
    implements _$DeviceSettingsCopyWith<$Res> {
  __$DeviceSettingsCopyWithImpl(this._self, this._then);

  final _DeviceSettings _self;
  final $Res Function(_DeviceSettings) _then;

/// Create a copy of DeviceSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locale = null,Object? timezone = null,Object? basis = null,Object? maPeriod = null,Object? window = null,Object? rareLevels = null,Object? alertCommodity = freezed,Object? quietTime = freezed,}) {
  return _then(_DeviceSettings(
locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as AppLanguage,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,basis: null == basis ? _self.basis : basis // ignore: cast_nullable_to_non_nullable
as Basis,maPeriod: null == maPeriod ? _self.maPeriod : maPeriod // ignore: cast_nullable_to_non_nullable
as MaPeriod,window: null == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as DistributionWindow,rareLevels: null == rareLevels ? _self._rareLevels : rareLevels // ignore: cast_nullable_to_non_nullable
as List<double>,alertCommodity: freezed == alertCommodity ? _self.alertCommodity : alertCommodity // ignore: cast_nullable_to_non_nullable
as CommodityCode?,quietTime: freezed == quietTime ? _self.quietTime : quietTime // ignore: cast_nullable_to_non_nullable
as QuietTime?,
  ));
}

/// Create a copy of DeviceSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuietTimeCopyWith<$Res>? get quietTime {
    if (_self.quietTime == null) {
    return null;
  }

  return $QuietTimeCopyWith<$Res>(_self.quietTime!, (value) {
    return _then(_self.copyWith(quietTime: value));
  });
}
}


/// @nodoc
mixin _$QuietTime {

 int get startMin; int get endMin;
/// Create a copy of QuietTime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuietTimeCopyWith<QuietTime> get copyWith => _$QuietTimeCopyWithImpl<QuietTime>(this as QuietTime, _$identity);

  /// Serializes this QuietTime to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as QuietTime;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuietTime&&(identical(other.startMin, _this.startMin) || other.startMin == _this.startMin)&&(identical(other.endMin, _this.endMin) || other.endMin == _this.endMin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as QuietTime;
  return Object.hash(runtimeType,_this.startMin,_this.endMin);
}

@override
String toString() {
  final _this = this as QuietTime;
  return 'QuietTime(startMin: ${_this.startMin}, endMin: ${_this.endMin})';
}


}

/// @nodoc
abstract mixin class $QuietTimeCopyWith<$Res>  {
  factory $QuietTimeCopyWith(QuietTime value, $Res Function(QuietTime) _then) = _$QuietTimeCopyWithImpl;
@useResult
$Res call({
 int startMin, int endMin
});




}
/// @nodoc
class _$QuietTimeCopyWithImpl<$Res>
    implements $QuietTimeCopyWith<$Res> {
  _$QuietTimeCopyWithImpl(this._self, this._then);

  final QuietTime _self;
  final $Res Function(QuietTime) _then;

/// Create a copy of QuietTime
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startMin = null,Object? endMin = null,}) {
  return _then(QuietTime(
startMin: null == startMin ? _self.startMin : startMin // ignore: cast_nullable_to_non_nullable
as int,endMin: null == endMin ? _self.endMin : endMin // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuietTime].
extension QuietTimePatterns on QuietTime {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuietTime value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuietTime() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuietTime value)  $default,){
final _that = this;
switch (_that) {
case _QuietTime():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuietTime value)?  $default,){
final _that = this;
switch (_that) {
case _QuietTime() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int startMin,  int endMin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuietTime() when $default != null:
return $default(_that.startMin,_that.endMin);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int startMin,  int endMin)  $default,) {final _that = this;
switch (_that) {
case _QuietTime():
return $default(_that.startMin,_that.endMin);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int startMin,  int endMin)?  $default,) {final _that = this;
switch (_that) {
case _QuietTime() when $default != null:
return $default(_that.startMin,_that.endMin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuietTime implements QuietTime {
  const _QuietTime({required this.startMin, required this.endMin});
  factory _QuietTime.fromJson(Map<String, dynamic> json) => _$QuietTimeFromJson(json);

@override final  int startMin;
@override final  int endMin;

/// Create a copy of QuietTime
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuietTimeCopyWith<_QuietTime> get copyWith => __$QuietTimeCopyWithImpl<_QuietTime>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuietTimeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuietTime&&(identical(other.startMin, startMin) || other.startMin == startMin)&&(identical(other.endMin, endMin) || other.endMin == endMin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,startMin,endMin);
}

@override
String toString() {
    return 'QuietTime(startMin: $startMin, endMin: $endMin)';
}


}

/// @nodoc
abstract mixin class _$QuietTimeCopyWith<$Res> implements $QuietTimeCopyWith<$Res> {
  factory _$QuietTimeCopyWith(_QuietTime value, $Res Function(_QuietTime) _then) = __$QuietTimeCopyWithImpl;
@override @useResult
$Res call({
 int startMin, int endMin
});




}
/// @nodoc
class __$QuietTimeCopyWithImpl<$Res>
    implements _$QuietTimeCopyWith<$Res> {
  __$QuietTimeCopyWithImpl(this._self, this._then);

  final _QuietTime _self;
  final $Res Function(_QuietTime) _then;

/// Create a copy of QuietTime
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startMin = null,Object? endMin = null,}) {
  return _then(_QuietTime(
startMin: null == startMin ? _self.startMin : startMin // ignore: cast_nullable_to_non_nullable
as int,endMin: null == endMin ? _self.endMin : endMin // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
