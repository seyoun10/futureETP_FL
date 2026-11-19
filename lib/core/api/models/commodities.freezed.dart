// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'commodities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommodityList {

 Freshness get freshness; List<CommodityQuotes> get commodities;
/// Create a copy of CommodityList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommodityListCopyWith<CommodityList> get copyWith => _$CommodityListCopyWithImpl<CommodityList>(this as CommodityList, _$identity);

  /// Serializes this CommodityList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CommodityList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommodityList&&(identical(other.freshness, _this.freshness) || other.freshness == _this.freshness)&&const DeepCollectionEquality().equals(other.commodities, _this.commodities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CommodityList;
  return Object.hash(runtimeType,_this.freshness,const DeepCollectionEquality().hash(_this.commodities));
}

@override
String toString() {
  final _this = this as CommodityList;
  return 'CommodityList(freshness: ${_this.freshness}, commodities: ${_this.commodities})';
}


}

/// @nodoc
abstract mixin class $CommodityListCopyWith<$Res>  {
  factory $CommodityListCopyWith(CommodityList value, $Res Function(CommodityList) _then) = _$CommodityListCopyWithImpl;
@useResult
$Res call({
 Freshness freshness, List<CommodityQuotes> commodities
});


$FreshnessCopyWith<$Res> get freshness;

}
/// @nodoc
class _$CommodityListCopyWithImpl<$Res>
    implements $CommodityListCopyWith<$Res> {
  _$CommodityListCopyWithImpl(this._self, this._then);

  final CommodityList _self;
  final $Res Function(CommodityList) _then;

/// Create a copy of CommodityList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? freshness = null,Object? commodities = null,}) {
  return _then(CommodityList(
freshness: null == freshness ? _self.freshness : freshness // ignore: cast_nullable_to_non_nullable
as Freshness,commodities: null == commodities ? _self.commodities : commodities // ignore: cast_nullable_to_non_nullable
as List<CommodityQuotes>,
  ));
}
/// Create a copy of CommodityList
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FreshnessCopyWith<$Res> get freshness {
  
  return $FreshnessCopyWith<$Res>(_self.freshness, (value) {
    return _then(_self.copyWith(freshness: value));
  });
}
}


