// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'capture_moment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CaptureMoment {

 DateTime get capturedAtUtc; UtcOffsetAt get offsetAt;
/// Create a copy of CaptureMoment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CaptureMomentCopyWith<CaptureMoment> get copyWith => _$CaptureMomentCopyWithImpl<CaptureMoment>(this as CaptureMoment, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CaptureMoment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CaptureMoment&&(identical(other.capturedAtUtc, _this.capturedAtUtc) || other.capturedAtUtc == _this.capturedAtUtc)&&(identical(other.offsetAt, _this.offsetAt) || other.offsetAt == _this.offsetAt));
}


@override
int get hashCode {
  final _this = this as CaptureMoment;
  return Object.hash(runtimeType,_this.capturedAtUtc,_this.offsetAt);
}

@override
String toString() {
  final _this = this as CaptureMoment;
  return 'CaptureMoment(capturedAtUtc: ${_this.capturedAtUtc}, offsetAt: ${_this.offsetAt})';
}


}

/// @nodoc
abstract mixin class $CaptureMomentCopyWith<$Res>  {
  factory $CaptureMomentCopyWith(CaptureMoment value, $Res Function(CaptureMoment) _then) = _$CaptureMomentCopyWithImpl;
@useResult
$Res call({
 DateTime capturedAtUtc, UtcOffsetAt offsetAt
});




}
/// @nodoc
class _$CaptureMomentCopyWithImpl<$Res>
    implements $CaptureMomentCopyWith<$Res> {
  _$CaptureMomentCopyWithImpl(this._self, this._then);

  final CaptureMoment _self;
  final $Res Function(CaptureMoment) _then;

/// Create a copy of CaptureMoment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? capturedAtUtc = null,Object? offsetAt = null,}) {
  return _then(CaptureMoment(
capturedAtUtc: null == capturedAtUtc ? _self.capturedAtUtc : capturedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,offsetAt: null == offsetAt ? _self.offsetAt : offsetAt // ignore: cast_nullable_to_non_nullable
as UtcOffsetAt,
  ));
}

}


/// Adds pattern-matching-related methods to [CaptureMoment].
extension CaptureMomentPatterns on CaptureMoment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CaptureMoment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CaptureMoment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CaptureMoment value)  $default,){
final _that = this;
switch (_that) {
case _CaptureMoment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CaptureMoment value)?  $default,){
final _that = this;
switch (_that) {
case _CaptureMoment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime capturedAtUtc,  UtcOffsetAt offsetAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CaptureMoment() when $default != null:
return $default(_that.capturedAtUtc,_that.offsetAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime capturedAtUtc,  UtcOffsetAt offsetAt)  $default,) {final _that = this;
switch (_that) {
case _CaptureMoment():
return $default(_that.capturedAtUtc,_that.offsetAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime capturedAtUtc,  UtcOffsetAt offsetAt)?  $default,) {final _that = this;
switch (_that) {
case _CaptureMoment() when $default != null:
return $default(_that.capturedAtUtc,_that.offsetAt);case _:
  return null;

}
}

}

/// @nodoc


class _CaptureMoment extends CaptureMoment {
  const _CaptureMoment({required this.capturedAtUtc, required this.offsetAt}): super._();
  

@override final  DateTime capturedAtUtc;
@override final  UtcOffsetAt offsetAt;

/// Create a copy of CaptureMoment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CaptureMomentCopyWith<_CaptureMoment> get copyWith => __$CaptureMomentCopyWithImpl<_CaptureMoment>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CaptureMoment&&(identical(other.capturedAtUtc, capturedAtUtc) || other.capturedAtUtc == capturedAtUtc)&&(identical(other.offsetAt, offsetAt) || other.offsetAt == offsetAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,capturedAtUtc,offsetAt);
}

@override
String toString() {
    return 'CaptureMoment(capturedAtUtc: $capturedAtUtc, offsetAt: $offsetAt)';
}


}

/// @nodoc
abstract mixin class _$CaptureMomentCopyWith<$Res> implements $CaptureMomentCopyWith<$Res> {
  factory _$CaptureMomentCopyWith(_CaptureMoment value, $Res Function(_CaptureMoment) _then) = __$CaptureMomentCopyWithImpl;
@override @useResult
$Res call({
 DateTime capturedAtUtc, UtcOffsetAt offsetAt
});




}
/// @nodoc
class __$CaptureMomentCopyWithImpl<$Res>
    implements _$CaptureMomentCopyWith<$Res> {
  __$CaptureMomentCopyWithImpl(this._self, this._then);

  final _CaptureMoment _self;
  final $Res Function(_CaptureMoment) _then;

/// Create a copy of CaptureMoment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? capturedAtUtc = null,Object? offsetAt = null,}) {
  return _then(_CaptureMoment(
capturedAtUtc: null == capturedAtUtc ? _self.capturedAtUtc : capturedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,offsetAt: null == offsetAt ? _self.offsetAt : offsetAt // ignore: cast_nullable_to_non_nullable
as UtcOffsetAt,
  ));
}


}

// dart format on
