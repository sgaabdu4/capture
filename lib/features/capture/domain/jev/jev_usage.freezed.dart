// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jev_usage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JevUsage {

 int get inputTokens; int get outputTokens;
/// Create a copy of JevUsage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JevUsageCopyWith<JevUsage> get copyWith => _$JevUsageCopyWithImpl<JevUsage>(this as JevUsage, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as JevUsage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JevUsage&&(identical(other.inputTokens, _this.inputTokens) || other.inputTokens == _this.inputTokens)&&(identical(other.outputTokens, _this.outputTokens) || other.outputTokens == _this.outputTokens));
}


@override
int get hashCode {
  final _this = this as JevUsage;
  return Object.hash(runtimeType,_this.inputTokens,_this.outputTokens);
}

@override
String toString() {
  final _this = this as JevUsage;
  return 'JevUsage(inputTokens: ${_this.inputTokens}, outputTokens: ${_this.outputTokens})';
}


}

/// @nodoc
abstract mixin class $JevUsageCopyWith<$Res>  {
  factory $JevUsageCopyWith(JevUsage value, $Res Function(JevUsage) _then) = _$JevUsageCopyWithImpl;
@useResult
$Res call({
 int inputTokens, int outputTokens
});




}
/// @nodoc
class _$JevUsageCopyWithImpl<$Res>
    implements $JevUsageCopyWith<$Res> {
  _$JevUsageCopyWithImpl(this._self, this._then);

  final JevUsage _self;
  final $Res Function(JevUsage) _then;

/// Create a copy of JevUsage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inputTokens = null,Object? outputTokens = null,}) {
  return _then(JevUsage(
null == inputTokens ? _self.inputTokens : inputTokens // ignore: cast_nullable_to_non_nullable
as int,null == outputTokens ? _self.outputTokens : outputTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [JevUsage].
extension JevUsagePatterns on JevUsage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JevUsage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JevUsage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JevUsage value)  $default,){
final _that = this;
switch (_that) {
case _JevUsage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JevUsage value)?  $default,){
final _that = this;
switch (_that) {
case _JevUsage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int inputTokens,  int outputTokens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JevUsage() when $default != null:
return $default(_that.inputTokens,_that.outputTokens);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int inputTokens,  int outputTokens)  $default,) {final _that = this;
switch (_that) {
case _JevUsage():
return $default(_that.inputTokens,_that.outputTokens);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int inputTokens,  int outputTokens)?  $default,) {final _that = this;
switch (_that) {
case _JevUsage() when $default != null:
return $default(_that.inputTokens,_that.outputTokens);case _:
  return null;

}
}

}

/// @nodoc


class _JevUsage implements JevUsage {
  const _JevUsage(this.inputTokens, this.outputTokens);
  

@override final  int inputTokens;
@override final  int outputTokens;

/// Create a copy of JevUsage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JevUsageCopyWith<_JevUsage> get copyWith => __$JevUsageCopyWithImpl<_JevUsage>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JevUsage&&(identical(other.inputTokens, inputTokens) || other.inputTokens == inputTokens)&&(identical(other.outputTokens, outputTokens) || other.outputTokens == outputTokens));
}


@override
int get hashCode {
    return Object.hash(runtimeType,inputTokens,outputTokens);
}

@override
String toString() {
    return 'JevUsage(inputTokens: $inputTokens, outputTokens: $outputTokens)';
}


}

/// @nodoc
abstract mixin class _$JevUsageCopyWith<$Res> implements $JevUsageCopyWith<$Res> {
  factory _$JevUsageCopyWith(_JevUsage value, $Res Function(_JevUsage) _then) = __$JevUsageCopyWithImpl;
@override @useResult
$Res call({
 int inputTokens, int outputTokens
});




}
/// @nodoc
class __$JevUsageCopyWithImpl<$Res>
    implements _$JevUsageCopyWith<$Res> {
  __$JevUsageCopyWithImpl(this._self, this._then);

  final _JevUsage _self;
  final $Res Function(_JevUsage) _then;

/// Create a copy of JevUsage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inputTokens = null,Object? outputTokens = null,}) {
  return _then(_JevUsage(
null == inputTokens ? _self.inputTokens : inputTokens // ignore: cast_nullable_to_non_nullable
as int,null == outputTokens ? _self.outputTokens : outputTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
