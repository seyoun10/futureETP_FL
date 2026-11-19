// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'curve.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Curve {

 Freshness get freshness; int get priceDecimals;/// 서버가 거래일로 맞춘 기준일.
 String get baseDate; int get baseOffset; String? get prevBaseDate; String? get nextBaseDate; String get minBaseDate; String get maxBaseDate;/// 기준일 다음 거래일(D-114).
 String get compareDate; List<CurvePoint> get points; CurveSpread? get current; CurveSpread? get base;
/// Create a copy of Curve
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurveCopyWith<Curve> get copyWith => _$CurveCopyWithImpl<Curve>(this as Curve, _$identity);

  /// Serializes this Curve to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Curve;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Curve&&(identical(other.freshness, _this.freshness) || other.freshness == _this.freshness)&&(identical(other.priceDecimals, _this.priceDecimals) || other.priceDecimals == _this.priceDecimals)&&(identical(other.baseDate, _this.baseDate) || other.baseDate == _this.baseDate)&&(identical(other.baseOffset, _this.baseOffset) || other.baseOffset == _this.baseOffset)&&(identical(other.prevBaseDate, _this.prevBaseDate) || other.prevBaseDate == _this.prevBaseDate)&&(identical(other.nextBaseDate, _this.nextBaseDate) || other.nextBaseDate == _this.nextBaseDate)&&(identical(other.minBaseDate, _this.minBaseDate) || other.minBaseDate == _this.minBaseDate)&&(identical(other.maxBaseDate, _this.maxBaseDate) || other.maxBaseDate == _this.maxBaseDate)&&(identical(other.compareDate, _this.compareDate) || other.compareDate == _this.compareDate)&&const DeepCollectionEquality().equals(other.points, _this.points)&&(identical(other.current, _this.current) || other.current == _this.current)&&(identical(other.base, _this.base) || other.base == _this.base));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Curve;
  return Object.hash(runtimeType,_this.freshness,_this.priceDecimals,_this.baseDate,_this.baseOffset,_this.prevBaseDate,_this.nextBaseDate,_this.minBaseDate,_this.maxBaseDate,_this.compareDate,const DeepCollectionEquality().hash(_this.points),_this.current,_this.base);
}

@override
String toString() {
  final _this = this as Curve;
  return 'Curve(freshness: ${_this.freshness}, priceDecimals: ${_this.priceDecimals}, baseDate: ${_this.baseDate}, baseOffset: ${_this.baseOffset}, prevBaseDate: ${_this.prevBaseDate}, nextBaseDate: ${_this.nextBaseDate}, minBaseDate: ${_this.minBaseDate}, maxBaseDate: ${_this.maxBaseDate}, compareDate: ${_this.compareDate}, points: ${_this.points}, current: ${_this.current}, base: ${_this.base})';
}


}