/// Adds pattern-matching-related methods to [CommodityList].
extension CommodityListPatterns on CommodityList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommodityList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommodityList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommodityList value)  $default,){
final _that = this;
switch (_that) {
case _CommodityList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommodityList value)?  $default,){
final _that = this;
switch (_that) {
case _CommodityList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Freshness freshness,  List<CommodityQuotes> commodities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommodityList() when $default != null:
return $default(_that.freshness,_that.commodities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Freshness freshness,  List<CommodityQuotes> commodities)  $default,) {final _that = this;
switch (_that) {
case _CommodityList():
return $default(_that.freshness,_that.commodities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Freshness freshness,  List<CommodityQuotes> commodities)?  $default,) {final _that = this;
switch (_that) {
case _CommodityList() when $default != null:
return $default(_that.freshness,_that.commodities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommodityList implements CommodityList {
  const _CommodityList({required this.freshness, required  List<CommodityQuotes> commodities}): _commodities = commodities;
  factory _CommodityList.fromJson(Map<String, dynamic> json) => _$CommodityListFromJson(json);

@override final  Freshness freshness;
 final  List<CommodityQuotes> _commodities;
@override List<CommodityQuotes> get commodities {
  if (_commodities is EqualUnmodifiableListView) return _commodities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_commodities);
}


/// Create a copy of CommodityList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommodityListCopyWith<_CommodityList> get copyWith => __$CommodityListCopyWithImpl<_CommodityList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommodityListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommodityList&&(identical(other.freshness, freshness) || other.freshness == freshness)&&const DeepCollectionEquality().equals(other.commodities, _commodities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,freshness,const DeepCollectionEquality().hash(_commodities));
}

@override
String toString() {
    return 'CommodityList(freshness: $freshness, commodities: $commodities)';
}


}

/// @nodoc
abstract mixin class _$CommodityListCopyWith<$Res> implements $CommodityListCopyWith<$Res> {
  factory _$CommodityListCopyWith(_CommodityList value, $Res Function(_CommodityList) _then) = __$CommodityListCopyWithImpl;
@override @useResult
$Res call({
 Freshness freshness, List<CommodityQuotes> commodities
});


@override $FreshnessCopyWith<$Res> get freshness;

}
/// @nodoc
class __$CommodityListCopyWithImpl<$Res>
    implements _$CommodityListCopyWith<$Res> {
  __$CommodityListCopyWithImpl(this._self, this._then);

  final _CommodityList _self;
  final $Res Function(_CommodityList) _then;

/// Create a copy of CommodityList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? freshness = null,Object? commodities = null,}) {
  return _then(_CommodityList(
freshness: null == freshness ? _self.freshness : freshness // ignore: cast_nullable_to_non_nullable
as Freshness,commodities: null == commodities ? _self._commodities : commodities // ignore: cast_nullable_to_non_nullable
as List<CommodityQuotes>,
  ));
}

/// Create a copy of CommodityList
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FreshnessCopyWith<$Res> get freshness {
  
  return $FreshnessCopyWith<$Res>(_self.freshness, (value) {
    return _then(_self.copyWith(freshness: value));
  });
}
}


/// @nodoc
mixin _$CommodityQuotes {

 CommodityCode get code; int get priceDecimals; bool get alert; List<ContractQuote> get contracts;
/// Create a copy of CommodityQuotes
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommodityQuotesCopyWith<CommodityQuotes> get copyWith => _$CommodityQuotesCopyWithImpl<CommodityQuotes>(this as CommodityQuotes, _$identity);

  /// Serializes this CommodityQuotes to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CommodityQuotes;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommodityQuotes&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.priceDecimals, _this.priceDecimals) || other.priceDecimals == _this.priceDecimals)&&(identical(other.alert, _this.alert) || other.alert == _this.alert)&&const DeepCollectionEquality().equals(other.contracts, _this.contracts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CommodityQuotes;
  return Object.hash(runtimeType,_this.code,_this.priceDecimals,_this.alert,const DeepCollectionEquality().hash(_this.contracts));
}

@override
String toString() {
  final _this = this as CommodityQuotes;
  return 'CommodityQuotes(code: ${_this.code}, priceDecimals: ${_this.priceDecimals}, alert: ${_this.alert}, contracts: ${_this.contracts})';
}


}

/// @nodoc
abstract mixin class $CommodityQuotesCopyWith<$Res>  {
  factory $CommodityQuotesCopyWith(CommodityQuotes value, $Res Function(CommodityQuotes) _then) = _$CommodityQuotesCopyWithImpl;
@useResult
$Res call({
 CommodityCode code, int priceDecimals, bool alert, List<ContractQuote> contracts
});




}
/// @nodoc
class _$CommodityQuotesCopyWithImpl<$Res>
    implements $CommodityQuotesCopyWith<$Res> {
  _$CommodityQuotesCopyWithImpl(this._self, this._then);

  final CommodityQuotes _self;
  final $Res Function(CommodityQuotes) _then;

/// Create a copy of CommodityQuotes
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? priceDecimals = null,Object? alert = null,Object? contracts = null,}) {
  return _then(CommodityQuotes(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as CommodityCode,priceDecimals: null == priceDecimals ? _self.priceDecimals : priceDecimals // ignore: cast_nullable_to_non_nullable
as int,alert: null == alert ? _self.alert : alert // ignore: cast_nullable_to_non_nullable
as bool,contracts: null == contracts ? _self.contracts : contracts // ignore: cast_nullable_to_non_nullable
as List<ContractQuote>,
  ));
}

}


