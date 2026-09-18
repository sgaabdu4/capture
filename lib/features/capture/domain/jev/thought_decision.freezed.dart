// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thought_decision.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ThoughtDecision {

 Thought get thought; String get groupOption; double get groupConfidence;/// P(yes) that the thought is a to-do.
 double get task;/// P(yes) that the thought asks for a reminder.
 double get alert;/// P(yes) that the thought asks the app to recall something.
 double get recall; DayCandidate? get day; double get dayConfidence; TimeCandidate? get time; double get timeConfidence;
/// Create a copy of ThoughtDecision
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThoughtDecisionCopyWith<ThoughtDecision> get copyWith => _$ThoughtDecisionCopyWithImpl<ThoughtDecision>(this as ThoughtDecision, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ThoughtDecision;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThoughtDecision&&(identical(other.thought, _this.thought) || other.thought == _this.thought)&&(identical(other.groupOption, _this.groupOption) || other.groupOption == _this.groupOption)&&(identical(other.groupConfidence, _this.groupConfidence) || other.groupConfidence == _this.groupConfidence)&&(identical(other.task, _this.task) || other.task == _this.task)&&(identical(other.alert, _this.alert) || other.alert == _this.alert)&&(identical(other.recall, _this.recall) || other.recall == _this.recall)&&const DeepCollectionEquality().equals(other.day, _this.day)&&(identical(other.dayConfidence, _this.dayConfidence) || other.dayConfidence == _this.dayConfidence)&&const DeepCollectionEquality().equals(other.time, _this.time)&&(identical(other.timeConfidence, _this.timeConfidence) || other.timeConfidence == _this.timeConfidence));
}


@override
int get hashCode {
  final _this = this as ThoughtDecision;
  return Object.hash(runtimeType,_this.thought,_this.groupOption,_this.groupConfidence,_this.task,_this.alert,_this.recall,const DeepCollectionEquality().hash(_this.day),_this.dayConfidence,const DeepCollectionEquality().hash(_this.time),_this.timeConfidence);
}

@override
String toString() {
  final _this = this as ThoughtDecision;
  return 'ThoughtDecision(thought: ${_this.thought}, groupOption: ${_this.groupOption}, groupConfidence: ${_this.groupConfidence}, task: ${_this.task}, alert: ${_this.alert}, recall: ${_this.recall}, day: ${_this.day}, dayConfidence: ${_this.dayConfidence}, time: ${_this.time}, timeConfidence: ${_this.timeConfidence})';
}


}

/// @nodoc
abstract mixin class $ThoughtDecisionCopyWith<$Res>  {
  factory $ThoughtDecisionCopyWith(ThoughtDecision value, $Res Function(ThoughtDecision) _then) = _$ThoughtDecisionCopyWithImpl;
@useResult
$Res call({
 Thought thought, String groupOption, double groupConfidence, double task, double alert, double recall, DayCandidate? day, double dayConfidence, TimeCandidate? time, double timeConfidence
});


$ThoughtCopyWith<$Res> get thought;

}
/// @nodoc
class _$ThoughtDecisionCopyWithImpl<$Res>
    implements $ThoughtDecisionCopyWith<$Res> {
  _$ThoughtDecisionCopyWithImpl(this._self, this._then);

  final ThoughtDecision _self;
  final $Res Function(ThoughtDecision) _then;

/// Create a copy of ThoughtDecision
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? thought = null,Object? groupOption = null,Object? groupConfidence = null,Object? task = null,Object? alert = null,Object? recall = null,Object? day = freezed,Object? dayConfidence = null,Object? time = freezed,Object? timeConfidence = null,}) {
  return _then(ThoughtDecision(
thought: null == thought ? _self.thought : thought // ignore: cast_nullable_to_non_nullable
as Thought,groupOption: null == groupOption ? _self.groupOption : groupOption // ignore: cast_nullable_to_non_nullable
as String,groupConfidence: null == groupConfidence ? _self.groupConfidence : groupConfidence // ignore: cast_nullable_to_non_nullable
as double,task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as double,alert: null == alert ? _self.alert : alert // ignore: cast_nullable_to_non_nullable
as double,recall: null == recall ? _self.recall : recall // ignore: cast_nullable_to_non_nullable
as double,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DayCandidate?,dayConfidence: null == dayConfidence ? _self.dayConfidence : dayConfidence // ignore: cast_nullable_to_non_nullable
as double,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeCandidate?,timeConfidence: null == timeConfidence ? _self.timeConfidence : timeConfidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of ThoughtDecision
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ThoughtCopyWith<$Res> get thought {
  
  return $ThoughtCopyWith<$Res>(_self.thought, (value) {
    return _then(_self.copyWith(thought: value));
  });
}
}


/// Adds pattern-matching-related methods to [ThoughtDecision].
extension ThoughtDecisionPatterns on ThoughtDecision {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ThoughtDecision value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ThoughtDecision() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ThoughtDecision value)  $default,){
final _that = this;
switch (_that) {
case _ThoughtDecision():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ThoughtDecision value)?  $default,){
final _that = this;
switch (_that) {
case _ThoughtDecision() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Thought thought,  String groupOption,  double groupConfidence,  double task,  double alert,  double recall,  DayCandidate? day,  double dayConfidence,  TimeCandidate? time,  double timeConfidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ThoughtDecision() when $default != null:
return $default(_that.thought,_that.groupOption,_that.groupConfidence,_that.task,_that.alert,_that.recall,_that.day,_that.dayConfidence,_that.time,_that.timeConfidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Thought thought,  String groupOption,  double groupConfidence,  double task,  double alert,  double recall,  DayCandidate? day,  double dayConfidence,  TimeCandidate? time,  double timeConfidence)  $default,) {final _that = this;
switch (_that) {
case _ThoughtDecision():
return $default(_that.thought,_that.groupOption,_that.groupConfidence,_that.task,_that.alert,_that.recall,_that.day,_that.dayConfidence,_that.time,_that.timeConfidence);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Thought thought,  String groupOption,  double groupConfidence,  double task,  double alert,  double recall,  DayCandidate? day,  double dayConfidence,  TimeCandidate? time,  double timeConfidence)?  $default,) {final _that = this;
switch (_that) {
case _ThoughtDecision() when $default != null:
return $default(_that.thought,_that.groupOption,_that.groupConfidence,_that.task,_that.alert,_that.recall,_that.day,_that.dayConfidence,_that.time,_that.timeConfidence);case _:
  return null;

}
}

}

/// @nodoc


class _ThoughtDecision implements ThoughtDecision {
  const _ThoughtDecision({required this.thought, required this.groupOption, required this.groupConfidence, required this.task, required this.alert, required this.recall, this.day, this.dayConfidence = 1, this.time, this.timeConfidence = 1});
  

@override final  Thought thought;
@override final  String groupOption;
@override final  double groupConfidence;
/// P(yes) that the thought is a to-do.
@override final  double task;
/// P(yes) that the thought asks for a reminder.
@override final  double alert;
/// P(yes) that the thought asks the app to recall something.
@override final  double recall;
@override final  DayCandidate? day;
@override@JsonKey() final  double dayConfidence;
@override final  TimeCandidate? time;
@override@JsonKey() final  double timeConfidence;

/// Create a copy of ThoughtDecision
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThoughtDecisionCopyWith<_ThoughtDecision> get copyWith => __$ThoughtDecisionCopyWithImpl<_ThoughtDecision>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ThoughtDecision&&(identical(other.thought, thought) || other.thought == thought)&&(identical(other.groupOption, groupOption) || other.groupOption == groupOption)&&(identical(other.groupConfidence, groupConfidence) || other.groupConfidence == groupConfidence)&&(identical(other.task, task) || other.task == task)&&(identical(other.alert, alert) || other.alert == alert)&&(identical(other.recall, recall) || other.recall == recall)&&const DeepCollectionEquality().equals(other.day, day)&&(identical(other.dayConfidence, dayConfidence) || other.dayConfidence == dayConfidence)&&const DeepCollectionEquality().equals(other.time, time)&&(identical(other.timeConfidence, timeConfidence) || other.timeConfidence == timeConfidence));
}