/// @nodoc
abstract mixin class $CurveCopyWith<$Res>  {
  factory $CurveCopyWith(Curve value, $Res Function(Curve) _then) = _$CurveCopyWithImpl;
@useResult
$Res call({
 Freshness freshness, int priceDecimals, String baseDate, int baseOffset, String? prevBaseDate, String? nextBaseDate, String minBaseDate, String maxBaseDate, String compareDate, List<CurvePoint> points, CurveSpread? current, CurveSpread? base
});


$FreshnessCopyWith<$Res> get freshness;$CurveSpreadCopyWith<$Res>? get current;$CurveSpreadCopyWith<$Res>? get base;

}
/// @nodoc
class _$CurveCopyWithImpl<$Res>
    implements $CurveCopyWith<$Res> {
  _$CurveCopyWithImpl(this._self, this._then);

  final Curve _self;
  final $Res Function(Curve) _then;

/// Create a copy of Curve
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? freshness = null,Object? priceDecimals = null,Object? baseDate = null,Object? baseOffset = null,Object? prevBaseDate = freezed,Object? nextBaseDate = freezed,Object? minBaseDate = null,Object? maxBaseDate = null,Object? compareDate = null,Object? points = null,Object? current = freezed,Object? base = freezed,}) {
  return _then(Curve(
freshness: null == freshness ? _self.freshness : freshness // ignore: cast_nullable_to_non_nullable
as Freshness,priceDecimals: null == priceDecimals ? _self.priceDecimals : priceDecimals // ignore: cast_nullable_to_non_nullable
as int,baseDate: null == baseDate ? _self.baseDate : baseDate // ignore: cast_nullable_to_non_nullable
as String,baseOffset: null == baseOffset ? _self.baseOffset : baseOffset // ignore: cast_nullable_to_non_nullable
as int,prevBaseDate: freezed == prevBaseDate ? _self.prevBaseDate : prevBaseDate // ignore: cast_nullable_to_non_nullable
as String?,nextBaseDate: freezed == nextBaseDate ? _self.nextBaseDate : nextBaseDate // ignore: cast_nullable_to_non_nullable
as String?,minBaseDate: null == minBaseDate ? _self.minBaseDate : minBaseDate // ignore: cast_nullable_to_non_nullable
as String,maxBaseDate: null == maxBaseDate ? _self.maxBaseDate : maxBaseDate // ignore: cast_nullable_to_non_nullable
as String,compareDate: null == compareDate ? _self.compareDate : compareDate // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<CurvePoint>,current: freezed == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as CurveSpread?,base: freezed == base ? _self.base : base // ignore: cast_nullable_to_non_nullable
as CurveSpread?,
  ));
}
/// Create a copy of Curve
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FreshnessCopyWith<$Res> get freshness {
  
  return $FreshnessCopyWith<$Res>(_self.freshness, (value) {
    return _then(_self.copyWith(freshness: value));
  });
}/// Create a copy of Curve
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurveSpreadCopyWith<$Res>? get current {
    if (_self.current == null) {
    return null;
  }

  return $CurveSpreadCopyWith<$Res>(_self.current!, (value) {
    return _then(_self.copyWith(current: value));
  });
}/// Create a copy of Curve
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurveSpreadCopyWith<$Res>? get base {
    if (_self.base == null) {
    return null;
  }

  return $CurveSpreadCopyWith<$Res>(_self.base!, (value) {
    return _then(_self.copyWith(base: value));
  });
}
}


