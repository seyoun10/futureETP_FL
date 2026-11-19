// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'etp.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EtpList {

/// 상품 수집 시각 중 가장 늦은 값.
 DateTime? get asOf; List<EtpSummary> get etps;
/// Create a copy of EtpList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EtpListCopyWith<EtpList> get copyWith => _$EtpListCopyWithImpl<EtpList>(this as EtpList, _$identity);

  /// Serializes this EtpList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EtpList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EtpList&&(identical(other.asOf, _this.asOf) || other.asOf == _this.asOf)&&const DeepCollectionEquality().equals(other.etps, _this.etps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EtpList;
  return Object.hash(runtimeType,_this.asOf,const DeepCollectionEquality().hash(_this.etps));
}

@override
String toString() {
  final _this = this as EtpList;
  return 'EtpList(asOf: ${_this.asOf}, etps: ${_this.etps})';
}


}

/// @nodoc
abstract mixin class $EtpListCopyWith<$Res>  {
  factory $EtpListCopyWith(EtpList value, $Res Function(EtpList) _then) = _$EtpListCopyWithImpl;
@useResult
$Res call({
 DateTime? asOf, List<EtpSummary> etps
});




}
/// @nodoc
class _$EtpListCopyWithImpl<$Res>
    implements $EtpListCopyWith<$Res> {
  _$EtpListCopyWithImpl(this._self, this._then);

  final EtpList _self;
  final $Res Function(EtpList) _then;

/// Create a copy of EtpList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? asOf = freezed,Object? etps = null,}) {
  return _then(EtpList(
asOf: freezed == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as DateTime?,etps: null == etps ? _self.etps : etps // ignore: cast_nullable_to_non_nullable
as List<EtpSummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [EtpList].
extension EtpListPatterns on EtpList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EtpList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EtpList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EtpList value)  $default,){
final _that = this;
switch (_that) {
case _EtpList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EtpList value)?  $default,){
final _that = this;
switch (_that) {
case _EtpList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? asOf,  List<EtpSummary> etps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EtpList() when $default != null:
return $default(_that.asOf,_that.etps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? asOf,  List<EtpSummary> etps)  $default,) {final _that = this;
switch (_that) {
case _EtpList():
return $default(_that.asOf,_that.etps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? asOf,  List<EtpSummary> etps)?  $default,) {final _that = this;
switch (_that) {
case _EtpList() when $default != null:
return $default(_that.asOf,_that.etps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EtpList implements EtpList {
  const _EtpList({required this.asOf, required  List<EtpSummary> etps}): _etps = etps;
  factory _EtpList.fromJson(Map<String, dynamic> json) => _$EtpListFromJson(json);

/// 상품 수집 시각 중 가장 늦은 값.
@override final  DateTime? asOf;
 final  List<EtpSummary> _etps;
@override List<EtpSummary> get etps {
  if (_etps is EqualUnmodifiableListView) return _etps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_etps);
}


/// Create a copy of EtpList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EtpListCopyWith<_EtpList> get copyWith => __$EtpListCopyWithImpl<_EtpList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EtpListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EtpList&&(identical(other.asOf, asOf) || other.asOf == asOf)&&const DeepCollectionEquality().equals(other.etps, _etps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,asOf,const DeepCollectionEquality().hash(_etps));
}

@override
String toString() {
    return 'EtpList(asOf: $asOf, etps: $etps)';
}


}

/// @nodoc
abstract mixin class _$EtpListCopyWith<$Res> implements $EtpListCopyWith<$Res> {
  factory _$EtpListCopyWith(_EtpList value, $Res Function(_EtpList) _then) = __$EtpListCopyWithImpl;
@override @useResult
$Res call({
 DateTime? asOf, List<EtpSummary> etps
});




}
/// @nodoc
class __$EtpListCopyWithImpl<$Res>
    implements _$EtpListCopyWith<$Res> {
  __$EtpListCopyWithImpl(this._self, this._then);

  final _EtpList _self;
  final $Res Function(_EtpList) _then;

/// Create a copy of EtpList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? asOf = freezed,Object? etps = null,}) {
  return _then(_EtpList(
asOf: freezed == asOf ? _self.asOf : asOf // ignore: cast_nullable_to_non_nullable
as DateTime?,etps: null == etps ? _self._etps : etps // ignore: cast_nullable_to_non_nullable
as List<EtpSummary>,
  ));
}


}


/// @nodoc
mixin _$EtpSummary {

 String get id; EtpMarket get market; EtpType get type; double get leverage; FxHedge get fxHedge; String get name; List<String> get tickers; double? get aum; double? get avgTradingValue;
/// Create a copy of EtpSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EtpSummaryCopyWith<EtpSummary> get copyWith => _$EtpSummaryCopyWithImpl<EtpSummary>(this as EtpSummary, _$identity);

  /// Serializes this EtpSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EtpSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EtpSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.market, _this.market) || other.market == _this.market)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.leverage, _this.leverage) || other.leverage == _this.leverage)&&(identical(other.fxHedge, _this.fxHedge) || other.fxHedge == _this.fxHedge)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.tickers, _this.tickers)&&(identical(other.aum, _this.aum) || other.aum == _this.aum)&&(identical(other.avgTradingValue, _this.avgTradingValue) || other.avgTradingValue == _this.avgTradingValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EtpSummary;
  return Object.hash(runtimeType,_this.id,_this.market,_this.type,_this.leverage,_this.fxHedge,_this.name,const DeepCollectionEquality().hash(_this.tickers),_this.aum,_this.avgTradingValue);
}

@override
String toString() {
  final _this = this as EtpSummary;
  return 'EtpSummary(id: ${_this.id}, market: ${_this.market}, type: ${_this.type}, leverage: ${_this.leverage}, fxHedge: ${_this.fxHedge}, name: ${_this.name}, tickers: ${_this.tickers}, aum: ${_this.aum}, avgTradingValue: ${_this.avgTradingValue})';
}


}

/// @nodoc
abstract mixin class $EtpSummaryCopyWith<$Res>  {
  factory $EtpSummaryCopyWith(EtpSummary value, $Res Function(EtpSummary) _then) = _$EtpSummaryCopyWithImpl;
@useResult
$Res call({
 String id, EtpMarket market, EtpType type, double leverage, FxHedge fxHedge, String name, List<String> tickers, double? aum, double? avgTradingValue
});




}
/// @nodoc
class _$EtpSummaryCopyWithImpl<$Res>
    implements $EtpSummaryCopyWith<$Res> {
  _$EtpSummaryCopyWithImpl(this._self, this._then);

  final EtpSummary _self;
  final $Res Function(EtpSummary) _then;

/// Create a copy of EtpSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? market = null,Object? type = null,Object? leverage = null,Object? fxHedge = null,Object? name = null,Object? tickers = null,Object? aum = freezed,Object? avgTradingValue = freezed,}) {
  return _then(EtpSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,market: null == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as EtpMarket,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EtpType,leverage: null == leverage ? _self.leverage : leverage // ignore: cast_nullable_to_non_nullable
as double,fxHedge: null == fxHedge ? _self.fxHedge : fxHedge // ignore: cast_nullable_to_non_nullable
as FxHedge,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tickers: null == tickers ? _self.tickers : tickers // ignore: cast_nullable_to_non_nullable
as List<String>,aum: freezed == aum ? _self.aum : aum // ignore: cast_nullable_to_non_nullable
as double?,avgTradingValue: freezed == avgTradingValue ? _self.avgTradingValue : avgTradingValue // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [EtpSummary].
extension EtpSummaryPatterns on EtpSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EtpSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EtpSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EtpSummary value)  $default,){
final _that = this;
switch (_that) {
case _EtpSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EtpSummary value)?  $default,){
final _that = this;
switch (_that) {
case _EtpSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  EtpMarket market,  EtpType type,  double leverage,  FxHedge fxHedge,  String name,  List<String> tickers,  double? aum,  double? avgTradingValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EtpSummary() when $default != null:
return $default(_that.id,_that.market,_that.type,_that.leverage,_that.fxHedge,_that.name,_that.tickers,_that.aum,_that.avgTradingValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  EtpMarket market,  EtpType type,  double leverage,  FxHedge fxHedge,  String name,  List<String> tickers,  double? aum,  double? avgTradingValue)  $default,) {final _that = this;
switch (_that) {
case _EtpSummary():
return $default(_that.id,_that.market,_that.type,_that.leverage,_that.fxHedge,_that.name,_that.tickers,_that.aum,_that.avgTradingValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  EtpMarket market,  EtpType type,  double leverage,  FxHedge fxHedge,  String name,  List<String> tickers,  double? aum,  double? avgTradingValue)?  $default,) {final _that = this;
switch (_that) {
case _EtpSummary() when $default != null:
return $default(_that.id,_that.market,_that.type,_that.leverage,_that.fxHedge,_that.name,_that.tickers,_that.aum,_that.avgTradingValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EtpSummary implements EtpSummary {
  const _EtpSummary({required this.id, required this.market, required this.type, required this.leverage, required this.fxHedge, required this.name, required  List<String> tickers, required this.aum, required this.avgTradingValue}): _tickers = tickers;
  factory _EtpSummary.fromJson(Map<String, dynamic> json) => _$EtpSummaryFromJson(json);

@override final  String id;
@override final  EtpMarket market;
@override final  EtpType type;
@override final  double leverage;
@override final  FxHedge fxHedge;
@override final  String name;
 final  List<String> _tickers;
@override List<String> get tickers {
  if (_tickers is EqualUnmodifiableListView) return _tickers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tickers);
}

@override final  double? aum;
@override final  double? avgTradingValue;

/// Create a copy of EtpSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EtpSummaryCopyWith<_EtpSummary> get copyWith => __$EtpSummaryCopyWithImpl<_EtpSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EtpSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EtpSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.market, market) || other.market == market)&&(identical(other.type, type) || other.type == type)&&(identical(other.leverage, leverage) || other.leverage == leverage)&&(identical(other.fxHedge, fxHedge) || other.fxHedge == fxHedge)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.tickers, _tickers)&&(identical(other.aum, aum) || other.aum == aum)&&(identical(other.avgTradingValue, avgTradingValue) || other.avgTradingValue == avgTradingValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,market,type,leverage,fxHedge,name,const DeepCollectionEquality().hash(_tickers),aum,avgTradingValue);
}

@override
String toString() {
    return 'EtpSummary(id: $id, market: $market, type: $type, leverage: $leverage, fxHedge: $fxHedge, name: $name, tickers: $tickers, aum: $aum, avgTradingValue: $avgTradingValue)';
}


}

/// @nodoc
abstract mixin class _$EtpSummaryCopyWith<$Res> implements $EtpSummaryCopyWith<$Res> {
  factory _$EtpSummaryCopyWith(_EtpSummary value, $Res Function(_EtpSummary) _then) = __$EtpSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, EtpMarket market, EtpType type, double leverage, FxHedge fxHedge, String name, List<String> tickers, double? aum, double? avgTradingValue
});




}
/// @nodoc
class __$EtpSummaryCopyWithImpl<$Res>
    implements _$EtpSummaryCopyWith<$Res> {
  __$EtpSummaryCopyWithImpl(this._self, this._then);

  final _EtpSummary _self;
  final $Res Function(_EtpSummary) _then;

/// Create a copy of EtpSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? market = null,Object? type = null,Object? leverage = null,Object? fxHedge = null,Object? name = null,Object? tickers = null,Object? aum = freezed,Object? avgTradingValue = freezed,}) {
  return _then(_EtpSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,market: null == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as EtpMarket,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EtpType,leverage: null == leverage ? _self.leverage : leverage // ignore: cast_nullable_to_non_nullable
as double,fxHedge: null == fxHedge ? _self.fxHedge : fxHedge // ignore: cast_nullable_to_non_nullable
as FxHedge,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tickers: null == tickers ? _self._tickers : tickers // ignore: cast_nullable_to_non_nullable
as List<String>,aum: freezed == aum ? _self.aum : aum // ignore: cast_nullable_to_non_nullable
as double?,avgTradingValue: freezed == avgTradingValue ? _self.avgTradingValue : avgTradingValue // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$EtpDetail {

 String get id; EtpMarket get market; EtpType get type; double get leverage; FxHedge get fxHedge; String get name; List<String> get tickers; double? get aum; double? get avgTradingValue; CommodityCode get commodityCode; AppLanguage get nameLang; String? get issuer; String? get underlyingIndex; double? get expenseRatio; String? get issuerUrl; String? get listedDate; List<EtpSeries> get series; DateTime get collectedAt;
/// Create a copy of EtpDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EtpDetailCopyWith<EtpDetail> get copyWith => _$EtpDetailCopyWithImpl<EtpDetail>(this as EtpDetail, _$identity);

  /// Serializes this EtpDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EtpDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EtpDetail&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.market, _this.market) || other.market == _this.market)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.leverage, _this.leverage) || other.leverage == _this.leverage)&&(identical(other.fxHedge, _this.fxHedge) || other.fxHedge == _this.fxHedge)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.tickers, _this.tickers)&&(identical(other.aum, _this.aum) || other.aum == _this.aum)&&(identical(other.avgTradingValue, _this.avgTradingValue) || other.avgTradingValue == _this.avgTradingValue)&&(identical(other.commodityCode, _this.commodityCode) || other.commodityCode == _this.commodityCode)&&(identical(other.nameLang, _this.nameLang) || other.nameLang == _this.nameLang)&&(identical(other.issuer, _this.issuer) || other.issuer == _this.issuer)&&(identical(other.underlyingIndex, _this.underlyingIndex) || other.underlyingIndex == _this.underlyingIndex)&&(identical(other.expenseRatio, _this.expenseRatio) || other.expenseRatio == _this.expenseRatio)&&(identical(other.issuerUrl, _this.issuerUrl) || other.issuerUrl == _this.issuerUrl)&&(identical(other.listedDate, _this.listedDate) || other.listedDate == _this.listedDate)&&const DeepCollectionEquality().equals(other.series, _this.series)&&(identical(other.collectedAt, _this.collectedAt) || other.collectedAt == _this.collectedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EtpDetail;
  return Object.hash(runtimeType,_this.id,_this.market,_this.type,_this.leverage,_this.fxHedge,_this.name,const DeepCollectionEquality().hash(_this.tickers),_this.aum,_this.avgTradingValue,_this.commodityCode,_this.nameLang,_this.issuer,_this.underlyingIndex,_this.expenseRatio,_this.issuerUrl,_this.listedDate,const DeepCollectionEquality().hash(_this.series),_this.collectedAt);
}

@override
String toString() {
  final _this = this as EtpDetail;
  return 'EtpDetail(id: ${_this.id}, market: ${_this.market}, type: ${_this.type}, leverage: ${_this.leverage}, fxHedge: ${_this.fxHedge}, name: ${_this.name}, tickers: ${_this.tickers}, aum: ${_this.aum}, avgTradingValue: ${_this.avgTradingValue}, commodityCode: ${_this.commodityCode}, nameLang: ${_this.nameLang}, issuer: ${_this.issuer}, underlyingIndex: ${_this.underlyingIndex}, expenseRatio: ${_this.expenseRatio}, issuerUrl: ${_this.issuerUrl}, listedDate: ${_this.listedDate}, series: ${_this.series}, collectedAt: ${_this.collectedAt})';
}


}

/// @nodoc
abstract mixin class $EtpDetailCopyWith<$Res>  {
  factory $EtpDetailCopyWith(EtpDetail value, $Res Function(EtpDetail) _then) = _$EtpDetailCopyWithImpl;
@useResult
$Res call({
 String id, EtpMarket market, EtpType type, double leverage, FxHedge fxHedge, String name, List<String> tickers, double? aum, double? avgTradingValue, CommodityCode commodityCode, AppLanguage nameLang, String? issuer, String? underlyingIndex, double? expenseRatio, String? issuerUrl, String? listedDate, List<EtpSeries> series, DateTime collectedAt
});




}
/// @nodoc
class _$EtpDetailCopyWithImpl<$Res>
    implements $EtpDetailCopyWith<$Res> {
  _$EtpDetailCopyWithImpl(this._self, this._then);

  final EtpDetail _self;
  final $Res Function(EtpDetail) _then;

/// Create a copy of EtpDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? market = null,Object? type = null,Object? leverage = null,Object? fxHedge = null,Object? name = null,Object? tickers = null,Object? aum = freezed,Object? avgTradingValue = freezed,Object? commodityCode = null,Object? nameLang = null,Object? issuer = freezed,Object? underlyingIndex = freezed,Object? expenseRatio = freezed,Object? issuerUrl = freezed,Object? listedDate = freezed,Object? series = null,Object? collectedAt = null,}) {
  return _then(EtpDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,market: null == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as EtpMarket,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EtpType,leverage: null == leverage ? _self.leverage : leverage // ignore: cast_nullable_to_non_nullable
as double,fxHedge: null == fxHedge ? _self.fxHedge : fxHedge // ignore: cast_nullable_to_non_nullable
as FxHedge,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tickers: null == tickers ? _self.tickers : tickers // ignore: cast_nullable_to_non_nullable
as List<String>,aum: freezed == aum ? _self.aum : aum // ignore: cast_nullable_to_non_nullable
as double?,avgTradingValue: freezed == avgTradingValue ? _self.avgTradingValue : avgTradingValue // ignore: cast_nullable_to_non_nullable
as double?,commodityCode: null == commodityCode ? _self.commodityCode : commodityCode // ignore: cast_nullable_to_non_nullable
as CommodityCode,nameLang: null == nameLang ? _self.nameLang : nameLang // ignore: cast_nullable_to_non_nullable
as AppLanguage,issuer: freezed == issuer ? _self.issuer : issuer // ignore: cast_nullable_to_non_nullable
as String?,underlyingIndex: freezed == underlyingIndex ? _self.underlyingIndex : underlyingIndex // ignore: cast_nullable_to_non_nullable
as String?,expenseRatio: freezed == expenseRatio ? _self.expenseRatio : expenseRatio // ignore: cast_nullable_to_non_nullable
as double?,issuerUrl: freezed == issuerUrl ? _self.issuerUrl : issuerUrl // ignore: cast_nullable_to_non_nullable
as String?,listedDate: freezed == listedDate ? _self.listedDate : listedDate // ignore: cast_nullable_to_non_nullable
as String?,series: null == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as List<EtpSeries>,collectedAt: null == collectedAt ? _self.collectedAt : collectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [EtpDetail].
extension EtpDetailPatterns on EtpDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EtpDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EtpDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EtpDetail value)  $default,){
final _that = this;
switch (_that) {
case _EtpDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EtpDetail value)?  $default,){
final _that = this;
switch (_that) {
case _EtpDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  EtpMarket market,  EtpType type,  double leverage,  FxHedge fxHedge,  String name,  List<String> tickers,  double? aum,  double? avgTradingValue,  CommodityCode commodityCode,  AppLanguage nameLang,  String? issuer,  String? underlyingIndex,  double? expenseRatio,  String? issuerUrl,  String? listedDate,  List<EtpSeries> series,  DateTime collectedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EtpDetail() when $default != null:
return $default(_that.id,_that.market,_that.type,_that.leverage,_that.fxHedge,_that.name,_that.tickers,_that.aum,_that.avgTradingValue,_that.commodityCode,_that.nameLang,_that.issuer,_that.underlyingIndex,_that.expenseRatio,_that.issuerUrl,_that.listedDate,_that.series,_that.collectedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  EtpMarket market,  EtpType type,  double leverage,  FxHedge fxHedge,  String name,  List<String> tickers,  double? aum,  double? avgTradingValue,  CommodityCode commodityCode,  AppLanguage nameLang,  String? issuer,  String? underlyingIndex,  double? expenseRatio,  String? issuerUrl,  String? listedDate,  List<EtpSeries> series,  DateTime collectedAt)  $default,) {final _that = this;
switch (_that) {
case _EtpDetail():
return $default(_that.id,_that.market,_that.type,_that.leverage,_that.fxHedge,_that.name,_that.tickers,_that.aum,_that.avgTradingValue,_that.commodityCode,_that.nameLang,_that.issuer,_that.underlyingIndex,_that.expenseRatio,_that.issuerUrl,_that.listedDate,_that.series,_that.collectedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  EtpMarket market,  EtpType type,  double leverage,  FxHedge fxHedge,  String name,  List<String> tickers,  double? aum,  double? avgTradingValue,  CommodityCode commodityCode,  AppLanguage nameLang,  String? issuer,  String? underlyingIndex,  double? expenseRatio,  String? issuerUrl,  String? listedDate,  List<EtpSeries> series,  DateTime collectedAt)?  $default,) {final _that = this;
switch (_that) {
case _EtpDetail() when $default != null:
return $default(_that.id,_that.market,_that.type,_that.leverage,_that.fxHedge,_that.name,_that.tickers,_that.aum,_that.avgTradingValue,_that.commodityCode,_that.nameLang,_that.issuer,_that.underlyingIndex,_that.expenseRatio,_that.issuerUrl,_that.listedDate,_that.series,_that.collectedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EtpDetail implements EtpDetail {
  const _EtpDetail({required this.id, required this.market, required this.type, required this.leverage, required this.fxHedge, required this.name, required  List<String> tickers, required this.aum, required this.avgTradingValue, required this.commodityCode, required this.nameLang, required this.issuer, required this.underlyingIndex, required this.expenseRatio, required this.issuerUrl, required this.listedDate, required  List<EtpSeries> series, required this.collectedAt}): _tickers = tickers,_series = series;
  factory _EtpDetail.fromJson(Map<String, dynamic> json) => _$EtpDetailFromJson(json);

@override final  String id;
@override final  EtpMarket market;
@override final  EtpType type;
@override final  double leverage;
@override final  FxHedge fxHedge;
@override final  String name;
 final  List<String> _tickers;
@override List<String> get tickers {
  if (_tickers is EqualUnmodifiableListView) return _tickers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tickers);
}

@override final  double? aum;
@override final  double? avgTradingValue;
@override final  CommodityCode commodityCode;
@override final  AppLanguage nameLang;
@override final  String? issuer;
@override final  String? underlyingIndex;
@override final  double? expenseRatio;
@override final  String? issuerUrl;
@override final  String? listedDate;
 final  List<EtpSeries> _series;
@override List<EtpSeries> get series {
  if (_series is EqualUnmodifiableListView) return _series;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_series);
}

@override final  DateTime collectedAt;

/// Create a copy of EtpDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EtpDetailCopyWith<_EtpDetail> get copyWith => __$EtpDetailCopyWithImpl<_EtpDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EtpDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EtpDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.market, market) || other.market == market)&&(identical(other.type, type) || other.type == type)&&(identical(other.leverage, leverage) || other.leverage == leverage)&&(identical(other.fxHedge, fxHedge) || other.fxHedge == fxHedge)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.tickers, _tickers)&&(identical(other.aum, aum) || other.aum == aum)&&(identical(other.avgTradingValue, avgTradingValue) || other.avgTradingValue == avgTradingValue)&&(identical(other.commodityCode, commodityCode) || other.commodityCode == commodityCode)&&(identical(other.nameLang, nameLang) || other.nameLang == nameLang)&&(identical(other.issuer, issuer) || other.issuer == issuer)&&(identical(other.underlyingIndex, underlyingIndex) || other.underlyingIndex == underlyingIndex)&&(identical(other.expenseRatio, expenseRatio) || other.expenseRatio == expenseRatio)&&(identical(other.issuerUrl, issuerUrl) || other.issuerUrl == issuerUrl)&&(identical(other.listedDate, listedDate) || other.listedDate == listedDate)&&const DeepCollectionEquality().equals(other.series, _series)&&(identical(other.collectedAt, collectedAt) || other.collectedAt == collectedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,market,type,leverage,fxHedge,name,const DeepCollectionEquality().hash(_tickers),aum,avgTradingValue,commodityCode,nameLang,issuer,underlyingIndex,expenseRatio,issuerUrl,listedDate,const DeepCollectionEquality().hash(_series),collectedAt);
}

@override
String toString() {
    return 'EtpDetail(id: $id, market: $market, type: $type, leverage: $leverage, fxHedge: $fxHedge, name: $name, tickers: $tickers, aum: $aum, avgTradingValue: $avgTradingValue, commodityCode: $commodityCode, nameLang: $nameLang, issuer: $issuer, underlyingIndex: $underlyingIndex, expenseRatio: $expenseRatio, issuerUrl: $issuerUrl, listedDate: $listedDate, series: $series, collectedAt: $collectedAt)';
}


}

/// @nodoc
abstract mixin class _$EtpDetailCopyWith<$Res> implements $EtpDetailCopyWith<$Res> {
  factory _$EtpDetailCopyWith(_EtpDetail value, $Res Function(_EtpDetail) _then) = __$EtpDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, EtpMarket market, EtpType type, double leverage, FxHedge fxHedge, String name, List<String> tickers, double? aum, double? avgTradingValue, CommodityCode commodityCode, AppLanguage nameLang, String? issuer, String? underlyingIndex, double? expenseRatio, String? issuerUrl, String? listedDate, List<EtpSeries> series, DateTime collectedAt
});




}
/// @nodoc
class __$EtpDetailCopyWithImpl<$Res>
    implements _$EtpDetailCopyWith<$Res> {
  __$EtpDetailCopyWithImpl(this._self, this._then);

  final _EtpDetail _self;
  final $Res Function(_EtpDetail) _then;

/// Create a copy of EtpDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? market = null,Object? type = null,Object? leverage = null,Object? fxHedge = null,Object? name = null,Object? tickers = null,Object? aum = freezed,Object? avgTradingValue = freezed,Object? commodityCode = null,Object? nameLang = null,Object? issuer = freezed,Object? underlyingIndex = freezed,Object? expenseRatio = freezed,Object? issuerUrl = freezed,Object? listedDate = freezed,Object? series = null,Object? collectedAt = null,}) {
  return _then(_EtpDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,market: null == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as EtpMarket,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EtpType,leverage: null == leverage ? _self.leverage : leverage // ignore: cast_nullable_to_non_nullable
as double,fxHedge: null == fxHedge ? _self.fxHedge : fxHedge // ignore: cast_nullable_to_non_nullable
as FxHedge,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tickers: null == tickers ? _self._tickers : tickers // ignore: cast_nullable_to_non_nullable
as List<String>,aum: freezed == aum ? _self.aum : aum // ignore: cast_nullable_to_non_nullable
as double?,avgTradingValue: freezed == avgTradingValue ? _self.avgTradingValue : avgTradingValue // ignore: cast_nullable_to_non_nullable
as double?,commodityCode: null == commodityCode ? _self.commodityCode : commodityCode // ignore: cast_nullable_to_non_nullable
as CommodityCode,nameLang: null == nameLang ? _self.nameLang : nameLang // ignore: cast_nullable_to_non_nullable
as AppLanguage,issuer: freezed == issuer ? _self.issuer : issuer // ignore: cast_nullable_to_non_nullable
as String?,underlyingIndex: freezed == underlyingIndex ? _self.underlyingIndex : underlyingIndex // ignore: cast_nullable_to_non_nullable
as String?,expenseRatio: freezed == expenseRatio ? _self.expenseRatio : expenseRatio // ignore: cast_nullable_to_non_nullable
as double?,issuerUrl: freezed == issuerUrl ? _self.issuerUrl : issuerUrl // ignore: cast_nullable_to_non_nullable
as String?,listedDate: freezed == listedDate ? _self.listedDate : listedDate // ignore: cast_nullable_to_non_nullable
as String?,series: null == series ? _self._series : series // ignore: cast_nullable_to_non_nullable
as List<EtpSeries>,collectedAt: null == collectedAt ? _self.collectedAt : collectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$EtpSeries {

 String get ticker; String? get seriesCode; String? get maturityDate;
/// Create a copy of EtpSeries
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EtpSeriesCopyWith<EtpSeries> get copyWith => _$EtpSeriesCopyWithImpl<EtpSeries>(this as EtpSeries, _$identity);

  /// Serializes this EtpSeries to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EtpSeries;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EtpSeries&&(identical(other.ticker, _this.ticker) || other.ticker == _this.ticker)&&(identical(other.seriesCode, _this.seriesCode) || other.seriesCode == _this.seriesCode)&&(identical(other.maturityDate, _this.maturityDate) || other.maturityDate == _this.maturityDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EtpSeries;
  return Object.hash(runtimeType,_this.ticker,_this.seriesCode,_this.maturityDate);
}

@override
String toString() {
  final _this = this as EtpSeries;
  return 'EtpSeries(ticker: ${_this.ticker}, seriesCode: ${_this.seriesCode}, maturityDate: ${_this.maturityDate})';
}


}

/// @nodoc
abstract mixin class $EtpSeriesCopyWith<$Res>  {
  factory $EtpSeriesCopyWith(EtpSeries value, $Res Function(EtpSeries) _then) = _$EtpSeriesCopyWithImpl;
@useResult
$Res call({
 String ticker, String? seriesCode, String? maturityDate
});




}
/// @nodoc
class _$EtpSeriesCopyWithImpl<$Res>
    implements $EtpSeriesCopyWith<$Res> {
  _$EtpSeriesCopyWithImpl(this._self, this._then);

  final EtpSeries _self;
  final $Res Function(EtpSeries) _then;

/// Create a copy of EtpSeries
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ticker = null,Object? seriesCode = freezed,Object? maturityDate = freezed,}) {
  return _then(EtpSeries(
ticker: null == ticker ? _self.ticker : ticker // ignore: cast_nullable_to_non_nullable
as String,seriesCode: freezed == seriesCode ? _self.seriesCode : seriesCode // ignore: cast_nullable_to_non_nullable
as String?,maturityDate: freezed == maturityDate ? _self.maturityDate : maturityDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EtpSeries].
extension EtpSeriesPatterns on EtpSeries {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EtpSeries value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EtpSeries() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EtpSeries value)  $default,){
final _that = this;
switch (_that) {
case _EtpSeries():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EtpSeries value)?  $default,){
final _that = this;
switch (_that) {
case _EtpSeries() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ticker,  String? seriesCode,  String? maturityDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EtpSeries() when $default != null:
return $default(_that.ticker,_that.seriesCode,_that.maturityDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ticker,  String? seriesCode,  String? maturityDate)  $default,) {final _that = this;
switch (_that) {
case _EtpSeries():
return $default(_that.ticker,_that.seriesCode,_that.maturityDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ticker,  String? seriesCode,  String? maturityDate)?  $default,) {final _that = this;
switch (_that) {
case _EtpSeries() when $default != null:
return $default(_that.ticker,_that.seriesCode,_that.maturityDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EtpSeries implements EtpSeries {
  const _EtpSeries({required this.ticker, required this.seriesCode, required this.maturityDate});
  factory _EtpSeries.fromJson(Map<String, dynamic> json) => _$EtpSeriesFromJson(json);

@override final  String ticker;
@override final  String? seriesCode;
@override final  String? maturityDate;

/// Create a copy of EtpSeries
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EtpSeriesCopyWith<_EtpSeries> get copyWith => __$EtpSeriesCopyWithImpl<_EtpSeries>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EtpSeriesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EtpSeries&&(identical(other.ticker, ticker) || other.ticker == ticker)&&(identical(other.seriesCode, seriesCode) || other.seriesCode == seriesCode)&&(identical(other.maturityDate, maturityDate) || other.maturityDate == maturityDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ticker,seriesCode,maturityDate);
}

@override
String toString() {
    return 'EtpSeries(ticker: $ticker, seriesCode: $seriesCode, maturityDate: $maturityDate)';
}


}

/// @nodoc
abstract mixin class _$EtpSeriesCopyWith<$Res> implements $EtpSeriesCopyWith<$Res> {
  factory _$EtpSeriesCopyWith(_EtpSeries value, $Res Function(_EtpSeries) _then) = __$EtpSeriesCopyWithImpl;
@override @useResult
$Res call({
 String ticker, String? seriesCode, String? maturityDate
});




}
/// @nodoc
class __$EtpSeriesCopyWithImpl<$Res>
    implements _$EtpSeriesCopyWith<$Res> {
  __$EtpSeriesCopyWithImpl(this._self, this._then);

  final _EtpSeries _self;
  final $Res Function(_EtpSeries) _then;

/// Create a copy of EtpSeries
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ticker = null,Object? seriesCode = freezed,Object? maturityDate = freezed,}) {
  return _then(_EtpSeries(
ticker: null == ticker ? _self.ticker : ticker // ignore: cast_nullable_to_non_nullable
as String,seriesCode: freezed == seriesCode ? _self.seriesCode : seriesCode // ignore: cast_nullable_to_non_nullable
as String?,maturityDate: freezed == maturityDate ? _self.maturityDate : maturityDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
