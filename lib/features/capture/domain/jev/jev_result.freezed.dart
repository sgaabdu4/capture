// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jev_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JevResult {

 JevModel get model; Map<String, JevAnswer> get answers; JevUsage get usage;
/// Create a copy of JevResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JevResultCopyWith<JevResult> get copyWith => _$JevResultCopyWithImpl<JevResult>(this as JevResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as JevResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JevResult&&(identical(other.model, _this.model) || other.model == _this.model)&&const DeepCollectionEquality().equals(other.answers, _this.answers)&&(identical(other.usage, _this.usage) || other.usage == _this.usage));
}


@override
int get hashCode {
  final _this = this as JevResult;
  return Object.hash(runtimeType,_this.model,const DeepCollectionEquality().hash(_this.answers),_this.usage);
}

@override
String toString() {
  final _this = this as JevResult;
  return 'JevResult(model: ${_this.model}, answers: ${_this.answers}, usage: ${_this.usage})';
}


}

/// @nodoc
abstract mixin class $JevResultCopyWith<$Res>  {
  factory $JevResultCopyWith(JevResult value, $Res Function(JevResult) _then) = _$JevResultCopyWithImpl;
@useResult
$Res call({
 JevModel model, Map<String, JevAnswer> answers, JevUsage usage
});


$JevUsageCopyWith<$Res> get usage;

}
/// @nodoc
class _$JevResultCopyWithImpl<$Res>
    implements $JevResultCopyWith<$Res> {
  _$JevResultCopyWithImpl(this._self, this._then);

  final JevResult _self;
  final $Res Function(JevResult) _then;

/// Create a copy of JevResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? model = null,Object? answers = null,Object? usage = null,}) {
  return _then(JevResult(
null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as JevModel,null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, JevAnswer>,null == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as JevUsage,
  ));
}
/// Create a copy of JevResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JevUsageCopyWith<$Res> get usage {
  
  return $JevUsageCopyWith<$Res>(_self.usage, (value) {
    return _then(_self.copyWith(usage: value));
  });
}
}


/// Adds pattern-matching-related methods to [JevResult].
extension JevResultPatterns on JevResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JevResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JevResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JevResult value)  $default,){
final _that = this;
switch (_that) {
case _JevResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JevResult value)?  $default,){
final _that = this;
switch (_that) {
case _JevResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( JevModel model,  Map<String, JevAnswer> answers,  JevUsage usage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JevResult() when $default != null:
return $default(_that.model,_that.answers,_that.usage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( JevModel model,  Map<String, JevAnswer> answers,  JevUsage usage)  $default,) {final _that = this;
switch (_that) {
case _JevResult():
return $default(_that.model,_that.answers,_that.usage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( JevModel model,  Map<String, JevAnswer> answers,  JevUsage usage)?  $default,) {final _that = this;
switch (_that) {
case _JevResult() when $default != null:
return $default(_that.model,_that.answers,_that.usage);case _:
  return null;

}
}

}

/// @nodoc


class _JevResult implements JevResult {
  const _JevResult(this.model,  Map<String, JevAnswer> answers, this.usage): _answers = answers;
  

@override final  JevModel model;
 final  Map<String, JevAnswer> _answers;
@override Map<String, JevAnswer> get answers {
  if (_answers is EqualUnmodifiableMapView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_answers);
}

@override final  JevUsage usage;

/// Create a copy of JevResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JevResultCopyWith<_JevResult> get copyWith => __$JevResultCopyWithImpl<_JevResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JevResult&&(identical(other.model, model) || other.model == model)&&const DeepCollectionEquality().equals(other.answers, _answers)&&(identical(other.usage, usage) || other.usage == usage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,model,const DeepCollectionEquality().hash(_answers),usage);
}

@override
String toString() {
    return 'JevResult(model: $model, answers: $answers, usage: $usage)';
}


}

/// @nodoc
abstract mixin class _$JevResultCopyWith<$Res> implements $JevResultCopyWith<$Res> {
  factory _$JevResultCopyWith(_JevResult value, $Res Function(_JevResult) _then) = __$JevResultCopyWithImpl;
@override @useResult
$Res call({
 JevModel model, Map<String, JevAnswer> answers, JevUsage usage
});


@override $JevUsageCopyWith<$Res> get usage;

}
/// @nodoc
class __$JevResultCopyWithImpl<$Res>
    implements _$JevResultCopyWith<$Res> {
  __$JevResultCopyWithImpl(this._self, this._then);

  final _JevResult _self;
  final $Res Function(_JevResult) _then;

/// Create a copy of JevResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? model = null,Object? answers = null,Object? usage = null,}) {
  return _then(_JevResult(
null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as JevModel,null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, JevAnswer>,null == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as JevUsage,
  ));
}

/// Create a copy of JevResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JevUsageCopyWith<$Res> get usage {
  
  return $JevUsageCopyWith<$Res>(_self.usage, (value) {
    return _then(_self.copyWith(usage: value));
  });
}
}

// dart format on