@override
int get hashCode {
    return Object.hash(runtimeType,thought,groupOption,groupConfidence,task,alert,recall,const DeepCollectionEquality().hash(day),dayConfidence,const DeepCollectionEquality().hash(time),timeConfidence);
}

@override
String toString() {
    return 'ThoughtDecision(thought: $thought, groupOption: $groupOption, groupConfidence: $groupConfidence, task: $task, alert: $alert, recall: $recall, day: $day, dayConfidence: $dayConfidence, time: $time, timeConfidence: $timeConfidence)';
}


}

/// @nodoc
abstract mixin class _$ThoughtDecisionCopyWith<$Res> implements $ThoughtDecisionCopyWith<$Res> {
  factory _$ThoughtDecisionCopyWith(_ThoughtDecision value, $Res Function(_ThoughtDecision) _then) = __$ThoughtDecisionCopyWithImpl;
@override @useResult
$Res call({
 Thought thought, String groupOption, double groupConfidence, double task, double alert, double recall, DayCandidate? day, double dayConfidence, TimeCandidate? time, double timeConfidence
});


@override $ThoughtCopyWith<$Res> get thought;

}
/// @nodoc
class __$ThoughtDecisionCopyWithImpl<$Res>
    implements _$ThoughtDecisionCopyWith<$Res> {
  __$ThoughtDecisionCopyWithImpl(this._self, this._then);

  final _ThoughtDecision _self;
  final $Res Function(_ThoughtDecision) _then;

/// Create a copy of ThoughtDecision
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? thought = null,Object? groupOption = null,Object? groupConfidence = null,Object? task = null,Object? alert = null,Object? recall = null,Object? day = freezed,Object? dayConfidence = null,Object? time = freezed,Object? timeConfidence = null,}) {
  return _then(_ThoughtDecision(
thought: null == thought ? _self.thought : thought // ignore: cast_nullable_to_non_nullable
as Thought,groupOption: null == groupOption ? _self.groupOption : groupOption // ignore: cast_nullable_to_non_nullable
as String,groupConfidence: null == groupConfidence ? _self.groupConfidence : groupConfidence // ignore: cast_nullable_to_non_nullable
as double,task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as double,alert: null == alert ? _self.alert : alert // ignore: cast_nullable_to_non_nullable
as double,recall: null == recall ? _self.recall : recall // ignore: cast_nullable_to_non_nullable
as double,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DayCandidate?,dayConfidence: null == dayConfidence ? _self.dayConfidence : dayConfidence // ignore: cast_nullable_to_non_nullable
as double,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeCandidate?,timeConfidence: null == timeConfidence ? _self.timeConfidence : timeConfidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of ThoughtDecision
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ThoughtCopyWith<$Res> get thought {
  
  return $ThoughtCopyWith<$Res>(_self.thought, (value) {
    return _then(_self.copyWith(thought: value));
  });
}
}

// dart format on