/// Adds pattern-matching-related methods to [CommodityQuotes].
extension CommodityQuotesPatterns on CommodityQuotes {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommodityQuotes value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommodityQuotes() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommodityQuotes value)  $default,){
final _that = this;
switch (_that) {
case _CommodityQuotes():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommodityQuotes value)?  $default,){
final _that = this;
switch (_that) {
case _CommodityQuotes() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CommodityCode code,  int priceDecimals,  bool alert,  List<ContractQuote> contracts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommodityQuotes() when $default != null:
return $default(_that.code,_that.priceDecimals,_that.alert,_that.contracts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CommodityCode code,  int priceDecimals,  bool alert,  List<ContractQuote> contracts)  $default,) {final _that = this;
switch (_that) {
case _CommodityQuotes():
return $default(_that.code,_that.priceDecimals,_that.alert,_that.contracts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CommodityCode code,  int priceDecimals,  bool alert,  List<ContractQuote> contracts)?  $default,) {final _that = this;
switch (_that) {
case _CommodityQuotes() when $default != null:
return $default(_that.code,_that.priceDecimals,_that.alert,_that.contracts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommodityQuotes implements CommodityQuotes {
  const _CommodityQuotes({required this.code, required this.priceDecimals, required this.alert, required  List<ContractQuote> contracts}): _contracts = contracts;
  factory _CommodityQuotes.fromJson(Map<String, dynamic> json) => _$CommodityQuotesFromJson(json);

@override final  CommodityCode code;
@override final  int priceDecimals;
@override final  bool alert;
 final  List<ContractQuote> _contracts;
@override List<ContractQuote> get contracts {
  if (_contracts is EqualUnmodifiableListView) return _contracts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contracts);
}


/// Create a copy of CommodityQuotes
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommodityQuotesCopyWith<_CommodityQuotes> get copyWith => __$CommodityQuotesCopyWithImpl<_CommodityQuotes>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommodityQuotesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommodityQuotes&&(identical(other.code, code) || other.code == code)&&(identical(other.priceDecimals, priceDecimals) || other.priceDecimals == priceDecimals)&&(identical(other.alert, alert) || other.alert == alert)&&const DeepCollectionEquality().equals(other.contracts, _contracts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,priceDecimals,alert,const DeepCollectionEquality().hash(_contracts));
}

@override
String toString() {
    return 'CommodityQuotes(code: $code, priceDecimals: $priceDecimals, alert: $alert, contracts: $contracts)';
}


}

/// @nodoc
abstract mixin class _$CommodityQuotesCopyWith<$Res> implements $CommodityQuotesCopyWith<$Res> {
  factory _$CommodityQuotesCopyWith(_CommodityQuotes value, $Res Function(_CommodityQuotes) _then) = __$CommodityQuotesCopyWithImpl;
@override @useResult
$Res call({
 CommodityCode code, int priceDecimals, bool alert, List<ContractQuote> contracts
});




}
/// @nodoc
class __$CommodityQuotesCopyWithImpl<$Res>
    implements _$CommodityQuotesCopyWith<$Res> {
  __$CommodityQuotesCopyWithImpl(this._self, this._then);

  final _CommodityQuotes _self;
  final $Res Function(_CommodityQuotes) _then;

/// Create a copy of CommodityQuotes
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? priceDecimals = null,Object? alert = null,Object? contracts = null,}) {
  return _then(_CommodityQuotes(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as CommodityCode,priceDecimals: null == priceDecimals ? _self.priceDecimals : priceDecimals // ignore: cast_nullable_to_non_nullable
as int,alert: null == alert ? _self.alert : alert // ignore: cast_nullable_to_non_nullable
as bool,contracts: null == contracts ? _self._contracts : contracts // ignore: cast_nullable_to_non_nullable
as List<ContractQuote>,
  ));
}


}


/// @nodoc
mixin _$ContractQuote {

/// 서버 표준형(`GCZ26`).
 String get symbol;/// `YYYY-MM`.
 String get contractMonth; double? get price; double? get change; double? get changePct; bool get noTrade; bool get isFront;
/// Create a copy of ContractQuote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContractQuoteCopyWith<ContractQuote> get copyWith => _$ContractQuoteCopyWithImpl<ContractQuote>(this as ContractQuote, _$identity);

  /// Serializes this ContractQuote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ContractQuote;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContractQuote&&(identical(other.symbol, _this.symbol) || other.symbol == _this.symbol)&&(identical(other.contractMonth, _this.contractMonth) || other.contractMonth == _this.contractMonth)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.change, _this.change) || other.change == _this.change)&&(identical(other.changePct, _this.changePct) || other.changePct == _this.changePct)&&(identical(other.noTrade, _this.noTrade) || other.noTrade == _this.noTrade)&&(identical(other.isFront, _this.isFront) || other.isFront == _this.isFront));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ContractQuote;
  return Object.hash(runtimeType,_this.symbol,_this.contractMonth,_this.price,_this.change,_this.changePct,_this.noTrade,_this.isFront);
}

@override
String toString() {
  final _this = this as ContractQuote;
  return 'ContractQuote(symbol: ${_this.symbol}, contractMonth: ${_this.contractMonth}, price: ${_this.price}, change: ${_this.change}, changePct: ${_this.changePct}, noTrade: ${_this.noTrade}, isFront: ${_this.isFront})';
}


}

