// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'capture_flow_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CaptureFlowState {

/// Newest first.
 List<CaptureRecord> get captures; CapturePhase get phase; String? get activeId; CaptureNotice? get notice; CaptureFailure? get failure;/// Page the main window should open; acted on once per serial.
 ShellDestination? get destination; String? get editId; int get destinationSerial;/// The latest capture saved without the review card, for its
/// notification.
 String? get autoSavedId;
/// Create a copy of CaptureFlowState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CaptureFlowStateCopyWith<CaptureFlowState> get copyWith => _$CaptureFlowStateCopyWithImpl<CaptureFlowState>(this as CaptureFlowState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CaptureFlowState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CaptureFlowState&&const DeepCollectionEquality().equals(other.captures, _this.captures)&&(identical(other.phase, _this.phase) || other.phase == _this.phase)&&(identical(other.activeId, _this.activeId) || other.activeId == _this.activeId)&&(identical(other.notice, _this.notice) || other.notice == _this.notice)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.destination, _this.destination) || other.destination == _this.destination)&&(identical(other.editId, _this.editId) || other.editId == _this.editId)&&(identical(other.destinationSerial, _this.destinationSerial) || other.destinationSerial == _this.destinationSerial)&&(identical(other.autoSavedId, _this.autoSavedId) || other.autoSavedId == _this.autoSavedId));
}


@override
int get hashCode {
  final _this = this as CaptureFlowState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.captures),_this.phase,_this.activeId,_this.notice,_this.failure,_this.destination,_this.editId,_this.destinationSerial,_this.autoSavedId);
}

@override
String toString() {
  final _this = this as CaptureFlowState;
  return 'CaptureFlowState(captures: ${_this.captures}, phase: ${_this.phase}, activeId: ${_this.activeId}, notice: ${_this.notice}, failure: ${_this.failure}, destination: ${_this.destination}, editId: ${_this.editId}, destinationSerial: ${_this.destinationSerial}, autoSavedId: ${_this.autoSavedId})';
}


}

/// @nodoc
abstract mixin class $CaptureFlowStateCopyWith<$Res>  {
  factory $CaptureFlowStateCopyWith(CaptureFlowState value, $Res Function(CaptureFlowState) _then) = _$CaptureFlowStateCopyWithImpl;
@useResult
$Res call({
 List<CaptureRecord> captures, CapturePhase phase, String? activeId, CaptureNotice? notice, CaptureFailure? failure, ShellDestination? destination, String? editId, int destinationSerial, String? autoSavedId
});




}
/// @nodoc
class _$CaptureFlowStateCopyWithImpl<$Res>
    implements $CaptureFlowStateCopyWith<$Res> {
  _$CaptureFlowStateCopyWithImpl(this._self, this._then);

  final CaptureFlowState _self;
  final $Res Function(CaptureFlowState) _then;

/// Create a copy of CaptureFlowState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? captures = null,Object? phase = null,Object? activeId = freezed,Object? notice = freezed,Object? failure = freezed,Object? destination = freezed,Object? editId = freezed,Object? destinationSerial = null,Object? autoSavedId = freezed,}) {
  return _then(CaptureFlowState(
captures: null == captures ? _self.captures : captures // ignore: cast_nullable_to_non_nullable
as List<CaptureRecord>,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as CapturePhase,activeId: freezed == activeId ? _self.activeId : activeId // ignore: cast_nullable_to_non_nullable
as String?,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as CaptureNotice?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as CaptureFailure?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as ShellDestination?,editId: freezed == editId ? _self.editId : editId // ignore: cast_nullable_to_non_nullable
as String?,destinationSerial: null == destinationSerial ? _self.destinationSerial : destinationSerial // ignore: cast_nullable_to_non_nullable
as int,autoSavedId: freezed == autoSavedId ? _self.autoSavedId : autoSavedId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CaptureFlowState].
extension CaptureFlowStatePatterns on CaptureFlowState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CaptureFlowState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CaptureFlowState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CaptureFlowState value)  $default,){
final _that = this;
switch (_that) {
case _CaptureFlowState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CaptureFlowState value)?  $default,){
final _that = this;
switch (_that) {
case _CaptureFlowState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CaptureRecord> captures,  CapturePhase phase,  String? activeId,  CaptureNotice? notice,  CaptureFailure? failure,  ShellDestination? destination,  String? editId,  int destinationSerial,  String? autoSavedId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CaptureFlowState() when $default != null:
return $default(_that.captures,_that.phase,_that.activeId,_that.notice,_that.failure,_that.destination,_that.editId,_that.destinationSerial,_that.autoSavedId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CaptureRecord> captures,  CapturePhase phase,  String? activeId,  CaptureNotice? notice,  CaptureFailure? failure,  ShellDestination? destination,  String? editId,  int destinationSerial,  String? autoSavedId)  $default,) {final _that = this;
switch (_that) {
case _CaptureFlowState():
return $default(_that.captures,_that.phase,_that.activeId,_that.notice,_that.failure,_that.destination,_that.editId,_that.destinationSerial,_that.autoSavedId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CaptureRecord> captures,  CapturePhase phase,  String? activeId,  CaptureNotice? notice,  CaptureFailure? failure,  ShellDestination? destination,  String? editId,  int destinationSerial,  String? autoSavedId)?  $default,) {final _that = this;
switch (_that) {
case _CaptureFlowState() when $default != null:
return $default(_that.captures,_that.phase,_that.activeId,_that.notice,_that.failure,_that.destination,_that.editId,_that.destinationSerial,_that.autoSavedId);case _:
  return null;

}
}

}

/// @nodoc


class _CaptureFlowState extends CaptureFlowState {
  const _CaptureFlowState({required  List<CaptureRecord> captures, this.phase = CapturePhase.idle, this.activeId, this.notice, this.failure, this.destination, this.editId, this.destinationSerial = 0, this.autoSavedId}): _captures = captures,super._();
  

/// Newest first.
 final  List<CaptureRecord> _captures;
/// Newest first.
@override List<CaptureRecord> get captures {
  if (_captures is EqualUnmodifiableListView) return _captures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_captures);
}

@override@JsonKey() final  CapturePhase phase;
@override final  String? activeId;
@override final  CaptureNotice? notice;
@override final  CaptureFailure? failure;
/// Page the main window should open; acted on once per serial.
@override final  ShellDestination? destination;
@override final  String? editId;
@override@JsonKey() final  int destinationSerial;
/// The latest capture saved without the review card, for its
/// notification.
@override final  String? autoSavedId;

/// Create a copy of CaptureFlowState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CaptureFlowStateCopyWith<_CaptureFlowState> get copyWith => __$CaptureFlowStateCopyWithImpl<_CaptureFlowState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CaptureFlowState&&const DeepCollectionEquality().equals(other.captures, _captures)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.activeId, activeId) || other.activeId == activeId)&&(identical(other.notice, notice) || other.notice == notice)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.editId, editId) || other.editId == editId)&&(identical(other.destinationSerial, destinationSerial) || other.destinationSerial == destinationSerial)&&(identical(other.autoSavedId, autoSavedId) || other.autoSavedId == autoSavedId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_captures),phase,activeId,notice,failure,destination,editId,destinationSerial,autoSavedId);
}

