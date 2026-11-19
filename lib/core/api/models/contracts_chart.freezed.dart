// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contracts_chart.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContractsChart {

 Freshness get freshness; int get priceDecimals;/// 모든 월물이 함께 쓰는 거래일 축.
 List<String> get dates; bool get hasMore; bool get provisional; List<ContractLine> get contracts;
/// Create a copy of ContractsChart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContractsChartCopyWith<ContractsChart> get copyWith => _$ContractsChartCopyWithImpl<ContractsChart>(this as ContractsChart, _$identity);

  /// Serializes this ContractsChart to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ContractsChart;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContractsChart&&(identical(other.freshness, _this.freshness) || other.freshness == _this.freshness)&&(identical(other.priceDecimals, _this.priceDecimals) || other.priceDecimals == _this.priceDecimals)&&const DeepCollectionEquality().equals(other.dates, _this.dates)&&(identical(other.hasMore, _this.hasMore) || other.hasMore == _this.hasMore)&&(identical(other.provisional, _this.provisional) || other.provisional == _this.provisional)&&const DeepCollectionEquality().equals(other.contracts, _this.contracts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ContractsChart;
  return Object.hash(runtimeType,_this.freshness,_this.priceDecimals,const DeepCollectionEquality().hash(_this.dates),_this.hasMore,_this.provisional,const DeepCollectionEquality().hash(_this.contracts));
}

@override
String toString() {
  final _this = this as ContractsChart;
  return 'ContractsChart(freshness: ${_this.freshness}, priceDecimals: ${_this.priceDecimals}, dates: ${_this.dates}, hasMore: ${_this.hasMore}, provisional: ${_this.provisional}, contracts: ${_this.contracts})';
}


}

/// @nodoc
abstract mixin class $ContractsChartCopyWith<$Res>  {
  factory $ContractsChartCopyWith(ContractsChart value, $Res Function(ContractsChart) _then) = _$ContractsChartCopyWithImpl;
@useResult
$Res call({
 Freshness freshness, int priceDecimals, List<String> dates, bool hasMore, bool provisional, List<ContractLine> contracts
});


$FreshnessCopyWith<$Res> get freshness;

}
/// @nodoc
class _$ContractsChartCopyWithImpl<$Res>
    implements $ContractsChartCopyWith<$Res> {
  _$ContractsChartCopyWithImpl(this._self, this._then);

  final ContractsChart _self;
  final $Res Function(ContractsChart) _then;

/// Create a copy of ContractsChart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? freshness = null,Object? priceDecimals = null,Object? dates = null,Object? hasMore = null,Object? provisional = null,Object? contracts = null,}) {
  return _then(ContractsChart(
freshness: null == freshness ? _self.freshness : freshness // ignore: cast_nullable_to_non_nullable
as Freshness,priceDecimals: null == priceDecimals ? _self.priceDecimals : priceDecimals // ignore: cast_nullable_to_non_nullable
as int,dates: null == dates ? _self.dates : dates // ignore: cast_nullable_to_non_nullable
as List<String>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,provisional: null == provisional ? _self.provisional : provisional // ignore: cast_nullable_to_non_nullable
as bool,contracts: null == contracts ? _self.contracts : contracts // ignore: cast_nullable_to_non_nullable
as List<ContractLine>,
  ));
}
/// Create a copy of ContractsChart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FreshnessCopyWith<$Res> get freshness {
  
  return $FreshnessCopyWith<$Res>(_self.freshness, (value) {
    return _then(_self.copyWith(freshness: value));
  });
}
}