/// @nodoc
abstract mixin class $ContractQuoteCopyWith<$Res>  {
  factory $ContractQuoteCopyWith(ContractQuote value, $Res Function(ContractQuote) _then) = _$ContractQuoteCopyWithImpl;
@useResult
$Res call({
 String symbol, String contractMonth, double? price, double? change, double? changePct, bool noTrade, bool isFront
});




}
/// @nodoc
class _$ContractQuoteCopyWithImpl<$Res>
    implements $ContractQuoteCopyWith<$Res> {
  _$ContractQuoteCopyWithImpl(this._self, this._then);

  final ContractQuote _self;
  final $Res Function(ContractQuote) _then;

/// Create a copy of ContractQuote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? symbol = null,Object? contractMonth = null,Object? price = freezed,Object? change = freezed,Object? changePct = freezed,Object? noTrade = null,Object? isFront = null,}) {
  return _then(ContractQuote(
symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,contractMonth: null == contractMonth ? _self.contractMonth : contractMonth // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,change: freezed == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as double?,changePct: freezed == changePct ? _self.changePct : changePct // ignore: cast_nullable_to_non_nullable
as double?,noTrade: null == noTrade ? _self.noTrade : noTrade // ignore: cast_nullable_to_non_nullable
as bool,isFront: null == isFront ? _self.isFront : isFront // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ContractQuote].
extension ContractQuotePatterns on ContractQuote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContractQuote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContractQuote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContractQuote value)  $default,){
final _that = this;
switch (_that) {
case _ContractQuote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContractQuote value)?  $default,){
final _that = this;
switch (_that) {
case _ContractQuote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String symbol,  String contractMonth,  double? price,  double? change,  double? changePct,  bool noTrade,  bool isFront)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContractQuote() when $default != null:
return $default(_that.symbol,_that.contractMonth,_that.price,_that.change,_that.changePct,_that.noTrade,_that.isFront);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String symbol,  String contractMonth,  double? price,  double? change,  double? changePct,  bool noTrade,  bool isFront)  $default,) {final _that = this;
switch (_that) {
case _ContractQuote():
return $default(_that.symbol,_that.contractMonth,_that.price,_that.change,_that.changePct,_that.noTrade,_that.isFront);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String symbol,  String contractMonth,  double? price,  double? change,  double? changePct,  bool noTrade,  bool isFront)?  $default,) {final _that = this;
switch (_that) {
case _ContractQuote() when $default != null:
return $default(_that.symbol,_that.contractMonth,_that.price,_that.change,_that.changePct,_that.noTrade,_that.isFront);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContractQuote implements ContractQuote {
  const _ContractQuote({required this.symbol, required this.contractMonth, required this.price, required this.change, required this.changePct, required this.noTrade, required this.isFront});
  factory _ContractQuote.fromJson(Map<String, dynamic> json) => _$ContractQuoteFromJson(json);

/// 서버 표준형(`GCZ26`).
@override final  String symbol;
/// `YYYY-MM`.
@override final  String contractMonth;
@override final  double? price;
@override final  double? change;
@override final  double? changePct;
@override final  bool noTrade;
@override final  bool isFront;

/// Create a copy of ContractQuote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContractQuoteCopyWith<_ContractQuote> get copyWith => __$ContractQuoteCopyWithImpl<_ContractQuote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContractQuoteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContractQuote&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.contractMonth, contractMonth) || other.contractMonth == contractMonth)&&(identical(other.price, price) || other.price == price)&&(identical(other.change, change) || other.change == change)&&(identical(other.changePct, changePct) || other.changePct == changePct)&&(identical(other.noTrade, noTrade) || other.noTrade == noTrade)&&(identical(other.isFront, isFront) || other.isFront == isFront));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,symbol,contractMonth,price,change,changePct,noTrade,isFront);
}

@override
String toString() {
    return 'ContractQuote(symbol: $symbol, contractMonth: $contractMonth, price: $price, change: $change, changePct: $changePct, noTrade: $noTrade, isFront: $isFront)';
}


}

/// @nodoc
abstract mixin class _$ContractQuoteCopyWith<$Res> implements $ContractQuoteCopyWith<$Res> {
  factory _$ContractQuoteCopyWith(_ContractQuote value, $Res Function(_ContractQuote) _then) = __$ContractQuoteCopyWithImpl;
@override @useResult
$Res call({
 String symbol, String contractMonth, double? price, double? change, double? changePct, bool noTrade, bool isFront
});




}
/// @nodoc
class __$ContractQuoteCopyWithImpl<$Res>
    implements _$ContractQuoteCopyWith<$Res> {
  __$ContractQuoteCopyWithImpl(this._self, this._then);

  final _ContractQuote _self;
  final $Res Function(_ContractQuote) _then;

/// Create a copy of ContractQuote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? symbol = null,Object? contractMonth = null,Object? price = freezed,Object? change = freezed,Object? changePct = freezed,Object? noTrade = null,Object? isFront = null,}) {
  return _then(_ContractQuote(
symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,contractMonth: null == contractMonth ? _self.contractMonth : contractMonth // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,change: freezed == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as double?,changePct: freezed == changePct ? _self.changePct : changePct // ignore: cast_nullable_to_non_nullable
as double?,noTrade: null == noTrade ? _self.noTrade : noTrade // ignore: cast_nullable_to_non_nullable
as bool,isFront: null == isFront ? _self.isFront : isFront // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