/// Adds pattern-matching-related methods to [Curve].
extension CurvePatterns on Curve {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Curve value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Curve() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Curve value)  $default,){
final _that = this;
switch (_that) {
case _Curve():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Curve value)?  $default,){
final _that = this;
switch (_that) {
case _Curve() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Freshness freshness,  int priceDecimals,  String baseDate,  int baseOffset,  String? prevBaseDate,  String? nextBaseDate,  String minBaseDate,  String maxBaseDate,  String compareDate,  List<CurvePoint> points,  CurveSpread? current,  CurveSpread? base)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Curve() when $default != null:
return $default(_that.freshness,_that.priceDecimals,_that.baseDate,_that.baseOffset,_that.prevBaseDate,_that.nextBaseDate,_that.minBaseDate,_that.maxBaseDate,_that.compareDate,_that.points,_that.current,_that.base);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Freshness freshness,  int priceDecimals,  String baseDate,  int baseOffset,  String? prevBaseDate,  String? nextBaseDate,  String minBaseDate,  String maxBaseDate,  String compareDate,  List<CurvePoint> points,  CurveSpread? current,  CurveSpread? base)  $default,) {final _that = this;
switch (_that) {
case _Curve():
return $default(_that.freshness,_that.priceDecimals,_that.baseDate,_that.baseOffset,_that.prevBaseDate,_that.nextBaseDate,_that.minBaseDate,_that.maxBaseDate,_that.compareDate,_that.points,_that.current,_that.base);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Freshness freshness,  int priceDecimals,  String baseDate,  int baseOffset,  String? prevBaseDate,  String? nextBaseDate,  String minBaseDate,  String maxBaseDate,  String compareDate,  List<CurvePoint> points,  CurveSpread? current,  CurveSpread? base)?  $default,) {final _that = this;
switch (_that) {
case _Curve() when $default != null:
return $default(_that.freshness,_that.priceDecimals,_that.baseDate,_that.baseOffset,_that.prevBaseDate,_that.nextBaseDate,_that.minBaseDate,_that.maxBaseDate,_that.compareDate,_that.points,_that.current,_that.base);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Curve implements Curve {
  const _Curve({required this.freshness, required this.priceDecimals, required this.baseDate, required this.baseOffset, required this.prevBaseDate, required this.nextBaseDate, required this.minBaseDate, required this.maxBaseDate, required this.compareDate, required  List<CurvePoint> points, required this.current, required this.base}): _points = points;
  factory _Curve.fromJson(Map<String, dynamic> json) => _$CurveFromJson(json);

@override final  Freshness freshness;
@override final  int priceDecimals;
/// 서버가 거래일로 맞춘 기준일.
@override final  String baseDate;
@override final  int baseOffset;
@override final  String? prevBaseDate;
@override final  String? nextBaseDate;
@override final  String minBaseDate;
@override final  String maxBaseDate;
/// 기준일 다음 거래일(D-114).
@override final  String compareDate;
 final  List<CurvePoint> _points;
@override List<CurvePoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}

@override final  CurveSpread? current;
@override final  CurveSpread? base;

/// Create a copy of Curve
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurveCopyWith<_Curve> get copyWith => __$CurveCopyWithImpl<_Curve>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CurveToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Curve&&(identical(other.freshness, freshness) || other.freshness == freshness)&&(identical(other.priceDecimals, priceDecimals) || other.priceDecimals == priceDecimals)&&(identical(other.baseDate, baseDate) || other.baseDate == baseDate)&&(identical(other.baseOffset, baseOffset) || other.baseOffset == baseOffset)&&(identical(other.prevBaseDate, prevBaseDate) || other.prevBaseDate == prevBaseDate)&&(identical(other.nextBaseDate, nextBaseDate) || other.nextBaseDate == nextBaseDate)&&(identical(other.minBaseDate, minBaseDate) || other.minBaseDate == minBaseDate)&&(identical(other.maxBaseDate, maxBaseDate) || other.maxBaseDate == maxBaseDate)&&(identical(other.compareDate, compareDate) || other.compareDate == compareDate)&&const DeepCollectionEquality().equals(other.points, _points)&&(identical(other.current, current) || other.current == current)&&(identical(other.base, base) || other.base == base));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,freshness,priceDecimals,baseDate,baseOffset,prevBaseDate,nextBaseDate,minBaseDate,maxBaseDate,compareDate,const DeepCollectionEquality().hash(_points),current,base);
}

@override
String toString() {
    return 'Curve(freshness: $freshness, priceDecimals: $priceDecimals, baseDate: $baseDate, baseOffset: $baseOffset, prevBaseDate: $prevBaseDate, nextBaseDate: $nextBaseDate, minBaseDate: $minBaseDate, maxBaseDate: $maxBaseDate, compareDate: $compareDate, points: $points, current: $current, base: $base)';
}


}

