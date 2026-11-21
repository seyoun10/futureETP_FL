// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarketCalendar {

 String get from; String get to; List<CalendarException> get exceptions;/// 범위에 걸친 연도 중 휴장 일정이 입력되지 않은 (시장, 연도).
 List<CalendarMissing> get missing;
/// Create a copy of MarketCalendar
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketCalendarCopyWith<MarketCalendar> get copyWith => _$MarketCalendarCopyWithImpl<MarketCalendar>(this as MarketCalendar, _$identity);

  /// Serializes this MarketCalendar to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MarketCalendar;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketCalendar&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to)&&const DeepCollectionEquality().equals(other.exceptions, _this.exceptions)&&const DeepCollectionEquality().equals(other.missing, _this.missing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MarketCalendar;
  return Object.hash(runtimeType,_this.from,_this.to,const DeepCollectionEquality().hash(_this.exceptions),const DeepCollectionEquality().hash(_this.missing));
}

@override
String toString() {
  final _this = this as MarketCalendar;
  return 'MarketCalendar(from: ${_this.from}, to: ${_this.to}, exceptions: ${_this.exceptions}, missing: ${_this.missing})';
}


}

/// @nodoc
abstract mixin class $MarketCalendarCopyWith<$Res>  {
  factory $MarketCalendarCopyWith(MarketCalendar value, $Res Function(MarketCalendar) _then) = _$MarketCalendarCopyWithImpl;
@useResult
$Res call({
 String from, String to, List<CalendarException> exceptions, List<CalendarMissing> missing
});




}
/// @nodoc
class _$MarketCalendarCopyWithImpl<$Res>
    implements $MarketCalendarCopyWith<$Res> {
  _$MarketCalendarCopyWithImpl(this._self, this._then);

  final MarketCalendar _self;
  final $Res Function(MarketCalendar) _then;

/// Create a copy of MarketCalendar
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,Object? exceptions = null,Object? missing = null,}) {
  return _then(MarketCalendar(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,exceptions: null == exceptions ? _self.exceptions : exceptions // ignore: cast_nullable_to_non_nullable
as List<CalendarException>,missing: null == missing ? _self.missing : missing // ignore: cast_nullable_to_non_nullable
as List<CalendarMissing>,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketCalendar].
extension MarketCalendarPatterns on MarketCalendar {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketCalendar value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketCalendar() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketCalendar value)  $default,){
final _that = this;
switch (_that) {
case _MarketCalendar():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketCalendar value)?  $default,){
final _that = this;
switch (_that) {
case _MarketCalendar() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String from,  String to,  List<CalendarException> exceptions,  List<CalendarMissing> missing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketCalendar() when $default != null:
return $default(_that.from,_that.to,_that.exceptions,_that.missing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String from,  String to,  List<CalendarException> exceptions,  List<CalendarMissing> missing)  $default,) {final _that = this;
switch (_that) {
case _MarketCalendar():
return $default(_that.from,_that.to,_that.exceptions,_that.missing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String from,  String to,  List<CalendarException> exceptions,  List<CalendarMissing> missing)?  $default,) {final _that = this;
switch (_that) {
case _MarketCalendar() when $default != null:
return $default(_that.from,_that.to,_that.exceptions,_that.missing);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarketCalendar implements MarketCalendar {
  const _MarketCalendar({required this.from, required this.to, required  List<CalendarException> exceptions, required  List<CalendarMissing> missing}): _exceptions = exceptions,_missing = missing;
  factory _MarketCalendar.fromJson(Map<String, dynamic> json) => _$MarketCalendarFromJson(json);

@override final  String from;
@override final  String to;
 final  List<CalendarException> _exceptions;
@override List<CalendarException> get exceptions {
  if (_exceptions is EqualUnmodifiableListView) return _exceptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exceptions);
}

/// 범위에 걸친 연도 중 휴장 일정이 입력되지 않은 (시장, 연도).
 final  List<CalendarMissing> _missing;
/// 범위에 걸친 연도 중 휴장 일정이 입력되지 않은 (시장, 연도).
@override List<CalendarMissing> get missing {
  if (_missing is EqualUnmodifiableListView) return _missing;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_missing);
}


/// Create a copy of MarketCalendar
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketCalendarCopyWith<_MarketCalendar> get copyWith => __$MarketCalendarCopyWithImpl<_MarketCalendar>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarketCalendarToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketCalendar&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&const DeepCollectionEquality().equals(other.exceptions, _exceptions)&&const DeepCollectionEquality().equals(other.missing, _missing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,from,to,const DeepCollectionEquality().hash(_exceptions),const DeepCollectionEquality().hash(_missing));
}

@override
String toString() {
    return 'MarketCalendar(from: $from, to: $to, exceptions: $exceptions, missing: $missing)';
}


}

/// @nodoc
abstract mixin class _$MarketCalendarCopyWith<$Res> implements $MarketCalendarCopyWith<$Res> {
  factory _$MarketCalendarCopyWith(_MarketCalendar value, $Res Function(_MarketCalendar) _then) = __$MarketCalendarCopyWithImpl;
@override @useResult
$Res call({
 String from, String to, List<CalendarException> exceptions, List<CalendarMissing> missing
});




}
/// @nodoc
class __$MarketCalendarCopyWithImpl<$Res>
    implements _$MarketCalendarCopyWith<$Res> {
  __$MarketCalendarCopyWithImpl(this._self, this._then);

  final _MarketCalendar _self;
  final $Res Function(_MarketCalendar) _then;

/// Create a copy of MarketCalendar
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? exceptions = null,Object? missing = null,}) {
  return _then(_MarketCalendar(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,exceptions: null == exceptions ? _self._exceptions : exceptions // ignore: cast_nullable_to_non_nullable
as List<CalendarException>,missing: null == missing ? _self._missing : missing // ignore: cast_nullable_to_non_nullable
as List<CalendarMissing>,
  ));
}


}