/// Adds pattern-matching-related methods to [ContractsChart].
extension ContractsChartPatterns on ContractsChart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContractsChart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContractsChart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContractsChart value)  $default,){
final _that = this;
switch (_that) {
case _ContractsChart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContractsChart value)?  $default,){
final _that = this;
switch (_that) {
case _ContractsChart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Freshness freshness,  int priceDecimals,  List<String> dates,  bool hasMore,  bool provisional,  List<ContractLine> contracts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContractsChart() when $default != null:
return $default(_that.freshness,_that.priceDecimals,_that.dates,_that.hasMore,_that.provisional,_that.contracts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Freshness freshness,  int priceDecimals,  List<String> dates,  bool hasMore,  bool provisional,  List<ContractLine> contracts)  $default,) {final _that = this;
switch (_that) {
case _ContractsChart():
return $default(_that.freshness,_that.priceDecimals,_that.dates,_that.hasMore,_that.provisional,_that.contracts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Freshness freshness,  int priceDecimals,  List<String> dates,  bool hasMore,  bool provisional,  List<ContractLine> contracts)?  $default,) {final _that = this;
switch (_that) {
case _ContractsChart() when $default != null:
return $default(_that.freshness,_that.priceDecimals,_that.dates,_that.hasMore,_that.provisional,_that.contracts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContractsChart implements ContractsChart {
  const _ContractsChart({required this.freshness, required this.priceDecimals, required  List<String> dates, required this.hasMore, required this.provisional, required  List<ContractLine> contracts}): _dates = dates,_contracts = contracts;
  factory _ContractsChart.fromJson(Map<String, dynamic> json) => _$ContractsChartFromJson(json);

@override final  Freshness freshness;
@override final  int priceDecimals;
/// 모든 월물이 함께 쓰는 거래일 축.
 final  List<String> _dates;
/// 모든 월물이 함께 쓰는 거래일 축.
@override List<String> get dates {
  if (_dates is EqualUnmodifiableListView) return _dates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dates);
}

@override final  bool hasMore;
@override final  bool provisional;
 final  List<ContractLine> _contracts;
@override List<ContractLine> get contracts {
  if (_contracts is EqualUnmodifiableListView) return _contracts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contracts);
}


/// Create a copy of ContractsChart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContractsChartCopyWith<_ContractsChart> get copyWith => __$ContractsChartCopyWithImpl<_ContractsChart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContractsChartToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContractsChart&&(identical(other.freshness, freshness) || other.freshness == freshness)&&(identical(other.priceDecimals, priceDecimals) || other.priceDecimals == priceDecimals)&&const DeepCollectionEquality().equals(other.dates, _dates)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.provisional, provisional) || other.provisional == provisional)&&const DeepCollectionEquality().equals(other.contracts, _contracts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,freshness,priceDecimals,const DeepCollectionEquality().hash(_dates),hasMore,provisional,const DeepCollectionEquality().hash(_contracts));
}

@override
String toString() {
    return 'ContractsChart(freshness: $freshness, priceDecimals: $priceDecimals, dates: $dates, hasMore: $hasMore, provisional: $provisional, contracts: $contracts)';
}


}

/// @nodoc
abstract mixin class _$ContractsChartCopyWith<$Res> implements $ContractsChartCopyWith<$Res> {
  factory _$ContractsChartCopyWith(_ContractsChart value, $Res Function(_ContractsChart) _then) = __$ContractsChartCopyWithImpl;
@override @useResult
$Res call({
 Freshness freshness, int priceDecimals, List<String> dates, bool hasMore, bool provisional, List<ContractLine> contracts
});


@override $FreshnessCopyWith<$Res> get freshness;

}
/// @nodoc
class __$ContractsChartCopyWithImpl<$Res>
    implements _$ContractsChartCopyWith<$Res> {
  __$ContractsChartCopyWithImpl(this._self, this._then);

  final _ContractsChart _self;
  final $Res Function(_ContractsChart) _then;

/// Create a copy of ContractsChart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? freshness = null,Object? priceDecimals = null,Object? dates = null,Object? hasMore = null,Object? provisional = null,Object? contracts = null,}) {
  return _then(_ContractsChart(
freshness: null == freshness ? _self.freshness : freshness // ignore: cast_nullable_to_non_nullable
as Freshness,priceDecimals: null == priceDecimals ? _self.priceDecimals : priceDecimals // ignore: cast_nullable_to_non_nullable
as int,dates: null == dates ? _self._dates : dates // ignore: cast_nullable_to_non_nullable
as List<String>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,provisional: null == provisional ? _self.provisional : provisional // ignore: cast_nullable_to_non_nullable
as bool,contracts: null == contracts ? _self._contracts : contracts // ignore: cast_nullable_to_non_nullable
as List<ContractLine>,
  ));
}

/// Create a copy of ContractsChart
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
mixin _$ContractLine {

 String get symbol; String get contractMonth; String get lastTradeDate; bool get isFront;/// [ContractsChart.dates]와 같은 길이. 상장 전은 null.
 List<double?> get prices;
/// Create a copy of ContractLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContractLineCopyWith<ContractLine> get copyWith => _$ContractLineCopyWithImpl<ContractLine>(this as ContractLine, _$identity);

  /// Serializes this ContractLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ContractLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContractLine&&(identical(other.symbol, _this.symbol) || other.symbol == _this.symbol)&&(identical(other.contractMonth, _this.contractMonth) || other.contractMonth == _this.contractMonth)&&(identical(other.lastTradeDate, _this.lastTradeDate) || other.lastTradeDate == _this.lastTradeDate)&&(identical(other.isFront, _this.isFront) || other.isFront == _this.isFront)&&const DeepCollectionEquality().equals(other.prices, _this.prices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ContractLine;
  return Object.hash(runtimeType,_this.symbol,_this.contractMonth,_this.lastTradeDate,_this.isFront,const DeepCollectionEquality().hash(_this.prices));
}

@override
String toString() {
  final _this = this as ContractLine;
  return 'ContractLine(symbol: ${_this.symbol}, contractMonth: ${_this.contractMonth}, lastTradeDate: ${_this.lastTradeDate}, isFront: ${_this.isFront}, prices: ${_this.prices})';
}


}

/// @nodoc
abstract mixin class $ContractLineCopyWith<$Res>  {
  factory $ContractLineCopyWith(ContractLine value, $Res Function(ContractLine) _then) = _$ContractLineCopyWithImpl;
@useResult
$Res call({
 String symbol, String contractMonth, String lastTradeDate, bool isFront, List<double?> prices
});




}
/// @nodoc
class _$ContractLineCopyWithImpl<$Res>
    implements $ContractLineCopyWith<$Res> {
  _$ContractLineCopyWithImpl(this._self, this._then);

  final ContractLine _self;
  final $Res Function(ContractLine) _then;

/// Create a copy of ContractLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? symbol = null,Object? contractMonth = null,Object? lastTradeDate = null,Object? isFront = null,Object? prices = null,}) {
  return _then(ContractLine(
symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,contractMonth: null == contractMonth ? _self.contractMonth : contractMonth // ignore: cast_nullable_to_non_nullable
as String,lastTradeDate: null == lastTradeDate ? _self.lastTradeDate : lastTradeDate // ignore: cast_nullable_to_non_nullable
as String,isFront: null == isFront ? _self.isFront : isFront // ignore: cast_nullable_to_non_nullable
as bool,prices: null == prices ? _self.prices : prices // ignore: cast_nullable_to_non_nullable
as List<double?>,
  ));
}

}