@override
String toString() {
    return 'CaptureFlowState(captures: $captures, phase: $phase, activeId: $activeId, notice: $notice, failure: $failure, destination: $destination, editId: $editId, destinationSerial: $destinationSerial, autoSavedId: $autoSavedId)';
}


}

/// @nodoc
abstract mixin class _$CaptureFlowStateCopyWith<$Res> implements $CaptureFlowStateCopyWith<$Res> {
  factory _$CaptureFlowStateCopyWith(_CaptureFlowState value, $Res Function(_CaptureFlowState) _then) = __$CaptureFlowStateCopyWithImpl;
@override @useResult
$Res call({
 List<CaptureRecord> captures, CapturePhase phase, String? activeId, CaptureNotice? notice, CaptureFailure? failure, ShellDestination? destination, String? editId, int destinationSerial, String? autoSavedId
});




}
/// @nodoc
class __$CaptureFlowStateCopyWithImpl<$Res>
    implements _$CaptureFlowStateCopyWith<$Res> {
  __$CaptureFlowStateCopyWithImpl(this._self, this._then);

  final _CaptureFlowState _self;
  final $Res Function(_CaptureFlowState) _then;

/// Create a copy of CaptureFlowState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? captures = null,Object? phase = null,Object? activeId = freezed,Object? notice = freezed,Object? failure = freezed,Object? destination = freezed,Object? editId = freezed,Object? destinationSerial = null,Object? autoSavedId = freezed,}) {
  return _then(_CaptureFlowState(
captures: null == captures ? _self._captures : captures // ignore: cast_nullable_to_non_nullable
as List<CaptureRecord>,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as CapturePhase,activeId: freezed == activeId ? _self.activeId : activeId // ignore: cast_nullable_to_non_nullable
as String?,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as CaptureNotice?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as CaptureFailure?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as ShellDestination?,editId: freezed == editId ? _self.editId : editId // ignore: cast_nullable_to_non_nullable
as String?,destinationSerial: null == destinationSerial ? _self.destinationSerial : destinationSerial // ignore: cast_nullable_to_non_nullable
as int,autoSavedId: freezed == autoSavedId ? _self.autoSavedId : autoSavedId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