/// @nodoc
mixin _$CalendarException {

 CalendarMarket get market; String get date; CalendarExceptionKind get kind;/// 그 시장 현지 시각 `HH:mm`(CME CT, KRX KST, NYSE ET). `CLOSED`는 null.
 String? get at;/// 휴일 이름. 입력 원문(CME·NYSE 영어, KRX 한국어).
 String get note;
/// Create a copy of CalendarException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarExceptionCopyWith<CalendarException> get copyWith => _$CalendarExceptionCopyWithImpl<CalendarException>(this as CalendarException, _$identity);

  /// Serializes this CalendarException to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CalendarException;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarException&&(identical(other.market, _this.market) || other.market == _this.market)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.at, _this.at) || other.at == _this.at)&&(identical(other.note, _this.note) || other.note == _this.note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CalendarException;
  return Object.hash(runtimeType,_this.market,_this.date,_this.kind,_this.at,_this.note);
}

@override
String toString() {
  final _this = this as CalendarException;
  return 'CalendarException(market: ${_this.market}, date: ${_this.date}, kind: ${_this.kind}, at: ${_this.at}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $CalendarExceptionCopyWith<$Res>  {
  factory $CalendarExceptionCopyWith(CalendarException value, $Res Function(CalendarException) _then) = _$CalendarExceptionCopyWithImpl;
@useResult
$Res call({
 CalendarMarket market, String date, CalendarExceptionKind kind, String? at, String note
});




}
/// @nodoc
class _$CalendarExceptionCopyWithImpl<$Res>
    implements $CalendarExceptionCopyWith<$Res> {
  _$CalendarExceptionCopyWithImpl(this._self, this._then);

  final CalendarException _self;
  final $Res Function(CalendarException) _then;

/// Create a copy of CalendarException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? market = null,Object? date = null,Object? kind = null,Object? at = freezed,Object? note = null,}) {
  return _then(CalendarException(
market: null == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as CalendarMarket,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as CalendarExceptionKind,at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as String?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarException].
extension CalendarExceptionPatterns on CalendarException {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarException value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarException() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarException value)  $default,){
final _that = this;
switch (_that) {
case _CalendarException():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarException value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarException() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CalendarMarket market,  String date,  CalendarExceptionKind kind,  String? at,  String note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarException() when $default != null:
return $default(_that.market,_that.date,_that.kind,_that.at,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CalendarMarket market,  String date,  CalendarExceptionKind kind,  String? at,  String note)  $default,) {final _that = this;
switch (_that) {
case _CalendarException():
return $default(_that.market,_that.date,_that.kind,_that.at,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CalendarMarket market,  String date,  CalendarExceptionKind kind,  String? at,  String note)?  $default,) {final _that = this;
switch (_that) {
case _CalendarException() when $default != null:
return $default(_that.market,_that.date,_that.kind,_that.at,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarException implements CalendarException {
  const _CalendarException({required this.market, required this.date, required this.kind, required this.at, required this.note});
  factory _CalendarException.fromJson(Map<String, dynamic> json) => _$CalendarExceptionFromJson(json);

@override final  CalendarMarket market;
@override final  String date;
@override final  CalendarExceptionKind kind;
/// 그 시장 현지 시각 `HH:mm`(CME CT, KRX KST, NYSE ET). `CLOSED`는 null.
@override final  String? at;
/// 휴일 이름. 입력 원문(CME·NYSE 영어, KRX 한국어).
@override final  String note;

/// Create a copy of CalendarException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarExceptionCopyWith<_CalendarException> get copyWith => __$CalendarExceptionCopyWithImpl<_CalendarException>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarExceptionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarException&&(identical(other.market, market) || other.market == market)&&(identical(other.date, date) || other.date == date)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.at, at) || other.at == at)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,market,date,kind,at,note);
}

@override
String toString() {
    return 'CalendarException(market: $market, date: $date, kind: $kind, at: $at, note: $note)';
}


}

/// @nodoc
abstract mixin class _$CalendarExceptionCopyWith<$Res> implements $CalendarExceptionCopyWith<$Res> {
  factory _$CalendarExceptionCopyWith(_CalendarException value, $Res Function(_CalendarException) _then) = __$CalendarExceptionCopyWithImpl;
@override @useResult
$Res call({
 CalendarMarket market, String date, CalendarExceptionKind kind, String? at, String note
});




}
/// @nodoc
class __$CalendarExceptionCopyWithImpl<$Res>
    implements _$CalendarExceptionCopyWith<$Res> {
  __$CalendarExceptionCopyWithImpl(this._self, this._then);

  final _CalendarException _self;
  final $Res Function(_CalendarException) _then;

/// Create a copy of CalendarException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? market = null,Object? date = null,Object? kind = null,Object? at = freezed,Object? note = null,}) {
  return _then(_CalendarException(
market: null == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as CalendarMarket,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as CalendarExceptionKind,at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as String?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CalendarMissing {

 CalendarMarket get market; int get year;
/// Create a copy of CalendarMissing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarMissingCopyWith<CalendarMissing> get copyWith => _$CalendarMissingCopyWithImpl<CalendarMissing>(this as CalendarMissing, _$identity);

  /// Serializes this CalendarMissing to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CalendarMissing;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarMissing&&(identical(other.market, _this.market) || other.market == _this.market)&&(identical(other.year, _this.year) || other.year == _this.year));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CalendarMissing;
  return Object.hash(runtimeType,_this.market,_this.year);
}

@override
String toString() {
  final _this = this as CalendarMissing;
  return 'CalendarMissing(market: ${_this.market}, year: ${_this.year})';
}


}

/// @nodoc
abstract mixin class $CalendarMissingCopyWith<$Res>  {
  factory $CalendarMissingCopyWith(CalendarMissing value, $Res Function(CalendarMissing) _then) = _$CalendarMissingCopyWithImpl;
@useResult
$Res call({
 CalendarMarket market, int year
});




}
/// @nodoc
class _$CalendarMissingCopyWithImpl<$Res>
    implements $CalendarMissingCopyWith<$Res> {
  _$CalendarMissingCopyWithImpl(this._self, this._then);

  final CalendarMissing _self;
  final $Res Function(CalendarMissing) _then;

/// Create a copy of CalendarMissing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? market = null,Object? year = null,}) {
  return _then(CalendarMissing(
market: null == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as CalendarMarket,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarMissing].
extension CalendarMissingPatterns on CalendarMissing {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarMissing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarMissing() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarMissing value)  $default,){
final _that = this;
switch (_that) {
case _CalendarMissing():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarMissing value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarMissing() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CalendarMarket market,  int year)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarMissing() when $default != null:
return $default(_that.market,_that.year);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CalendarMarket market,  int year)  $default,) {final _that = this;
switch (_that) {
case _CalendarMissing():
return $default(_that.market,_that.year);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CalendarMarket market,  int year)?  $default,) {final _that = this;
switch (_that) {
case _CalendarMissing() when $default != null:
return $default(_that.market,_that.year);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarMissing implements CalendarMissing {
  const _CalendarMissing({required this.market, required this.year});
  factory _CalendarMissing.fromJson(Map<String, dynamic> json) => _$CalendarMissingFromJson(json);

@override final  CalendarMarket market;
@override final  int year;

/// Create a copy of CalendarMissing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarMissingCopyWith<_CalendarMissing> get copyWith => __$CalendarMissingCopyWithImpl<_CalendarMissing>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarMissingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarMissing&&(identical(other.market, market) || other.market == market)&&(identical(other.year, year) || other.year == year));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,market,year);
}

@override
String toString() {
    return 'CalendarMissing(market: $market, year: $year)';
}


}

/// @nodoc
abstract mixin class _$CalendarMissingCopyWith<$Res> implements $CalendarMissingCopyWith<$Res> {
  factory _$CalendarMissingCopyWith(_CalendarMissing value, $Res Function(_CalendarMissing) _then) = __$CalendarMissingCopyWithImpl;
@override @useResult
$Res call({
 CalendarMarket market, int year
});




}
/// @nodoc
class __$CalendarMissingCopyWithImpl<$Res>
    implements _$CalendarMissingCopyWith<$Res> {
  __$CalendarMissingCopyWithImpl(this._self, this._then);

  final _CalendarMissing _self;
  final $Res Function(_CalendarMissing) _then;

/// Create a copy of CalendarMissing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? market = null,Object? year = null,}) {
  return _then(_CalendarMissing(
market: null == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as CalendarMarket,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