/// Adds pattern-matching-related methods to [ContractLine].
extension ContractLinePatterns on ContractLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContractLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContractLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContractLine value)  $default,){
final _that = this;
switch (_that) {
case _ContractLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContractLine value)?  $default,){
final _that = this;
switch (_that) {
case _ContractLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String symbol,  String contractMonth,  String lastTradeDate,  bool isFront,  List<double?> prices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContractLine() when $default != null:
return $default(_that.symbol,_that.contractMonth,_that.lastTradeDate,_that.isFront,_that.prices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String symbol,  String contractMonth,  String lastTradeDate,  bool isFront,  List<double?> prices)  $default,) {final _that = this;
switch (_that) {
case _ContractLine():
return $default(_that.symbol,_that.contractMonth,_that.lastTradeDate,_that.isFront,_that.prices);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String symbol,  String contractMonth,  String lastTradeDate,  bool isFront,  List<double?> prices)?  $default,) {final _that = this;
switch (_that) {
case _ContractLine() when $default != null:
return $default(_that.symbol,_that.contractMonth,_that.lastTradeDate,_that.isFront,_that.prices);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContractLine implements ContractLine {
  const _ContractLine({required this.symbol, required this.contractMonth, required this.lastTradeDate, required this.isFront, required  List<double?> prices}): _prices = prices;
  factory _ContractLine.fromJson(Map<String, dynamic> json) => _$ContractLineFromJson(json);

@override final  String symbol;
@override final  String contractMonth;
@override final  String lastTradeDate;
@override final  bool isFront;
/// [ContractsChart.dates]와 같은 길이. 상장 전은 null.
 final  List<double?> _prices;
/// [ContractsChart.dates]와 같은 길이. 상장 전은 null.
@override List<double?> get prices {
  if (_prices is EqualUnmodifiableListView) return _prices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_prices);
}


/// Create a copy of ContractLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContractLineCopyWith<_ContractLine> get copyWith => __$ContractLineCopyWithImpl<_ContractLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContractLineToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContractLine&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.contractMonth, contractMonth) || other.contractMonth == contractMonth)&&(identical(other.lastTradeDate, lastTradeDate) || other.lastTradeDate == lastTradeDate)&&(identical(other.isFront, isFront) || other.isFront == isFront)&&const DeepCollectionEquality().equals(other.prices, _prices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,symbol,contractMonth,lastTradeDate,isFront,const DeepCollectionEquality().hash(_prices));
}

@override
String toString() {
    return 'ContractLine(symbol: $symbol, contractMonth: $contractMonth, lastTradeDate: $lastTradeDate, isFront: $isFront, prices: $prices)';
}


}

/// @nodoc
abstract mixin class _$ContractLineCopyWith<$Res> implements $ContractLineCopyWith<$Res> {
  factory _$ContractLineCopyWith(_ContractLine value, $Res Function(_ContractLine) _then) = __$ContractLineCopyWithImpl;
@override @useResult
$Res call({
 String symbol, String contractMonth, String lastTradeDate, bool isFront, List<double?> prices
});




}
/// @nodoc
class __$ContractLineCopyWithImpl<$Res>
    implements _$ContractLineCopyWith<$Res> {
  __$ContractLineCopyWithImpl(this._self, this._then);

  final _ContractLine _self;
  final $Res Function(_ContractLine) _then;

/// Create a copy of ContractLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? symbol = null,Object? contractMonth = null,Object? lastTradeDate = null,Object? isFront = null,Object? prices = null,}) {
  return _then(_ContractLine(
symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,contractMonth: null == contractMonth ? _self.contractMonth : contractMonth // ignore: cast_nullable_to_non_nullable
as String,lastTradeDate: null == lastTradeDate ? _self.lastTradeDate : lastTradeDate // ignore: cast_nullable_to_non_nullable
as String,isFront: null == isFront ? _self.isFront : isFront // ignore: cast_nullable_to_non_nullable
as bool,prices: null == prices ? _self._prices : prices // ignore: cast_nullable_to_non_nullable
as List<double?>,
  ));
}


}

// dart format on
