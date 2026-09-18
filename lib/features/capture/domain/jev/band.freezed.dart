// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'band.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Band {

 double get decide; double get low; double get high;
/// Create a copy of Band
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BandCopyWith<Band> get copyWith => _$BandCopyWithImpl<Band>(this as Band, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Band;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Band&&(identical(other.decide, _this.decide) || other.decide == _this.decide)&&(identical(other.low, _this.low) || other.low == _this.low)&&(identical(other.high, _this.high) || other.high == _this.high));
}


@override
int get hashCode {
  final _this = this as Band;
  return Object.hash(runtimeType,_this.decide,_this.low,_this.high);
}

@override
String toString() {
  final _this = this as Band;
  return 'Band(decide: ${_this.decide}, low: ${_this.low}, high: ${_this.high})';
}


}

/// @nodoc
abstract mixin class $BandCopyWith<$Res>  {
  factory $BandCopyWith(Band value, $Res Function(Band) _then) = _$BandCopyWithImpl;
@useResult
$Res call({
 double decide, double low, double high
});




}
/// @nodoc
class _$BandCopyWithImpl<$Res>
    implements $BandCopyWith<$Res> {
  _$BandCopyWithImpl(this._self, this._then);

  final Band _self;
  final $Res Function(Band) _then;

/// Create a copy of Band
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? decide = null,Object? low = null,Object? high = null,}) {
  return _then(Band(
null == decide ? _self.decide : decide // ignore: cast_nullable_to_non_nullable
as double,null == low ? _self.low : low // ignore: cast_nullable_to_non_nullable
as double,null == high ? _self.high : high // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Band].
extension BandPatterns on Band {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Band value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Band() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Band value)  $default,){
final _that = this;
switch (_that) {
case _Band():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Band value)?  $default,){
final _that = this;
switch (_that) {
case _Band() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double decide,  double low,  double high)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Band() when $default != null:
return $default(_that.decide,_that.low,_that.high);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double decide,  double low,  double high)  $default,) {final _that = this;
switch (_that) {
case _Band():
return $default(_that.decide,_that.low,_that.high);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double decide,  double low,  double high)?  $default,) {final _that = this;
switch (_that) {
case _Band() when $default != null:
return $default(_that.decide,_that.low,_that.high);case _:
  return null;

}
}

}

/// @nodoc


class _Band extends Band {
  const _Band(this.decide, this.low, this.high): super._();
  

@override final  double decide;
@override final  double low;
@override final  double high;

/// Create a copy of Band
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BandCopyWith<_Band> get copyWith => __$BandCopyWithImpl<_Band>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Band&&(identical(other.decide, decide) || other.decide == decide)&&(identical(other.low, low) || other.low == low)&&(identical(other.high, high) || other.high == high));
}


@override
int get hashCode {
    return Object.hash(runtimeType,decide,low,high);
}

@override
String toString() {
    return 'Band(decide: $decide, low: $low, high: $high)';
}


}

/// @nodoc
abstract mixin class _$BandCopyWith<$Res> implements $BandCopyWith<$Res> {
  factory _$BandCopyWith(_Band value, $Res Function(_Band) _then) = __$BandCopyWithImpl;
@override @useResult
$Res call({
 double decide, double low, double high
});




}
/// @nodoc
class __$BandCopyWithImpl<$Res>
    implements _$BandCopyWith<$Res> {
  __$BandCopyWithImpl(this._self, this._then);

  final _Band _self;
  final $Res Function(_Band) _then;

/// Create a copy of Band
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? decide = null,Object? low = null,Object? high = null,}) {
  return _then(_Band(
null == decide ? _self.decide : decide // ignore: cast_nullable_to_non_nullable
as double,null == low ? _self.low : low // ignore: cast_nullable_to_non_nullable
as double,null == high ? _self.high : high // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
