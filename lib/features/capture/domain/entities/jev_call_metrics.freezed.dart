// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jev_call_metrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JevCallMetrics {

 JevModel get model; Duration get latency; int get inputTokens; int get outputTokens; int get questions; String? get requestId;
/// Create a copy of JevCallMetrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JevCallMetricsCopyWith<JevCallMetrics> get copyWith => _$JevCallMetricsCopyWithImpl<JevCallMetrics>(this as JevCallMetrics, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as JevCallMetrics;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JevCallMetrics&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.latency, _this.latency) || other.latency == _this.latency)&&(identical(other.inputTokens, _this.inputTokens) || other.inputTokens == _this.inputTokens)&&(identical(other.outputTokens, _this.outputTokens) || other.outputTokens == _this.outputTokens)&&(identical(other.questions, _this.questions) || other.questions == _this.questions)&&(identical(other.requestId, _this.requestId) || other.requestId == _this.requestId));
}


@override
int get hashCode {
  final _this = this as JevCallMetrics;
  return Object.hash(runtimeType,_this.model,_this.latency,_this.inputTokens,_this.outputTokens,_this.questions,_this.requestId);
}

@override
String toString() {
  final _this = this as JevCallMetrics;
  return 'JevCallMetrics(model: ${_this.model}, latency: ${_this.latency}, inputTokens: ${_this.inputTokens}, outputTokens: ${_this.outputTokens}, questions: ${_this.questions}, requestId: ${_this.requestId})';
}


}

/// @nodoc
abstract mixin class $JevCallMetricsCopyWith<$Res>  {
  factory $JevCallMetricsCopyWith(JevCallMetrics value, $Res Function(JevCallMetrics) _then) = _$JevCallMetricsCopyWithImpl;
@useResult
$Res call({
 JevModel model, Duration latency, int inputTokens, int outputTokens, int questions, String? requestId
});




}
/// @nodoc
class _$JevCallMetricsCopyWithImpl<$Res>
    implements $JevCallMetricsCopyWith<$Res> {
  _$JevCallMetricsCopyWithImpl(this._self, this._then);

  final JevCallMetrics _self;
  final $Res Function(JevCallMetrics) _then;

/// Create a copy of JevCallMetrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? model = null,Object? latency = null,Object? inputTokens = null,Object? outputTokens = null,Object? questions = null,Object? requestId = freezed,}) {
  return _then(JevCallMetrics(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as JevModel,latency: null == latency ? _self.latency : latency // ignore: cast_nullable_to_non_nullable
as Duration,inputTokens: null == inputTokens ? _self.inputTokens : inputTokens // ignore: cast_nullable_to_non_nullable
as int,outputTokens: null == outputTokens ? _self.outputTokens : outputTokens // ignore: cast_nullable_to_non_nullable
as int,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as int,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JevCallMetrics].
extension JevCallMetricsPatterns on JevCallMetrics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JevCallMetrics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JevCallMetrics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JevCallMetrics value)  $default,){
final _that = this;
switch (_that) {
case _JevCallMetrics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JevCallMetrics value)?  $default,){
final _that = this;
switch (_that) {
case _JevCallMetrics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( JevModel model,  Duration latency,  int inputTokens,  int outputTokens,  int questions,  String? requestId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JevCallMetrics() when $default != null:
return $default(_that.model,_that.latency,_that.inputTokens,_that.outputTokens,_that.questions,_that.requestId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( JevModel model,  Duration latency,  int inputTokens,  int outputTokens,  int questions,  String? requestId)  $default,) {final _that = this;
switch (_that) {
case _JevCallMetrics():
return $default(_that.model,_that.latency,_that.inputTokens,_that.outputTokens,_that.questions,_that.requestId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( JevModel model,  Duration latency,  int inputTokens,  int outputTokens,  int questions,  String? requestId)?  $default,) {final _that = this;
switch (_that) {
case _JevCallMetrics() when $default != null:
return $default(_that.model,_that.latency,_that.inputTokens,_that.outputTokens,_that.questions,_that.requestId);case _:
  return null;

}
}

}

/// @nodoc


class _JevCallMetrics implements JevCallMetrics {
  const _JevCallMetrics({required this.model, required this.latency, required this.inputTokens, required this.outputTokens, required this.questions, this.requestId});
  

@override final  JevModel model;
@override final  Duration latency;
@override final  int inputTokens;
@override final  int outputTokens;
@override final  int questions;
@override final  String? requestId;

/// Create a copy of JevCallMetrics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JevCallMetricsCopyWith<_JevCallMetrics> get copyWith => __$JevCallMetricsCopyWithImpl<_JevCallMetrics>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JevCallMetrics&&(identical(other.model, model) || other.model == model)&&(identical(other.latency, latency) || other.latency == latency)&&(identical(other.inputTokens, inputTokens) || other.inputTokens == inputTokens)&&(identical(other.outputTokens, outputTokens) || other.outputTokens == outputTokens)&&(identical(other.questions, questions) || other.questions == questions)&&(identical(other.requestId, requestId) || other.requestId == requestId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,model,latency,inputTokens,outputTokens,questions,requestId);
}

@override
String toString() {
    return 'JevCallMetrics(model: $model, latency: $latency, inputTokens: $inputTokens, outputTokens: $outputTokens, questions: $questions, requestId: $requestId)';
}


}

/// @nodoc
abstract mixin class _$JevCallMetricsCopyWith<$Res> implements $JevCallMetricsCopyWith<$Res> {
  factory _$JevCallMetricsCopyWith(_JevCallMetrics value, $Res Function(_JevCallMetrics) _then) = __$JevCallMetricsCopyWithImpl;
@override @useResult
$Res call({
 JevModel model, Duration latency, int inputTokens, int outputTokens, int questions, String? requestId
});




}
/// @nodoc
class __$JevCallMetricsCopyWithImpl<$Res>
    implements _$JevCallMetricsCopyWith<$Res> {
  __$JevCallMetricsCopyWithImpl(this._self, this._then);

  final _JevCallMetrics _self;
  final $Res Function(_JevCallMetrics) _then;

/// Create a copy of JevCallMetrics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? model = null,Object? latency = null,Object? inputTokens = null,Object? outputTokens = null,Object? questions = null,Object? requestId = freezed,}) {
  return _then(_JevCallMetrics(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as JevModel,latency: null == latency ? _self.latency : latency // ignore: cast_nullable_to_non_nullable
as Duration,inputTokens: null == inputTokens ? _self.inputTokens : inputTokens // ignore: cast_nullable_to_non_nullable
as int,outputTokens: null == outputTokens ? _self.outputTokens : outputTokens // ignore: cast_nullable_to_non_nullable
as int,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as int,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
