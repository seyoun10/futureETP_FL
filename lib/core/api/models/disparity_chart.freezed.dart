// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'disparity_chart.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DisparityChart {

 Freshness get freshness; int get priceDecimals; Basis get basis;/// 요청 기준 지수가 없어 대체했는지.
 bool get fallback; MaPeriod get maPeriod; DistributionWindow get window; DisparityDistribution? get distribution; List<RareLevel> get rareLevels; CurrentTail? get currentTail;/// 마지막 봉이 오늘 잠정 값인지.
 bool get provisional; List<DisparityBar> get bars;/// 이전 3년을 더 받을 수 있는지(D-104).
 bool get hasMore;
/// Create a copy of DisparityChart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DisparityChartCopyWith<DisparityChart> get copyWith => _$DisparityChartCopyWithImpl<DisparityChart>(this as DisparityChart, _$identity);

  /// Serializes this DisparityChart to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DisparityChart;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisparityChart&&(identical(other.freshness, _this.freshness) || other.freshness == _this.freshness)&&(identical(other.priceDecimals, _this.priceDecimals) || other.priceDecimals == _this.priceDecimals)&&(identical(other.basis, _this.basis) || other.basis == _this.basis)&&(identical(other.fallback, _this.fallback) || other.fallback == _this.fallback)&&(identical(other.maPeriod, _this.maPeriod) || other.maPeriod == _this.maPeriod)&&(identical(other.window, _this.window) || other.window == _this.window)&&(identical(other.distribution, _this.distribution) || other.distribution == _this.distribution)&&const DeepCollectionEquality().equals(other.rareLevels, _this.rareLevels)&&(identical(other.currentTail, _this.currentTail) || other.currentTail == _this.currentTail)&&(identical(other.provisional, _this.provisional) || other.provisional == _this.provisional)&&const DeepCollectionEquality().equals(other.bars, _this.bars)&&(identical(other.hasMore, _this.hasMore) || other.hasMore == _this.hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DisparityChart;
  return Object.hash(runtimeType,_this.freshness,_this.priceDecimals,_this.basis,_this.fallback,_this.maPeriod,_this.window,_this.distribution,const DeepCollectionEquality().hash(_this.rareLevels),_this.currentTail,_this.provisional,const DeepCollectionEquality().hash(_this.bars),_this.hasMore);
}

@override
String toString() {
  final _this = this as DisparityChart;
  return 'DisparityChart(freshness: ${_this.freshness}, priceDecimals: ${_this.priceDecimals}, basis: ${_this.basis}, fallback: ${_this.fallback}, maPeriod: ${_this.maPeriod}, window: ${_this.window}, distribution: ${_this.distribution}, rareLevels: ${_this.rareLevels}, currentTail: ${_this.currentTail}, provisional: ${_this.provisional}, bars: ${_this.bars}, hasMore: ${_this.hasMore})';
}


}

/// @nodoc
abstract mixin class $DisparityChartCopyWith<$Res>  {
  factory $DisparityChartCopyWith(DisparityChart value, $Res Function(DisparityChart) _then) = _$DisparityChartCopyWithImpl;
@useResult
$Res call({
 Freshness freshness, int priceDecimals, Basis basis, bool fallback, MaPeriod maPeriod, DistributionWindow window, DisparityDistribution? distribution, List<RareLevel> rareLevels, CurrentTail? currentTail, bool provisional, List<DisparityBar> bars, bool hasMore
});


$FreshnessCopyWith<$Res> get freshness;$DisparityDistributionCopyWith<$Res>? get distribution;$CurrentTailCopyWith<$Res>? get currentTail;

}
/// @nodoc
class _$DisparityChartCopyWithImpl<$Res>
    implements $DisparityChartCopyWith<$Res> {
  _$DisparityChartCopyWithImpl(this._self, this._then);

  final DisparityChart _self;
  final $Res Function(DisparityChart) _then;

/// Create a copy of DisparityChart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? freshness = null,Object? priceDecimals = null,Object? basis = null,Object? fallback = null,Object? maPeriod = null,Object? window = null,Object? distribution = freezed,Object? rareLevels = null,Object? currentTail = freezed,Object? provisional = null,Object? bars = null,Object? hasMore = null,}) {
  return _then(DisparityChart(
freshness: null == freshness ? _self.freshness : freshness // ignore: cast_nullable_to_non_nullable
as Freshness,priceDecimals: null == priceDecimals ? _self.priceDecimals : priceDecimals // ignore: cast_nullable_to_non_nullable
as int,basis: null == basis ? _self.basis : basis // ignore: cast_nullable_to_non_nullable
as Basis,fallback: null == fallback ? _self.fallback : fallback // ignore: cast_nullable_to_non_nullable
as bool,maPeriod: null == maPeriod ? _self.maPeriod : maPeriod // ignore: cast_nullable_to_non_nullable
as MaPeriod,window: null == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as DistributionWindow,distribution: freezed == distribution ? _self.distribution : distribution // ignore: cast_nullable_to_non_nullable
as DisparityDistribution?,rareLevels: null == rareLevels ? _self.rareLevels : rareLevels // ignore: cast_nullable_to_non_nullable
as List<RareLevel>,currentTail: freezed == currentTail ? _self.currentTail : currentTail // ignore: cast_nullable_to_non_nullable
as CurrentTail?,provisional: null == provisional ? _self.provisional : provisional // ignore: cast_nullable_to_non_nullable
as bool,bars: null == bars ? _self.bars : bars // ignore: cast_nullable_to_non_nullable
as List<DisparityBar>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of DisparityChart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FreshnessCopyWith<$Res> get freshness {
  
  return $FreshnessCopyWith<$Res>(_self.freshness, (value) {
    return _then(_self.copyWith(freshness: value));
  });
}/// Create a copy of DisparityChart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DisparityDistributionCopyWith<$Res>? get distribution {
    if (_self.distribution == null) {
    return null;
  }

  return $DisparityDistributionCopyWith<$Res>(_self.distribution!, (value) {
    return _then(_self.copyWith(distribution: value));
  });
}/// Create a copy of DisparityChart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentTailCopyWith<$Res>? get currentTail {
    if (_self.currentTail == null) {
    return null;
  }

  return $CurrentTailCopyWith<$Res>(_self.currentTail!, (value) {
    return _then(_self.copyWith(currentTail: value));
  });
}
}


