// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'classification_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClassificationPlan {

 JevState get state; Map<String, JevQuestion> get questions;/// Option name → group id (null for the implicit Unsorted fallback).
 Map<String, NotionId?> get groupOptions;/// The user's active Unsorted group, filed to when an option has no id.
 NotionId? get unsortedGroupId;/// Date/time candidates per thought id.
 Map<String, FoundCandidates> get candidates;
/// Create a copy of ClassificationPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassificationPlanCopyWith<ClassificationPlan> get copyWith => _$ClassificationPlanCopyWithImpl<ClassificationPlan>(this as ClassificationPlan, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ClassificationPlan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassificationPlan&&(identical(other.state, _this.state) || other.state == _this.state)&&const DeepCollectionEquality().equals(other.questions, _this.questions)&&const DeepCollectionEquality().equals(other.groupOptions, _this.groupOptions)&&(identical(other.unsortedGroupId, _this.unsortedGroupId) || other.unsortedGroupId == _this.unsortedGroupId)&&const DeepCollectionEquality().equals(other.candidates, _this.candidates));
}


@override
int get hashCode {
  final _this = this as ClassificationPlan;
  return Object.hash(runtimeType,_this.state,const DeepCollectionEquality().hash(_this.questions),const DeepCollectionEquality().hash(_this.groupOptions),_this.unsortedGroupId,const DeepCollectionEquality().hash(_this.candidates));
}

@override
String toString() {
  final _this = this as ClassificationPlan;
  return 'ClassificationPlan(state: ${_this.state}, questions: ${_this.questions}, groupOptions: ${_this.groupOptions}, unsortedGroupId: ${_this.unsortedGroupId}, candidates: ${_this.candidates})';
}


}

