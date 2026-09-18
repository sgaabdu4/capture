// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'groups_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GroupsState {

/// Sorted by name; archived groups included.
 List<Group> get groups; bool get busy; NotionFailure? get failure;/// Bumped with each failure so the screen shows it once.
 int get failureSerial;
/// Create a copy of GroupsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupsStateCopyWith<GroupsState> get copyWith => _$GroupsStateCopyWithImpl<GroupsState>(this as GroupsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GroupsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupsState&&const DeepCollectionEquality().equals(other.groups, _this.groups)&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.failureSerial, _this.failureSerial) || other.failureSerial == _this.failureSerial));
}


@override
int get hashCode {
  final _this = this as GroupsState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.groups),_this.busy,_this.failure,_this.failureSerial);
}

@override
String toString() {
  final _this = this as GroupsState;
  return 'GroupsState(groups: ${_this.groups}, busy: ${_this.busy}, failure: ${_this.failure}, failureSerial: ${_this.failureSerial})';
}


}

/// @nodoc
abstract mixin class $GroupsStateCopyWith<$Res>  {
  factory $GroupsStateCopyWith(GroupsState value, $Res Function(GroupsState) _then) = _$GroupsStateCopyWithImpl;
@useResult
$Res call({
 List<Group> groups, bool busy, NotionFailure? failure, int failureSerial
});




}
/// @nodoc
class _$GroupsStateCopyWithImpl<$Res>
    implements $GroupsStateCopyWith<$Res> {
  _$GroupsStateCopyWithImpl(this._self, this._then);

  final GroupsState _self;
  final $Res Function(GroupsState) _then;

/// Create a copy of GroupsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groups = null,Object? busy = null,Object? failure = freezed,Object? failureSerial = null,}) {
  return _then(GroupsState(
groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<Group>,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as NotionFailure?,failureSerial: null == failureSerial ? _self.failureSerial : failureSerial // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupsState].
extension GroupsStatePatterns on GroupsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupsState value)  $default,){
final _that = this;
switch (_that) {
case _GroupsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupsState value)?  $default,){
final _that = this;
switch (_that) {
case _GroupsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Group> groups,  bool busy,  NotionFailure? failure,  int failureSerial)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupsState() when $default != null:
return $default(_that.groups,_that.busy,_that.failure,_that.failureSerial);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Group> groups,  bool busy,  NotionFailure? failure,  int failureSerial)  $default,) {final _that = this;
switch (_that) {
case _GroupsState():
return $default(_that.groups,_that.busy,_that.failure,_that.failureSerial);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Group> groups,  bool busy,  NotionFailure? failure,  int failureSerial)?  $default,) {final _that = this;
switch (_that) {
case _GroupsState() when $default != null:
return $default(_that.groups,_that.busy,_that.failure,_that.failureSerial);case _:
  return null;

}
}

}

/// @nodoc


class _GroupsState extends GroupsState {
  const _GroupsState({required  List<Group> groups, this.busy = false, this.failure, this.failureSerial = 0}): _groups = groups,super._();
  

/// Sorted by name; archived groups included.
 final  List<Group> _groups;
/// Sorted by name; archived groups included.
@override List<Group> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

@override@JsonKey() final  bool busy;
@override final  NotionFailure? failure;
/// Bumped with each failure so the screen shows it once.
@override@JsonKey() final  int failureSerial;

/// Create a copy of GroupsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupsStateCopyWith<_GroupsState> get copyWith => __$GroupsStateCopyWithImpl<_GroupsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupsState&&const DeepCollectionEquality().equals(other.groups, _groups)&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.failureSerial, failureSerial) || other.failureSerial == failureSerial));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_groups),busy,failure,failureSerial);
}

@override
String toString() {
    return 'GroupsState(groups: $groups, busy: $busy, failure: $failure, failureSerial: $failureSerial)';
}


}

/// @nodoc
abstract mixin class _$GroupsStateCopyWith<$Res> implements $GroupsStateCopyWith<$Res> {
  factory _$GroupsStateCopyWith(_GroupsState value, $Res Function(_GroupsState) _then) = __$GroupsStateCopyWithImpl;
@override @useResult
$Res call({
 List<Group> groups, bool busy, NotionFailure? failure, int failureSerial
});




}
/// @nodoc
class __$GroupsStateCopyWithImpl<$Res>
    implements _$GroupsStateCopyWith<$Res> {
  __$GroupsStateCopyWithImpl(this._self, this._then);

  final _GroupsState _self;
  final $Res Function(_GroupsState) _then;

/// Create a copy of GroupsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groups = null,Object? busy = null,Object? failure = freezed,Object? failureSerial = null,}) {
  return _then(_GroupsState(
groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<Group>,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as NotionFailure?,failureSerial: null == failureSerial ? _self.failureSerial : failureSerial // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