/// @nodoc
abstract mixin class _$CurveCopyWith<$Res> implements $CurveCopyWith<$Res> {
  factory _$CurveCopyWith(_Curve value, $Res Function(_Curve) _then) = __$CurveCopyWithImpl;
@override @useResult
$Res call({
 Freshness freshness, int priceDecimals, String baseDate, int baseOffset, String? prevBaseDate, String? nextBaseDate, String minBaseDate, String maxBaseDate, String compareDate, List<CurvePoint> points, CurveSpread? current, CurveSpread? base
});


@override $FreshnessCopyWith<$Res> get freshness;@override $CurveSpreadCopyWith<$Res>? get current;@override $CurveSpreadCopyWith<$Res>? get base;

}
/// @nodoc
class __$CurveCopyWithImpl<$Res>
    implements _$CurveCopyWith<$Res> {
  __$CurveCopyWithImpl(this._self, this._then);

  final _Curve _self;
  final $Res Function(_Curve) _then;

/// Create a copy of Curve
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? freshness = null,Object? priceDecimals = null,Object? baseDate = null,Object? baseOffset = null,Object? prevBaseDate = freezed,Object? nextBaseDate = freezed,Object? minBaseDate = null,Object? maxBaseDate = null,Object? compareDate = null,Object? points = null,Object? current = freezed,Object? base = freezed,}) {
  return _then(_Curve(
freshness: null == freshness ? _self.freshness : freshness // ignore: cast_nullable_to_non_nullable
as Freshness,priceDecimals: null == priceDecimals ? _self.priceDecimals : priceDecimals // ignore: cast_nullable_to_non_nullable
as int,baseDate: null == baseDate ? _self.baseDate : baseDate // ignore: cast_nullable_to_non_nullable
as String,baseOffset: null == baseOffset ? _self.baseOffset : baseOffset // ignore: cast_nullable_to_non_nullable
as int,prevBaseDate: freezed == prevBaseDate ? _self.prevBaseDate : prevBaseDate // ignore: cast_nullable_to_non_nullable
as String?,nextBaseDate: freezed == nextBaseDate ? _self.nextBaseDate : nextBaseDate // ignore: cast_nullable_to_non_nullable
as String?,minBaseDate: null == minBaseDate ? _self.minBaseDate : minBaseDate // ignore: cast_nullable_to_non_nullable
as String,maxBaseDate: null == maxBaseDate ? _self.maxBaseDate : maxBaseDate // ignore: cast_nullable_to_non_nullable
as String,compareDate: null == compareDate ? _self.compareDate : compareDate // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<CurvePoint>,current: freezed == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as CurveSpread?,base: freezed == base ? _self.base : base // ignore: cast_nullable_to_non_nullable
as CurveSpread?,
  ));
}

/// Create a copy of Curve
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FreshnessCopyWith<$Res> get freshness {
  
  return $FreshnessCopyWith<$Res>(_self.freshness, (value) {
    return _then(_self.copyWith(freshness: value));
  });
}/// Create a copy of Curve
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurveSpreadCopyWith<$Res>? get current {
    if (_self.current == null) {
    return null;
  }

  return $CurveSpreadCopyWith<$Res>(_self.current!, (value) {
    return _then(_self.copyWith(current: value));
  });
}/// Create a copy of Curve
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurveSpreadCopyWith<$Res>? get base {
    if (_self.base == null) {
    return null;
  }

  return $CurveSpreadCopyWith<$Res>(_self.base!, (value) {
    return _then(_self.copyWith(base: value));
  });
}
}


/// @nodoc
mixin _$CurvePoint {

 String get symbol; String get contractMonth; double? get basePrice; double? get currentPrice; double? get changePct;
/// Create a copy of CurvePoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurvePointCopyWith<CurvePoint> get copyWith => _$CurvePointCopyWithImpl<CurvePoint>(this as CurvePoint, _$identity);

  /// Serializes this CurvePoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CurvePoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurvePoint&&(identical(other.symbol, _this.symbol) || other.symbol == _this.symbol)&&(identical(other.contractMonth, _this.contractMonth) || other.contractMonth == _this.contractMonth)&&(identical(other.basePrice, _this.basePrice) || other.basePrice == _this.basePrice)&&(identical(other.currentPrice, _this.currentPrice) || other.currentPrice == _this.currentPrice)&&(identical(other.changePct, _this.changePct) || other.changePct == _this.changePct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CurvePoint;
  return Object.hash(runtimeType,_this.symbol,_this.contractMonth,_this.basePrice,_this.currentPrice,_this.changePct);
}

@override
String toString() {
  final _this = this as CurvePoint;
  return 'CurvePoint(symbol: ${_this.symbol}, contractMonth: ${_this.contractMonth}, basePrice: ${_this.basePrice}, currentPrice: ${_this.currentPrice}, changePct: ${_this.changePct})';
}


}