/// @nodoc
abstract mixin class $ClassificationPlanCopyWith<$Res>  {
  factory $ClassificationPlanCopyWith(ClassificationPlan value, $Res Function(ClassificationPlan) _then) = _$ClassificationPlanCopyWithImpl;
@useResult
$Res call({
 JevState state, Map<String, JevQuestion> questions, Map<String, NotionId?> groupOptions, NotionId? unsortedGroupId, Map<String, FoundCandidates> candidates
});




}
/// @nodoc
class _$ClassificationPlanCopyWithImpl<$Res>
    implements $ClassificationPlanCopyWith<$Res> {
  _$ClassificationPlanCopyWithImpl(this._self, this._then);

  final ClassificationPlan _self;
  final $Res Function(ClassificationPlan) _then;

/// Create a copy of ClassificationPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? state = null,Object? questions = null,Object? groupOptions = null,Object? unsortedGroupId = freezed,Object? candidates = null,}) {
  return _then(ClassificationPlan(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as JevState,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as Map<String, JevQuestion>,groupOptions: null == groupOptions ? _self.groupOptions : groupOptions // ignore: cast_nullable_to_non_nullable
as Map<String, NotionId?>,unsortedGroupId: freezed == unsortedGroupId ? _self.unsortedGroupId : unsortedGroupId // ignore: cast_nullable_to_non_nullable
as NotionId?,candidates: null == candidates ? _self.candidates : candidates // ignore: cast_nullable_to_non_nullable
as Map<String, FoundCandidates>,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassificationPlan].
extension ClassificationPlanPatterns on ClassificationPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassificationPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassificationPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassificationPlan value)  $default,){
final _that = this;
switch (_that) {
case _ClassificationPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassificationPlan value)?  $default,){
final _that = this;
switch (_that) {
case _ClassificationPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( JevState state,  Map<String, JevQuestion> questions,  Map<String, NotionId?> groupOptions,  NotionId? unsortedGroupId,  Map<String, FoundCandidates> candidates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassificationPlan() when $default != null:
return $default(_that.state,_that.questions,_that.groupOptions,_that.unsortedGroupId,_that.candidates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( JevState state,  Map<String, JevQuestion> questions,  Map<String, NotionId?> groupOptions,  NotionId? unsortedGroupId,  Map<String, FoundCandidates> candidates)  $default,) {final _that = this;
switch (_that) {
case _ClassificationPlan():
return $default(_that.state,_that.questions,_that.groupOptions,_that.unsortedGroupId,_that.candidates);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( JevState state,  Map<String, JevQuestion> questions,  Map<String, NotionId?> groupOptions,  NotionId? unsortedGroupId,  Map<String, FoundCandidates> candidates)?  $default,) {final _that = this;
switch (_that) {
case _ClassificationPlan() when $default != null:
return $default(_that.state,_that.questions,_that.groupOptions,_that.unsortedGroupId,_that.candidates);case _:
  return null;

}
}

}

/// @nodoc


class _ClassificationPlan implements ClassificationPlan {
  const _ClassificationPlan({required this.state, required  Map<String, JevQuestion> questions, required  Map<String, NotionId?> groupOptions, required this.unsortedGroupId, required  Map<String, FoundCandidates> candidates}): _questions = questions,_groupOptions = groupOptions,_candidates = candidates;
  

@override final  JevState state;
 final  Map<String, JevQuestion> _questions;
@override Map<String, JevQuestion> get questions {
  if (_questions is EqualUnmodifiableMapView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_questions);
}

/// Option name → group id (null for the implicit Unsorted fallback).
 final  Map<String, NotionId?> _groupOptions;
/// Option name → group id (null for the implicit Unsorted fallback).
@override Map<String, NotionId?> get groupOptions {
  if (_groupOptions is EqualUnmodifiableMapView) return _groupOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_groupOptions);
}

/// The user's active Unsorted group, filed to when an option has no id.
@override final  NotionId? unsortedGroupId;
/// Date/time candidates per thought id.
 final  Map<String, FoundCandidates> _candidates;
/// Date/time candidates per thought id.
@override Map<String, FoundCandidates> get candidates {
  if (_candidates is EqualUnmodifiableMapView) return _candidates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_candidates);
}


/// Create a copy of ClassificationPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassificationPlanCopyWith<_ClassificationPlan> get copyWith => __$ClassificationPlanCopyWithImpl<_ClassificationPlan>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassificationPlan&&(identical(other.state, state) || other.state == state)&&const DeepCollectionEquality().equals(other.questions, _questions)&&const DeepCollectionEquality().equals(other.groupOptions, _groupOptions)&&(identical(other.unsortedGroupId, unsortedGroupId) || other.unsortedGroupId == unsortedGroupId)&&const DeepCollectionEquality().equals(other.candidates, _candidates));
}


@override
int get hashCode {
    return Object.hash(runtimeType,state,const DeepCollectionEquality().hash(_questions),const DeepCollectionEquality().hash(_groupOptions),unsortedGroupId,const DeepCollectionEquality().hash(_candidates));
}

@override
String toString() {
    return 'ClassificationPlan(state: $state, questions: $questions, groupOptions: $groupOptions, unsortedGroupId: $unsortedGroupId, candidates: $candidates)';
}


}

/// @nodoc
abstract mixin class _$ClassificationPlanCopyWith<$Res> implements $ClassificationPlanCopyWith<$Res> {
  factory _$ClassificationPlanCopyWith(_ClassificationPlan value, $Res Function(_ClassificationPlan) _then) = __$ClassificationPlanCopyWithImpl;
@override @useResult
$Res call({
 JevState state, Map<String, JevQuestion> questions, Map<String, NotionId?> groupOptions, NotionId? unsortedGroupId, Map<String, FoundCandidates> candidates
});




}
/// @nodoc
class __$ClassificationPlanCopyWithImpl<$Res>
    implements _$ClassificationPlanCopyWith<$Res> {
  __$ClassificationPlanCopyWithImpl(this._self, this._then);

  final _ClassificationPlan _self;
  final $Res Function(_ClassificationPlan) _then;

/// Create a copy of ClassificationPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? state = null,Object? questions = null,Object? groupOptions = null,Object? unsortedGroupId = freezed,Object? candidates = null,}) {
  return _then(_ClassificationPlan(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as JevState,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as Map<String, JevQuestion>,groupOptions: null == groupOptions ? _self._groupOptions : groupOptions // ignore: cast_nullable_to_non_nullable
as Map<String, NotionId?>,unsortedGroupId: freezed == unsortedGroupId ? _self.unsortedGroupId : unsortedGroupId // ignore: cast_nullable_to_non_nullable
as NotionId?,candidates: null == candidates ? _self._candidates : candidates // ignore: cast_nullable_to_non_nullable
as Map<String, FoundCandidates>,
  ));
}


}

// dart format on