/// Adds pattern-matching-related methods to [DisparityChart].
extension DisparityChartPatterns on DisparityChart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DisparityChart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DisparityChart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DisparityChart value)  $default,){
final _that = this;
switch (_that) {
case _DisparityChart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DisparityChart value)?  $default,){
final _that = this;
switch (_that) {
case _DisparityChart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Freshness freshness,  int priceDecimals,  Basis basis,  bool fallback,  MaPeriod maPeriod,  DistributionWindow window,  DisparityDistribution? distribution,  List<RareLevel> rareLevels,  CurrentTail? currentTail,  bool provisional,  List<DisparityBar> bars,  bool hasMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DisparityChart() when $default != null:
return $default(_that.freshness,_that.priceDecimals,_that.basis,_that.fallback,_that.maPeriod,_that.window,_that.distribution,_that.rareLevels,_that.currentTail,_that.provisional,_that.bars,_that.hasMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Freshness freshness,  int priceDecimals,  Basis basis,  bool fallback,  MaPeriod maPeriod,  DistributionWindow window,  DisparityDistribution? distribution,  List<RareLevel> rareLevels,  CurrentTail? currentTail,  bool provisional,  List<DisparityBar> bars,  bool hasMore)  $default,) {final _that = this;
switch (_that) {
case _DisparityChart():
return $default(_that.freshness,_that.priceDecimals,_that.basis,_that.fallback,_that.maPeriod,_that.window,_that.distribution,_that.rareLevels,_that.currentTail,_that.provisional,_that.bars,_that.hasMore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Freshness freshness,  int priceDecimals,  Basis basis,  bool fallback,  MaPeriod maPeriod,  DistributionWindow window,  DisparityDistribution? distribution,  List<RareLevel> rareLevels,  CurrentTail? currentTail,  bool provisional,  List<DisparityBar> bars,  bool hasMore)?  $default,) {final _that = this;
switch (_that) {
case _DisparityChart() when $default != null:
return $default(_that.freshness,_that.priceDecimals,_that.basis,_that.fallback,_that.maPeriod,_that.window,_that.distribution,_that.rareLevels,_that.currentTail,_that.provisional,_that.bars,_that.hasMore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DisparityChart implements DisparityChart {
  const _DisparityChart({required this.freshness, required this.priceDecimals, required this.basis, required this.fallback, required this.maPeriod, required this.window, required this.distribution, required  List<RareLevel> rareLevels, required this.currentTail, required this.provisional, required  List<DisparityBar> bars, required this.hasMore}): _rareLevels = rareLevels,_bars = bars;
  factory _DisparityChart.fromJson(Map<String, dynamic> json) => _$DisparityChartFromJson(json);

@override final  Freshness freshness;
@override final  int priceDecimals;
@override final  Basis basis;
/// 요청 기준 지수가 없어 대체했는지.
@override final  bool fallback;
@override final  MaPeriod maPeriod;
@override final  DistributionWindow window;
@override final  DisparityDistribution? distribution;
 final  List<RareLevel> _rareLevels;
@override List<RareLevel> get rareLevels {
  if (_rareLevels is EqualUnmodifiableListView) return _rareLevels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rareLevels);
}

@override final  CurrentTail? currentTail;
/// 마지막 봉이 오늘 잠정 값인지.
@override final  bool provisional;
 final  List<DisparityBar> _bars;
@override List<DisparityBar> get bars {
  if (_bars is EqualUnmodifiableListView) return _bars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bars);
}

/// 이전 3년을 더 받을 수 있는지(D-104).
@override final  bool hasMore;

/// Create a copy of DisparityChart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DisparityChartCopyWith<_DisparityChart> get copyWith => __$DisparityChartCopyWithImpl<_DisparityChart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DisparityChartToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DisparityChart&&(identical(other.freshness, freshness) || other.freshness == freshness)&&(identical(other.priceDecimals, priceDecimals) || other.priceDecimals == priceDecimals)&&(identical(other.basis, basis) || other.basis == basis)&&(identical(other.fallback, fallback) || other.fallback == fallback)&&(identical(other.maPeriod, maPeriod) || other.maPeriod == maPeriod)&&(identical(other.window, window) || other.window == window)&&(identical(other.distribution, distribution) || other.distribution == distribution)&&const DeepCollectionEquality().equals(other.rareLevels, _rareLevels)&&(identical(other.currentTail, currentTail) || other.currentTail == currentTail)&&(identical(other.provisional, provisional) || other.provisional == provisional)&&const DeepCollectionEquality().equals(other.bars, _bars)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,freshness,priceDecimals,basis,fallback,maPeriod,window,distribution,const DeepCollectionEquality().hash(_rareLevels),currentTail,provisional,const DeepCollectionEquality().hash(_bars),hasMore);
}

@override
String toString() {
    return 'DisparityChart(freshness: $freshness, priceDecimals: $priceDecimals, basis: $basis, fallback: $fallback, maPeriod: $maPeriod, window: $window, distribution: $distribution, rareLevels: $rareLevels, currentTail: $currentTail, provisional: $provisional, bars: $bars, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$DisparityChartCopyWith<$Res> implements $DisparityChartCopyWith<$Res> {
  factory _$DisparityChartCopyWith(_DisparityChart value, $Res Function(_DisparityChart) _then) = __$DisparityChartCopyWithImpl;
@override @useResult
$Res call({
 Freshness freshness, int priceDecimals, Basis basis, bool fallback, MaPeriod maPeriod, DistributionWindow window, DisparityDistribution? distribution, List<RareLevel> rareLevels, CurrentTail? currentTail, bool provisional, List<DisparityBar> bars, bool hasMore
});


@override $FreshnessCopyWith<$Res> get freshness;@override $DisparityDistributionCopyWith<$Res>? get distribution;@override $CurrentTailCopyWith<$Res>? get currentTail;

}
/// @nodoc
class __$DisparityChartCopyWithImpl<$Res>
    implements _$DisparityChartCopyWith<$Res> {
  __$DisparityChartCopyWithImpl(this._self, this._then);

  final _DisparityChart _self;
  final $Res Function(_DisparityChart) _then;

/// Create a copy of DisparityChart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? freshness = null,Object? priceDecimals = null,Object? basis = null,Object? fallback = null,Object? maPeriod = null,Object? window = null,Object? distribution = freezed,Object? rareLevels = null,Object? currentTail = freezed,Object? provisional = null,Object? bars = null,Object? hasMore = null,}) {
  return _then(_DisparityChart(
freshness: null == freshness ? _self.freshness : freshness // ignore: cast_nullable_to_non_nullable
as Freshness,priceDecimals: null == priceDecimals ? _self.priceDecimals : priceDecimals // ignore: cast_nullable_to_non_nullable
as int,basis: null == basis ? _self.basis : basis // ignore: cast_nullable_to_non_nullable
as Basis,fallback: null == fallback ? _self.fallback : fallback // ignore: cast_nullable_to_non_nullable
as bool,maPeriod: null == maPeriod ? _self.maPeriod : maPeriod // ignore: cast_nullable_to_non_nullable
as MaPeriod,window: null == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as DistributionWindow,distribution: freezed == distribution ? _self.distribution : distribution // ignore: cast_nullable_to_non_nullable
as DisparityDistribution?,rareLevels: null == rareLevels ? _self._rareLevels : rareLevels // ignore: cast_nullable_to_non_nullable
as List<RareLevel>,currentTail: freezed == currentTail ? _self.currentTail : currentTail // ignore: cast_nullable_to_non_nullable
as CurrentTail?,provisional: null == provisional ? _self.provisional : provisional // ignore: cast_nullable_to_non_nullable
as bool,bars: null == bars ? _self._bars : bars // ignore: cast_nullable_to_non_nullable
as List<DisparityBar>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of DisparityChart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FreshnessCopyWith<$Res> get freshness {
  
  return $FreshnessCopyWith<$Res>(_self.freshness, (value) {
    return _then(_self.copyWith(freshness: value));
  });
}/// Create a copy of DisparityChart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DisparityDistributionCopyWith<$Res>? get distribution {
    if (_self.distribution == null) {
    return null;
  }

  return $DisparityDistributionCopyWith<$Res>(_self.distribution!, (value) {
    return _then(_self.copyWith(distribution: value));
  });
}/// Create a copy of DisparityChart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentTailCopyWith<$Res>? get currentTail {
    if (_self.currentTail == null) {
    return null;
  }

  return $CurrentTailCopyWith<$Res>(_self.currentTail!, (value) {
    return _then(_self.copyWith(currentTail: value));
  });
}
}


/// @nodoc
mixin _$DisparityDistribution {

 String get actualStartDate; int get sampleCount;
/// Create a copy of DisparityDistribution
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DisparityDistributionCopyWith<DisparityDistribution> get copyWith => _$DisparityDistributionCopyWithImpl<DisparityDistribution>(this as DisparityDistribution, _$identity);

  /// Serializes this DisparityDistribution to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DisparityDistribution;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisparityDistribution&&(identical(other.actualStartDate, _this.actualStartDate) || other.actualStartDate == _this.actualStartDate)&&(identical(other.sampleCount, _this.sampleCount) || other.sampleCount == _this.sampleCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DisparityDistribution;
  return Object.hash(runtimeType,_this.actualStartDate,_this.sampleCount);
}

@override
String toString() {
  final _this = this as DisparityDistribution;
  return 'DisparityDistribution(actualStartDate: ${_this.actualStartDate}, sampleCount: ${_this.sampleCount})';
}


}

/// @nodoc
abstract mixin class $DisparityDistributionCopyWith<$Res>  {
  factory $DisparityDistributionCopyWith(DisparityDistribution value, $Res Function(DisparityDistribution) _then) = _$DisparityDistributionCopyWithImpl;
@useResult
$Res call({
 String actualStartDate, int sampleCount
});




}
/// @nodoc
class _$DisparityDistributionCopyWithImpl<$Res>
    implements $DisparityDistributionCopyWith<$Res> {
  _$DisparityDistributionCopyWithImpl(this._self, this._then);

  final DisparityDistribution _self;
  final $Res Function(DisparityDistribution) _then;

/// Create a copy of DisparityDistribution
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actualStartDate = null,Object? sampleCount = null,}) {
  return _then(DisparityDistribution(
actualStartDate: null == actualStartDate ? _self.actualStartDate : actualStartDate // ignore: cast_nullable_to_non_nullable
as String,sampleCount: null == sampleCount ? _self.sampleCount : sampleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DisparityDistribution].
extension DisparityDistributionPatterns on DisparityDistribution {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DisparityDistribution value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DisparityDistribution() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DisparityDistribution value)  $default,){
final _that = this;
switch (_that) {
case _DisparityDistribution():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DisparityDistribution value)?  $default,){
final _that = this;
switch (_that) {
case _DisparityDistribution() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String actualStartDate,  int sampleCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DisparityDistribution() when $default != null:
return $default(_that.actualStartDate,_that.sampleCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String actualStartDate,  int sampleCount)  $default,) {final _that = this;
switch (_that) {
case _DisparityDistribution():
return $default(_that.actualStartDate,_that.sampleCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String actualStartDate,  int sampleCount)?  $default,) {final _that = this;
switch (_that) {
case _DisparityDistribution() when $default != null:
return $default(_that.actualStartDate,_that.sampleCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DisparityDistribution implements DisparityDistribution {
  const _DisparityDistribution({required this.actualStartDate, required this.sampleCount});
  factory _DisparityDistribution.fromJson(Map<String, dynamic> json) => _$DisparityDistributionFromJson(json);

@override final  String actualStartDate;
@override final  int sampleCount;

/// Create a copy of DisparityDistribution
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DisparityDistributionCopyWith<_DisparityDistribution> get copyWith => __$DisparityDistributionCopyWithImpl<_DisparityDistribution>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DisparityDistributionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DisparityDistribution&&(identical(other.actualStartDate, actualStartDate) || other.actualStartDate == actualStartDate)&&(identical(other.sampleCount, sampleCount) || other.sampleCount == sampleCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,actualStartDate,sampleCount);
}

@override
String toString() {
    return 'DisparityDistribution(actualStartDate: $actualStartDate, sampleCount: $sampleCount)';
}


}

/// @nodoc
abstract mixin class _$DisparityDistributionCopyWith<$Res> implements $DisparityDistributionCopyWith<$Res> {
  factory _$DisparityDistributionCopyWith(_DisparityDistribution value, $Res Function(_DisparityDistribution) _then) = __$DisparityDistributionCopyWithImpl;
@override @useResult
$Res call({
 String actualStartDate, int sampleCount
});




}
/// @nodoc
class __$DisparityDistributionCopyWithImpl<$Res>
    implements _$DisparityDistributionCopyWith<$Res> {
  __$DisparityDistributionCopyWithImpl(this._self, this._then);

  final _DisparityDistribution _self;
  final $Res Function(_DisparityDistribution) _then;

/// Create a copy of DisparityDistribution
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actualStartDate = null,Object? sampleCount = null,}) {
  return _then(_DisparityDistribution(
actualStartDate: null == actualStartDate ? _self.actualStartDate : actualStartDate // ignore: cast_nullable_to_non_nullable
as String,sampleCount: null == sampleCount ? _self.sampleCount : sampleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$RareLevel {

 Direction get direction;/// 꼬리 백분율(설정의 rareLevels 값).
 double get level; double get disparity; double? get price;
/// Create a copy of RareLevel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RareLevelCopyWith<RareLevel> get copyWith => _$RareLevelCopyWithImpl<RareLevel>(this as RareLevel, _$identity);

  /// Serializes this RareLevel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RareLevel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RareLevel&&(identical(other.direction, _this.direction) || other.direction == _this.direction)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.disparity, _this.disparity) || other.disparity == _this.disparity)&&(identical(other.price, _this.price) || other.price == _this.price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RareLevel;
  return Object.hash(runtimeType,_this.direction,_this.level,_this.disparity,_this.price);
}

@override
String toString() {
  final _this = this as RareLevel;
  return 'RareLevel(direction: ${_this.direction}, level: ${_this.level}, disparity: ${_this.disparity}, price: ${_this.price})';
}


}

/// @nodoc
abstract mixin class $RareLevelCopyWith<$Res>  {
  factory $RareLevelCopyWith(RareLevel value, $Res Function(RareLevel) _then) = _$RareLevelCopyWithImpl;
@useResult
$Res call({
 Direction direction, double level, double disparity, double? price
});




}
/// @nodoc
class _$RareLevelCopyWithImpl<$Res>
    implements $RareLevelCopyWith<$Res> {
  _$RareLevelCopyWithImpl(this._self, this._then);

  final RareLevel _self;
  final $Res Function(RareLevel) _then;

/// Create a copy of RareLevel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? direction = null,Object? level = null,Object? disparity = null,Object? price = freezed,}) {
  return _then(RareLevel(
direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as Direction,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as double,disparity: null == disparity ? _self.disparity : disparity // ignore: cast_nullable_to_non_nullable
as double,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [RareLevel].
extension RareLevelPatterns on RareLevel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RareLevel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RareLevel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RareLevel value)  $default,){
final _that = this;
switch (_that) {
case _RareLevel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RareLevel value)?  $default,){
final _that = this;
switch (_that) {
case _RareLevel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Direction direction,  double level,  double disparity,  double? price)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RareLevel() when $default != null:
return $default(_that.direction,_that.level,_that.disparity,_that.price);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Direction direction,  double level,  double disparity,  double? price)  $default,) {final _that = this;
switch (_that) {
case _RareLevel():
return $default(_that.direction,_that.level,_that.disparity,_that.price);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Direction direction,  double level,  double disparity,  double? price)?  $default,) {final _that = this;
switch (_that) {
case _RareLevel() when $default != null:
return $default(_that.direction,_that.level,_that.disparity,_that.price);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RareLevel implements RareLevel {
  const _RareLevel({required this.direction, required this.level, required this.disparity, required this.price});
  factory _RareLevel.fromJson(Map<String, dynamic> json) => _$RareLevelFromJson(json);

@override final  Direction direction;
/// 꼬리 백분율(설정의 rareLevels 값).
@override final  double level;
@override final  double disparity;
@override final  double? price;

/// Create a copy of RareLevel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RareLevelCopyWith<_RareLevel> get copyWith => __$RareLevelCopyWithImpl<_RareLevel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RareLevelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RareLevel&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.level, level) || other.level == level)&&(identical(other.disparity, disparity) || other.disparity == disparity)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,direction,level,disparity,price);
}

@override
String toString() {
    return 'RareLevel(direction: $direction, level: $level, disparity: $disparity, price: $price)';
}


}

/// @nodoc
abstract mixin class _$RareLevelCopyWith<$Res> implements $RareLevelCopyWith<$Res> {
  factory _$RareLevelCopyWith(_RareLevel value, $Res Function(_RareLevel) _then) = __$RareLevelCopyWithImpl;
@override @useResult
$Res call({
 Direction direction, double level, double disparity, double? price
});




}
/// @nodoc
class __$RareLevelCopyWithImpl<$Res>
    implements _$RareLevelCopyWith<$Res> {
  __$RareLevelCopyWithImpl(this._self, this._then);

  final _RareLevel _self;
  final $Res Function(_RareLevel) _then;

/// Create a copy of RareLevel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? direction = null,Object? level = null,Object? disparity = null,Object? price = freezed,}) {
  return _then(_RareLevel(
direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as Direction,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as double,disparity: null == disparity ? _self.disparity : disparity // ignore: cast_nullable_to_non_nullable
as double,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$CurrentTail {

 Direction get side; double get pct;
/// Create a copy of CurrentTail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrentTailCopyWith<CurrentTail> get copyWith => _$CurrentTailCopyWithImpl<CurrentTail>(this as CurrentTail, _$identity);

  /// Serializes this CurrentTail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CurrentTail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrentTail&&(identical(other.side, _this.side) || other.side == _this.side)&&(identical(other.pct, _this.pct) || other.pct == _this.pct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CurrentTail;
  return Object.hash(runtimeType,_this.side,_this.pct);
}

@override
String toString() {
  final _this = this as CurrentTail;
  return 'CurrentTail(side: ${_this.side}, pct: ${_this.pct})';
}


}

/// @nodoc
abstract mixin class $CurrentTailCopyWith<$Res>  {
  factory $CurrentTailCopyWith(CurrentTail value, $Res Function(CurrentTail) _then) = _$CurrentTailCopyWithImpl;
@useResult
$Res call({
 Direction side, double pct
});




}
/// @nodoc
class _$CurrentTailCopyWithImpl<$Res>
    implements $CurrentTailCopyWith<$Res> {
  _$CurrentTailCopyWithImpl(this._self, this._then);

  final CurrentTail _self;
  final $Res Function(CurrentTail) _then;

/// Create a copy of CurrentTail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? side = null,Object? pct = null,}) {
  return _then(CurrentTail(
side: null == side ? _self.side : side // ignore: cast_nullable_to_non_nullable
as Direction,pct: null == pct ? _self.pct : pct // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CurrentTail].
extension CurrentTailPatterns on CurrentTail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrentTail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrentTail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrentTail value)  $default,){
final _that = this;
switch (_that) {
case _CurrentTail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrentTail value)?  $default,){
final _that = this;
switch (_that) {
case _CurrentTail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Direction side,  double pct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrentTail() when $default != null:
return $default(_that.side,_that.pct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Direction side,  double pct)  $default,) {final _that = this;
switch (_that) {
case _CurrentTail():
return $default(_that.side,_that.pct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Direction side,  double pct)?  $default,) {final _that = this;
switch (_that) {
case _CurrentTail() when $default != null:
return $default(_that.side,_that.pct);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurrentTail implements CurrentTail {
  const _CurrentTail({required this.side, required this.pct});
  factory _CurrentTail.fromJson(Map<String, dynamic> json) => _$CurrentTailFromJson(json);

@override final  Direction side;
@override final  double pct;

/// Create a copy of CurrentTail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrentTailCopyWith<_CurrentTail> get copyWith => __$CurrentTailCopyWithImpl<_CurrentTail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CurrentTailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentTail&&(identical(other.side, side) || other.side == side)&&(identical(other.pct, pct) || other.pct == pct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,side,pct);
}

@override
String toString() {
    return 'CurrentTail(side: $side, pct: $pct)';
}


}

/// @nodoc
abstract mixin class _$CurrentTailCopyWith<$Res> implements $CurrentTailCopyWith<$Res> {
  factory _$CurrentTailCopyWith(_CurrentTail value, $Res Function(_CurrentTail) _then) = __$CurrentTailCopyWithImpl;
@override @useResult
$Res call({
 Direction side, double pct
});




}
/// @nodoc
class __$CurrentTailCopyWithImpl<$Res>
    implements _$CurrentTailCopyWith<$Res> {
  __$CurrentTailCopyWithImpl(this._self, this._then);

  final _CurrentTail _self;
  final $Res Function(_CurrentTail) _then;

/// Create a copy of CurrentTail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? side = null,Object? pct = null,}) {
  return _then(_CurrentTail(
side: null == side ? _self.side : side // ignore: cast_nullable_to_non_nullable
as Direction,pct: null == pct ? _self.pct : pct // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$DisparityBar {

 String get tradeDate; double? get open; double? get high; double? get low; double? get close; double? get ma; double? get disparity; bool get inRoll; List<Holding> get holdings;
/// Create a copy of DisparityBar
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DisparityBarCopyWith<DisparityBar> get copyWith => _$DisparityBarCopyWithImpl<DisparityBar>(this as DisparityBar, _$identity);

  /// Serializes this DisparityBar to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DisparityBar;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisparityBar&&(identical(other.tradeDate, _this.tradeDate) || other.tradeDate == _this.tradeDate)&&(identical(other.open, _this.open) || other.open == _this.open)&&(identical(other.high, _this.high) || other.high == _this.high)&&(identical(other.low, _this.low) || other.low == _this.low)&&(identical(other.close, _this.close) || other.close == _this.close)&&(identical(other.ma, _this.ma) || other.ma == _this.ma)&&(identical(other.disparity, _this.disparity) || other.disparity == _this.disparity)&&(identical(other.inRoll, _this.inRoll) || other.inRoll == _this.inRoll)&&const DeepCollectionEquality().equals(other.holdings, _this.holdings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DisparityBar;
  return Object.hash(runtimeType,_this.tradeDate,_this.open,_this.high,_this.low,_this.close,_this.ma,_this.disparity,_this.inRoll,const DeepCollectionEquality().hash(_this.holdings));
}

@override
String toString() {
  final _this = this as DisparityBar;
  return 'DisparityBar(tradeDate: ${_this.tradeDate}, open: ${_this.open}, high: ${_this.high}, low: ${_this.low}, close: ${_this.close}, ma: ${_this.ma}, disparity: ${_this.disparity}, inRoll: ${_this.inRoll}, holdings: ${_this.holdings})';
}


}

/// @nodoc
abstract mixin class $DisparityBarCopyWith<$Res>  {
  factory $DisparityBarCopyWith(DisparityBar value, $Res Function(DisparityBar) _then) = _$DisparityBarCopyWithImpl;
@useResult
$Res call({
 String tradeDate, double? open, double? high, double? low, double? close, double? ma, double? disparity, bool inRoll, List<Holding> holdings
});




}
/// @nodoc
class _$DisparityBarCopyWithImpl<$Res>
    implements $DisparityBarCopyWith<$Res> {
  _$DisparityBarCopyWithImpl(this._self, this._then);

  final DisparityBar _self;
  final $Res Function(DisparityBar) _then;

/// Create a copy of DisparityBar
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tradeDate = null,Object? open = freezed,Object? high = freezed,Object? low = freezed,Object? close = freezed,Object? ma = freezed,Object? disparity = freezed,Object? inRoll = null,Object? holdings = null,}) {
  return _then(DisparityBar(
tradeDate: null == tradeDate ? _self.tradeDate : tradeDate // ignore: cast_nullable_to_non_nullable
as String,open: freezed == open ? _self.open : open // ignore: cast_nullable_to_non_nullable
as double?,high: freezed == high ? _self.high : high // ignore: cast_nullable_to_non_nullable
as double?,low: freezed == low ? _self.low : low // ignore: cast_nullable_to_non_nullable
as double?,close: freezed == close ? _self.close : close // ignore: cast_nullable_to_non_nullable
as double?,ma: freezed == ma ? _self.ma : ma // ignore: cast_nullable_to_non_nullable
as double?,disparity: freezed == disparity ? _self.disparity : disparity // ignore: cast_nullable_to_non_nullable
as double?,inRoll: null == inRoll ? _self.inRoll : inRoll // ignore: cast_nullable_to_non_nullable
as bool,holdings: null == holdings ? _self.holdings : holdings // ignore: cast_nullable_to_non_nullable
as List<Holding>,
  ));
}

}


/// Adds pattern-matching-related methods to [DisparityBar].
extension DisparityBarPatterns on DisparityBar {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DisparityBar value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DisparityBar() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DisparityBar value)  $default,){
final _that = this;
switch (_that) {
case _DisparityBar():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DisparityBar value)?  $default,){
final _that = this;
switch (_that) {
case _DisparityBar() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tradeDate,  double? open,  double? high,  double? low,  double? close,  double? ma,  double? disparity,  bool inRoll,  List<Holding> holdings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DisparityBar() when $default != null:
return $default(_that.tradeDate,_that.open,_that.high,_that.low,_that.close,_that.ma,_that.disparity,_that.inRoll,_that.holdings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tradeDate,  double? open,  double? high,  double? low,  double? close,  double? ma,  double? disparity,  bool inRoll,  List<Holding> holdings)  $default,) {final _that = this;
switch (_that) {
case _DisparityBar():
return $default(_that.tradeDate,_that.open,_that.high,_that.low,_that.close,_that.ma,_that.disparity,_that.inRoll,_that.holdings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tradeDate,  double? open,  double? high,  double? low,  double? close,  double? ma,  double? disparity,  bool inRoll,  List<Holding> holdings)?  $default,) {final _that = this;
switch (_that) {
case _DisparityBar() when $default != null:
return $default(_that.tradeDate,_that.open,_that.high,_that.low,_that.close,_that.ma,_that.disparity,_that.inRoll,_that.holdings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DisparityBar implements DisparityBar {
  const _DisparityBar({required this.tradeDate, required this.open, required this.high, required this.low, required this.close, required this.ma, required this.disparity, required this.inRoll, required  List<Holding> holdings}): _holdings = holdings;
  factory _DisparityBar.fromJson(Map<String, dynamic> json) => _$DisparityBarFromJson(json);

@override final  String tradeDate;
@override final  double? open;
@override final  double? high;
@override final  double? low;
@override final  double? close;
@override final  double? ma;
@override final  double? disparity;
@override final  bool inRoll;
 final  List<Holding> _holdings;
@override List<Holding> get holdings {
  if (_holdings is EqualUnmodifiableListView) return _holdings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_holdings);
}


/// Create a copy of DisparityBar
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DisparityBarCopyWith<_DisparityBar> get copyWith => __$DisparityBarCopyWithImpl<_DisparityBar>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DisparityBarToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DisparityBar&&(identical(other.tradeDate, tradeDate) || other.tradeDate == tradeDate)&&(identical(other.open, open) || other.open == open)&&(identical(other.high, high) || other.high == high)&&(identical(other.low, low) || other.low == low)&&(identical(other.close, close) || other.close == close)&&(identical(other.ma, ma) || other.ma == ma)&&(identical(other.disparity, disparity) || other.disparity == disparity)&&(identical(other.inRoll, inRoll) || other.inRoll == inRoll)&&const DeepCollectionEquality().equals(other.holdings, _holdings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tradeDate,open,high,low,close,ma,disparity,inRoll,const DeepCollectionEquality().hash(_holdings));
}

@override
String toString() {
    return 'DisparityBar(tradeDate: $tradeDate, open: $open, high: $high, low: $low, close: $close, ma: $ma, disparity: $disparity, inRoll: $inRoll, holdings: $holdings)';
}


}

/// @nodoc
abstract mixin class _$DisparityBarCopyWith<$Res> implements $DisparityBarCopyWith<$Res> {
  factory _$DisparityBarCopyWith(_DisparityBar value, $Res Function(_DisparityBar) _then) = __$DisparityBarCopyWithImpl;
@override @useResult
$Res call({
 String tradeDate, double? open, double? high, double? low, double? close, double? ma, double? disparity, bool inRoll, List<Holding> holdings
});




}
/// @nodoc
class __$DisparityBarCopyWithImpl<$Res>
    implements _$DisparityBarCopyWith<$Res> {
  __$DisparityBarCopyWithImpl(this._self, this._then);

  final _DisparityBar _self;
  final $Res Function(_DisparityBar) _then;

/// Create a copy of DisparityBar
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tradeDate = null,Object? open = freezed,Object? high = freezed,Object? low = freezed,Object? close = freezed,Object? ma = freezed,Object? disparity = freezed,Object? inRoll = null,Object? holdings = null,}) {
  return _then(_DisparityBar(
tradeDate: null == tradeDate ? _self.tradeDate : tradeDate // ignore: cast_nullable_to_non_nullable
as String,open: freezed == open ? _self.open : open // ignore: cast_nullable_to_non_nullable
as double?,high: freezed == high ? _self.high : high // ignore: cast_nullable_to_non_nullable
as double?,low: freezed == low ? _self.low : low // ignore: cast_nullable_to_non_nullable
as double?,close: freezed == close ? _self.close : close // ignore: cast_nullable_to_non_nullable
as double?,ma: freezed == ma ? _self.ma : ma // ignore: cast_nullable_to_non_nullable
as double?,disparity: freezed == disparity ? _self.disparity : disparity // ignore: cast_nullable_to_non_nullable
as double?,inRoll: null == inRoll ? _self.inRoll : inRoll // ignore: cast_nullable_to_non_nullable
as bool,holdings: null == holdings ? _self._holdings : holdings // ignore: cast_nullable_to_non_nullable
as List<Holding>,
  ));
}


}


/// @nodoc
mixin _$Holding {

 String get contractMonth; double get weight;
/// Create a copy of Holding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HoldingCopyWith<Holding> get copyWith => _$HoldingCopyWithImpl<Holding>(this as Holding, _$identity);

  /// Serializes this Holding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Holding;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Holding&&(identical(other.contractMonth, _this.contractMonth) || other.contractMonth == _this.contractMonth)&&(identical(other.weight, _this.weight) || other.weight == _this.weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Holding;
  return Object.hash(runtimeType,_this.contractMonth,_this.weight);
}

@override
String toString() {
  final _this = this as Holding;
  return 'Holding(contractMonth: ${_this.contractMonth}, weight: ${_this.weight})';
}


}

/// @nodoc
abstract mixin class $HoldingCopyWith<$Res>  {
  factory $HoldingCopyWith(Holding value, $Res Function(Holding) _then) = _$HoldingCopyWithImpl;
@useResult
$Res call({
 String contractMonth, double weight
});




}
/// @nodoc
class _$HoldingCopyWithImpl<$Res>
    implements $HoldingCopyWith<$Res> {
  _$HoldingCopyWithImpl(this._self, this._then);

  final Holding _self;
  final $Res Function(Holding) _then;

/// Create a copy of Holding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contractMonth = null,Object? weight = null,}) {
  return _then(Holding(
contractMonth: null == contractMonth ? _self.contractMonth : contractMonth // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Holding].
extension HoldingPatterns on Holding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Holding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Holding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Holding value)  $default,){
final _that = this;
switch (_that) {
case _Holding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Holding value)?  $default,){
final _that = this;
switch (_that) {
case _Holding() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String contractMonth,  double weight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Holding() when $default != null:
return $default(_that.contractMonth,_that.weight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String contractMonth,  double weight)  $default,) {final _that = this;
switch (_that) {
case _Holding():
return $default(_that.contractMonth,_that.weight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String contractMonth,  double weight)?  $default,) {final _that = this;
switch (_that) {
case _Holding() when $default != null:
return $default(_that.contractMonth,_that.weight);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Holding implements Holding {
  const _Holding({required this.contractMonth, required this.weight});
  factory _Holding.fromJson(Map<String, dynamic> json) => _$HoldingFromJson(json);

@override final  String contractMonth;
@override final  double weight;

/// Create a copy of Holding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HoldingCopyWith<_Holding> get copyWith => __$HoldingCopyWithImpl<_Holding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HoldingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Holding&&(identical(other.contractMonth, contractMonth) || other.contractMonth == contractMonth)&&(identical(other.weight, weight) || other.weight == weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,contractMonth,weight);
}

@override
String toString() {
    return 'Holding(contractMonth: $contractMonth, weight: $weight)';
}


}

/// @nodoc
abstract mixin class _$HoldingCopyWith<$Res> implements $HoldingCopyWith<$Res> {
  factory _$HoldingCopyWith(_Holding value, $Res Function(_Holding) _then) = __$HoldingCopyWithImpl;
@override @useResult
$Res call({
 String contractMonth, double weight
});




}
/// @nodoc
class __$HoldingCopyWithImpl<$Res>
    implements _$HoldingCopyWith<$Res> {
  __$HoldingCopyWithImpl(this._self, this._then);

  final _Holding _self;
  final $Res Function(_Holding) _then;

/// Create a copy of Holding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contractMonth = null,Object? weight = null,}) {
  return _then(_Holding(
contractMonth: null == contractMonth ? _self.contractMonth : contractMonth // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