/// @nodoc
abstract mixin class $CurvePointCopyWith<$Res>  {
  factory $CurvePointCopyWith(CurvePoint value, $Res Function(CurvePoint) _then) = _$CurvePointCopyWithImpl;
@useResult
$Res call({
 String symbol, String contractMonth, double? basePrice, double? currentPrice, double? changePct
});




}
/// @nodoc
class _$CurvePointCopyWithImpl<$Res>
    implements $CurvePointCopyWith<$Res> {
  _$CurvePointCopyWithImpl(this._self, this._then);

  final CurvePoint _self;
  final $Res Function(CurvePoint) _then;

/// Create a copy of CurvePoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? symbol = null,Object? contractMonth = null,Object? basePrice = freezed,Object? currentPrice = freezed,Object? changePct = freezed,}) {
  return _then(CurvePoint(
symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,contractMonth: null == contractMonth ? _self.contractMonth : contractMonth // ignore: cast_nullable_to_non_nullable
as String,basePrice: freezed == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as double?,currentPrice: freezed == currentPrice ? _self.currentPrice : currentPrice // ignore: cast_nullable_to_non_nullable
as double?,changePct: freezed == changePct ? _self.changePct : changePct // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [CurvePoint].
extension CurvePointPatterns on CurvePoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurvePoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurvePoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurvePoint value)  $default,){
final _that = this;
switch (_that) {
case _CurvePoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurvePoint value)?  $default,){
final _that = this;
switch (_that) {
case _CurvePoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String symbol,  String contractMonth,  double? basePrice,  double? currentPrice,  double? changePct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurvePoint() when $default != null:
return $default(_that.symbol,_that.contractMonth,_that.basePrice,_that.currentPrice,_that.changePct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String symbol,  String contractMonth,  double? basePrice,  double? currentPrice,  double? changePct)  $default,) {final _that = this;
switch (_that) {
case _CurvePoint():
return $default(_that.symbol,_that.contractMonth,_that.basePrice,_that.currentPrice,_that.changePct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String symbol,  String contractMonth,  double? basePrice,  double? currentPrice,  double? changePct)?  $default,) {final _that = this;
switch (_that) {
case _CurvePoint() when $default != null:
return $default(_that.symbol,_that.contractMonth,_that.basePrice,_that.currentPrice,_that.changePct);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurvePoint implements CurvePoint {
  const _CurvePoint({required this.symbol, required this.contractMonth, required this.basePrice, required this.currentPrice, required this.changePct});
  factory _CurvePoint.fromJson(Map<String, dynamic> json) => _$CurvePointFromJson(json);

@override final  String symbol;
@override final  String contractMonth;
@override final  double? basePrice;
@override final  double? currentPrice;
@override final  double? changePct;

/// Create a copy of CurvePoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurvePointCopyWith<_CurvePoint> get copyWith => __$CurvePointCopyWithImpl<_CurvePoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CurvePointToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurvePoint&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.contractMonth, contractMonth) || other.contractMonth == contractMonth)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.currentPrice, currentPrice) || other.currentPrice == currentPrice)&&(identical(other.changePct, changePct) || other.changePct == changePct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,symbol,contractMonth,basePrice,currentPrice,changePct);
}

@override
String toString() {
    return 'CurvePoint(symbol: $symbol, contractMonth: $contractMonth, basePrice: $basePrice, currentPrice: $currentPrice, changePct: $changePct)';
}


}

/// @nodoc
abstract mixin class _$CurvePointCopyWith<$Res> implements $CurvePointCopyWith<$Res> {
  factory _$CurvePointCopyWith(_CurvePoint value, $Res Function(_CurvePoint) _then) = __$CurvePointCopyWithImpl;
@override @useResult
$Res call({
 String symbol, String contractMonth, double? basePrice, double? currentPrice, double? changePct
});




}
/// @nodoc
class __$CurvePointCopyWithImpl<$Res>
    implements _$CurvePointCopyWith<$Res> {
  __$CurvePointCopyWithImpl(this._self, this._then);

  final _CurvePoint _self;
  final $Res Function(_CurvePoint) _then;

/// Create a copy of CurvePoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? symbol = null,Object? contractMonth = null,Object? basePrice = freezed,Object? currentPrice = freezed,Object? changePct = freezed,}) {
  return _then(_CurvePoint(
symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,contractMonth: null == contractMonth ? _self.contractMonth : contractMonth // ignore: cast_nullable_to_non_nullable
as String,basePrice: freezed == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as double?,currentPrice: freezed == currentPrice ? _self.currentPrice : currentPrice // ignore: cast_nullable_to_non_nullable
as double?,changePct: freezed == changePct ? _self.changePct : changePct // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$CurveSpread {

 String get m1ContractMonth; String get m2ContractMonth; CurveState get state; double get spreadPct; double get rollYieldPct;
/// Create a copy of CurveSpread
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurveSpreadCopyWith<CurveSpread> get copyWith => _$CurveSpreadCopyWithImpl<CurveSpread>(this as CurveSpread, _$identity);

  /// Serializes this CurveSpread to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CurveSpread;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurveSpread&&(identical(other.m1ContractMonth, _this.m1ContractMonth) || other.m1ContractMonth == _this.m1ContractMonth)&&(identical(other.m2ContractMonth, _this.m2ContractMonth) || other.m2ContractMonth == _this.m2ContractMonth)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.spreadPct, _this.spreadPct) || other.spreadPct == _this.spreadPct)&&(identical(other.rollYieldPct, _this.rollYieldPct) || other.rollYieldPct == _this.rollYieldPct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CurveSpread;
  return Object.hash(runtimeType,_this.m1ContractMonth,_this.m2ContractMonth,_this.state,_this.spreadPct,_this.rollYieldPct);
}

@override
String toString() {
  final _this = this as CurveSpread;
  return 'CurveSpread(m1ContractMonth: ${_this.m1ContractMonth}, m2ContractMonth: ${_this.m2ContractMonth}, state: ${_this.state}, spreadPct: ${_this.spreadPct}, rollYieldPct: ${_this.rollYieldPct})';
}


}

/// @nodoc
abstract mixin class $CurveSpreadCopyWith<$Res>  {
  factory $CurveSpreadCopyWith(CurveSpread value, $Res Function(CurveSpread) _then) = _$CurveSpreadCopyWithImpl;
@useResult
$Res call({
 String m1ContractMonth, String m2ContractMonth, CurveState state, double spreadPct, double rollYieldPct
});




}
/// @nodoc
class _$CurveSpreadCopyWithImpl<$Res>
    implements $CurveSpreadCopyWith<$Res> {
  _$CurveSpreadCopyWithImpl(this._self, this._then);

  final CurveSpread _self;
  final $Res Function(CurveSpread) _then;

/// Create a copy of CurveSpread
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? m1ContractMonth = null,Object? m2ContractMonth = null,Object? state = null,Object? spreadPct = null,Object? rollYieldPct = null,}) {
  return _then(CurveSpread(
m1ContractMonth: null == m1ContractMonth ? _self.m1ContractMonth : m1ContractMonth // ignore: cast_nullable_to_non_nullable
as String,m2ContractMonth: null == m2ContractMonth ? _self.m2ContractMonth : m2ContractMonth // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as CurveState,spreadPct: null == spreadPct ? _self.spreadPct : spreadPct // ignore: cast_nullable_to_non_nullable
as double,rollYieldPct: null == rollYieldPct ? _self.rollYieldPct : rollYieldPct // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CurveSpread].
extension CurveSpreadPatterns on CurveSpread {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurveSpread value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurveSpread() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurveSpread value)  $default,){
final _that = this;
switch (_that) {
case _CurveSpread():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurveSpread value)?  $default,){
final _that = this;
switch (_that) {
case _CurveSpread() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String m1ContractMonth,  String m2ContractMonth,  CurveState state,  double spreadPct,  double rollYieldPct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurveSpread() when $default != null:
return $default(_that.m1ContractMonth,_that.m2ContractMonth,_that.state,_that.spreadPct,_that.rollYieldPct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String m1ContractMonth,  String m2ContractMonth,  CurveState state,  double spreadPct,  double rollYieldPct)  $default,) {final _that = this;
switch (_that) {
case _CurveSpread():
return $default(_that.m1ContractMonth,_that.m2ContractMonth,_that.state,_that.spreadPct,_that.rollYieldPct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String m1ContractMonth,  String m2ContractMonth,  CurveState state,  double spreadPct,  double rollYieldPct)?  $default,) {final _that = this;
switch (_that) {
case _CurveSpread() when $default != null:
return $default(_that.m1ContractMonth,_that.m2ContractMonth,_that.state,_that.spreadPct,_that.rollYieldPct);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurveSpread implements CurveSpread {
  const _CurveSpread({required this.m1ContractMonth, required this.m2ContractMonth, required this.state, required this.spreadPct, required this.rollYieldPct});
  factory _CurveSpread.fromJson(Map<String, dynamic> json) => _$CurveSpreadFromJson(json);

@override final  String m1ContractMonth;
@override final  String m2ContractMonth;
@override final  CurveState state;
@override final  double spreadPct;
@override final  double rollYieldPct;

/// Create a copy of CurveSpread
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurveSpreadCopyWith<_CurveSpread> get copyWith => __$CurveSpreadCopyWithImpl<_CurveSpread>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CurveSpreadToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurveSpread&&(identical(other.m1ContractMonth, m1ContractMonth) || other.m1ContractMonth == m1ContractMonth)&&(identical(other.m2ContractMonth, m2ContractMonth) || other.m2ContractMonth == m2ContractMonth)&&(identical(other.state, state) || other.state == state)&&(identical(other.spreadPct, spreadPct) || other.spreadPct == spreadPct)&&(identical(other.rollYieldPct, rollYieldPct) || other.rollYieldPct == rollYieldPct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,m1ContractMonth,m2ContractMonth,state,spreadPct,rollYieldPct);
}

@override
String toString() {
    return 'CurveSpread(m1ContractMonth: $m1ContractMonth, m2ContractMonth: $m2ContractMonth, state: $state, spreadPct: $spreadPct, rollYieldPct: $rollYieldPct)';
}


}

/// @nodoc
abstract mixin class _$CurveSpreadCopyWith<$Res> implements $CurveSpreadCopyWith<$Res> {
  factory _$CurveSpreadCopyWith(_CurveSpread value, $Res Function(_CurveSpread) _then) = __$CurveSpreadCopyWithImpl;
@override @useResult
$Res call({
 String m1ContractMonth, String m2ContractMonth, CurveState state, double spreadPct, double rollYieldPct
});




}
/// @nodoc
class __$CurveSpreadCopyWithImpl<$Res>
    implements _$CurveSpreadCopyWith<$Res> {
  __$CurveSpreadCopyWithImpl(this._self, this._then);

  final _CurveSpread _self;
  final $Res Function(_CurveSpread) _then;

/// Create a copy of CurveSpread
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? m1ContractMonth = null,Object? m2ContractMonth = null,Object? state = null,Object? spreadPct = null,Object? rollYieldPct = null,}) {
  return _then(_CurveSpread(
m1ContractMonth: null == m1ContractMonth ? _self.m1ContractMonth : m1ContractMonth // ignore: cast_nullable_to_non_nullable
as String,m2ContractMonth: null == m2ContractMonth ? _self.m2ContractMonth : m2ContractMonth // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as CurveState,spreadPct: null == spreadPct ? _self.spreadPct : spreadPct // ignore: cast_nullable_to_non_nullable
as double,rollYieldPct: null == rollYieldPct ? _self.rollYieldPct : rollYieldPct // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
