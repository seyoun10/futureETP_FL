// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'freshness.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Freshness {

 DateTime get asOf; String get tradeDate; bool get delayed; MarketState get marketState;/// 다음 데이터 갱신 예상 시각. null이면 자동 새로고침하지 않는다.
 DateTime? get nextUpdateAt;
/// Create a copy of Freshness
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FreshnessCopyWith<Freshness> get copyWith => _$FreshnessCopyWithImpl<Freshness>(this as Freshness, _$identity);

  /// Serializes this Freshness to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Freshness;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Freshness&&(identical(other.asOf, _this.asOf) || other.asOf == _this.asOf)&&(identical(other.tradeDate, _this.tradeDate) || other.tradeDate == _this.tradeDate)&&(identical(other.delayed, _this.delayed) || other.delayed == _this.delayed)&&(identical(other.marketState, _this.marketState) || other.marketState == _this.marketState)&&(identical(other.nextUpdateAt, _this.nextUpdateAt) || other.nextUpdateAt == _this.nextUpdateAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Freshness;
  return Object.hash(runtimeType,_this.asOf,_this.tradeDate,_this.delayed,_this.marketState,_this.nextUpdateAt);
}

@override
String toString() {
  final _this = this as Freshness;
  return 'Freshness(asOf: ${_this.asOf}, tradeDate: ${_this.tradeDate}, delayed: ${_this.delayed}, marketState: ${_this.marketState}, nextUpdateAt: ${_this.nextUpdateAt})';
}


}

/// @nodoc
abstract mixin class $FreshnessCopyWith<$Res>  {
  factory $FreshnessCopyWith(Freshness value, $Res Function(Freshness) _then) = _$FreshnessCopyWithImpl;
@useResult
$Res call({
 DateTime asOf, String tradeDate, bool delayed, MarketState marketState, DateTime? nextUpdateAt
});




}
/// @nodoc
class _$FreshnessCopyWithImpl<$Res>
    implements $FreshnessCopyWith<$Res> {
  _$FreshnessCopyWithImpl(this._self, this._then);

  final Freshness _self;
  final $Res Function(Freshness) _then;

/// Create a copy of Freshness
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? asOf = null,Object? tradeDate = null,Object? delayed = null,Object? marketState = null,Object? nextUpdateAt = freezed,}) {
  return _then(Freshness(
asOf: null == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as DateTime,tradeDate: null == tradeDate ? _self.tradeDate : tradeDate // ignore: cast_nullable_to_non_nullable
as String,delayed: null == delayed ? _self.delayed : delayed // ignore: cast_nullable_to_non_nullable
as bool,marketState: null == marketState ? _self.marketState : marketState // ignore: cast_nullable_to_non_nullable
as MarketState,nextUpdateAt: freezed == nextUpdateAt ? _self.nextUpdateAt : nextUpdateAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Freshness].
extension FreshnessPatterns on Freshness {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Freshness value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Freshness() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Freshness value)  $default,){
final _that = this;
switch (_that) {
case _Freshness():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Freshness value)?  $default,){
final _that = this;
switch (_that) {
case _Freshness() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime asOf,  String tradeDate,  bool delayed,  MarketState marketState,  DateTime? nextUpdateAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Freshness() when $default != null:
return $default(_that.asOf,_that.tradeDate,_that.delayed,_that.marketState,_that.nextUpdateAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime asOf,  String tradeDate,  bool delayed,  MarketState marketState,  DateTime? nextUpdateAt)  $default,) {final _that = this;
switch (_that) {
case _Freshness():
return $default(_that.asOf,_that.tradeDate,_that.delayed,_that.marketState,_that.nextUpdateAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime asOf,  String tradeDate,  bool delayed,  MarketState marketState,  DateTime? nextUpdateAt)?  $default,) {final _that = this;
switch (_that) {
case _Freshness() when $default != null:
return $default(_that.asOf,_that.tradeDate,_that.delayed,_that.marketState,_that.nextUpdateAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Freshness implements Freshness {
  const _Freshness({required this.asOf, required this.tradeDate, required this.delayed, required this.marketState, required this.nextUpdateAt});
  factory _Freshness.fromJson(Map<String, dynamic> json) => _$FreshnessFromJson(json);

@override final  DateTime asOf;
@override final  String tradeDate;
@override final  bool delayed;
@override final  MarketState marketState;
/// 다음 데이터 갱신 예상 시각. null이면 자동 새로고침하지 않는다.
@override final  DateTime? nextUpdateAt;

/// Create a copy of Freshness
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FreshnessCopyWith<_Freshness> get copyWith => __$FreshnessCopyWithImpl<_Freshness>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FreshnessToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Freshness&&(identical(other.asOf, asOf) || other.asOf == asOf)&&(identical(other.tradeDate, tradeDate) || other.tradeDate == tradeDate)&&(identical(other.delayed, delayed) || other.delayed == delayed)&&(identical(other.marketState, marketState) || other.marketState == marketState)&&(identical(other.nextUpdateAt, nextUpdateAt) || other.nextUpdateAt == nextUpdateAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,asOf,tradeDate,delayed,marketState,nextUpdateAt);
}

@override
String toString() {
    return 'Freshness(asOf: $asOf, tradeDate: $tradeDate, delayed: $delayed, marketState: $marketState, nextUpdateAt: $nextUpdateAt)';
}


}

/// @nodoc
abstract mixin class _$FreshnessCopyWith<$Res> implements $FreshnessCopyWith<$Res> {
  factory _$FreshnessCopyWith(_Freshness value, $Res Function(_Freshness) _then) = __$FreshnessCopyWithImpl;
@override @useResult
$Res call({
 DateTime asOf, String tradeDate, bool delayed, MarketState marketState, DateTime? nextUpdateAt
});




}
/// @nodoc
class __$FreshnessCopyWithImpl<$Res>
    implements _$FreshnessCopyWith<$Res> {
  __$FreshnessCopyWithImpl(this._self, this._then);

  final _Freshness _self;
  final $Res Function(_Freshness) _then;

/// Create a copy of Freshness
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? asOf = null,Object? tradeDate = null,Object? delayed = null,Object? marketState = null,Object? nextUpdateAt = freezed,}) {
  return _then(_Freshness(
asOf: null == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as DateTime,tradeDate: null == tradeDate ? _self.tradeDate : tradeDate // ignore: cast_nullable_to_non_nullable
as String,delayed: null == delayed ? _self.delayed : delayed // ignore: cast_nullable_to_non_nullable
as bool,marketState: null == marketState ? _self.marketState : marketState // ignore: cast_nullable_to_non_nullable
as MarketState,nextUpdateAt: freezed == nextUpdateAt ? _self.nextUpdateAt : nextUpdateAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
