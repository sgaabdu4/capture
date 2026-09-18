// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'save_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SaveProgress {

 String? get capturePageId;/// Proposal item id → Notion Library page id.
 Map<String, String> get itemPages; String? get audioUploadId; bool get audioAttached; bool get markedSaved; Set<String> get remindersScheduled;
/// Create a copy of SaveProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaveProgressCopyWith<SaveProgress> get copyWith => _$SaveProgressCopyWithImpl<SaveProgress>(this as SaveProgress, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SaveProgress;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveProgress&&(identical(other.capturePageId, _this.capturePageId) || other.capturePageId == _this.capturePageId)&&const DeepCollectionEquality().equals(other.itemPages, _this.itemPages)&&(identical(other.audioUploadId, _this.audioUploadId) || other.audioUploadId == _this.audioUploadId)&&(identical(other.audioAttached, _this.audioAttached) || other.audioAttached == _this.audioAttached)&&(identical(other.markedSaved, _this.markedSaved) || other.markedSaved == _this.markedSaved)&&const DeepCollectionEquality().equals(other.remindersScheduled, _this.remindersScheduled));
}


@override
int get hashCode {
  final _this = this as SaveProgress;
  return Object.hash(runtimeType,_this.capturePageId,const DeepCollectionEquality().hash(_this.itemPages),_this.audioUploadId,_this.audioAttached,_this.markedSaved,const DeepCollectionEquality().hash(_this.remindersScheduled));
}

@override
String toString() {
  final _this = this as SaveProgress;
  return 'SaveProgress(capturePageId: ${_this.capturePageId}, itemPages: ${_this.itemPages}, audioUploadId: ${_this.audioUploadId}, audioAttached: ${_this.audioAttached}, markedSaved: ${_this.markedSaved}, remindersScheduled: ${_this.remindersScheduled})';
}


}

/// @nodoc
abstract mixin class $SaveProgressCopyWith<$Res>  {
  factory $SaveProgressCopyWith(SaveProgress value, $Res Function(SaveProgress) _then) = _$SaveProgressCopyWithImpl;
@useResult
$Res call({
 String? capturePageId, Map<String, String> itemPages, String? audioUploadId, bool audioAttached, bool markedSaved, Set<String> remindersScheduled
});




}
/// @nodoc
class _$SaveProgressCopyWithImpl<$Res>
    implements $SaveProgressCopyWith<$Res> {
  _$SaveProgressCopyWithImpl(this._self, this._then);

  final SaveProgress _self;
  final $Res Function(SaveProgress) _then;

/// Create a copy of SaveProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? capturePageId = freezed,Object? itemPages = null,Object? audioUploadId = freezed,Object? audioAttached = null,Object? markedSaved = null,Object? remindersScheduled = null,}) {
  return _then(SaveProgress(
capturePageId: freezed == capturePageId ? _self.capturePageId : capturePageId // ignore: cast_nullable_to_non_nullable
as String?,itemPages: null == itemPages ? _self.itemPages : itemPages // ignore: cast_nullable_to_non_nullable
as Map<String, String>,audioUploadId: freezed == audioUploadId ? _self.audioUploadId : audioUploadId // ignore: cast_nullable_to_non_nullable
as String?,audioAttached: null == audioAttached ? _self.audioAttached : audioAttached // ignore: cast_nullable_to_non_nullable
as bool,markedSaved: null == markedSaved ? _self.markedSaved : markedSaved // ignore: cast_nullable_to_non_nullable
as bool,remindersScheduled: null == remindersScheduled ? _self.remindersScheduled : remindersScheduled // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SaveProgress].
extension SaveProgressPatterns on SaveProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaveProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaveProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaveProgress value)  $default,){
final _that = this;
switch (_that) {
case _SaveProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaveProgress value)?  $default,){
final _that = this;
switch (_that) {
case _SaveProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? capturePageId,  Map<String, String> itemPages,  String? audioUploadId,  bool audioAttached,  bool markedSaved,  Set<String> remindersScheduled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaveProgress() when $default != null:
return $default(_that.capturePageId,_that.itemPages,_that.audioUploadId,_that.audioAttached,_that.markedSaved,_that.remindersScheduled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? capturePageId,  Map<String, String> itemPages,  String? audioUploadId,  bool audioAttached,  bool markedSaved,  Set<String> remindersScheduled)  $default,) {final _that = this;
switch (_that) {
case _SaveProgress():
return $default(_that.capturePageId,_that.itemPages,_that.audioUploadId,_that.audioAttached,_that.markedSaved,_that.remindersScheduled);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? capturePageId,  Map<String, String> itemPages,  String? audioUploadId,  bool audioAttached,  bool markedSaved,  Set<String> remindersScheduled)?  $default,) {final _that = this;
switch (_that) {
case _SaveProgress() when $default != null:
return $default(_that.capturePageId,_that.itemPages,_that.audioUploadId,_that.audioAttached,_that.markedSaved,_that.remindersScheduled);case _:
  return null;

}
}

}

/// @nodoc


class _SaveProgress implements SaveProgress {
  const _SaveProgress({this.capturePageId,  Map<String, String> itemPages = const {}, this.audioUploadId, this.audioAttached = false, this.markedSaved = false,  Set<String> remindersScheduled = const {}}): _itemPages = itemPages,_remindersScheduled = remindersScheduled;
  

@override final  String? capturePageId;
/// Proposal item id → Notion Library page id.
 final  Map<String, String> _itemPages;
/// Proposal item id → Notion Library page id.
@override@JsonKey() Map<String, String> get itemPages {
  if (_itemPages is EqualUnmodifiableMapView) return _itemPages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_itemPages);
}

@override final  String? audioUploadId;
@override@JsonKey() final  bool audioAttached;
@override@JsonKey() final  bool markedSaved;
 final  Set<String> _remindersScheduled;
@override@JsonKey() Set<String> get remindersScheduled {
  if (_remindersScheduled is EqualUnmodifiableSetView) return _remindersScheduled;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_remindersScheduled);
}


/// Create a copy of SaveProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveProgressCopyWith<_SaveProgress> get copyWith => __$SaveProgressCopyWithImpl<_SaveProgress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveProgress&&(identical(other.capturePageId, capturePageId) || other.capturePageId == capturePageId)&&const DeepCollectionEquality().equals(other.itemPages, _itemPages)&&(identical(other.audioUploadId, audioUploadId) || other.audioUploadId == audioUploadId)&&(identical(other.audioAttached, audioAttached) || other.audioAttached == audioAttached)&&(identical(other.markedSaved, markedSaved) || other.markedSaved == markedSaved)&&const DeepCollectionEquality().equals(other.remindersScheduled, _remindersScheduled));
}


@override
int get hashCode {
    return Object.hash(runtimeType,capturePageId,const DeepCollectionEquality().hash(_itemPages),audioUploadId,audioAttached,markedSaved,const DeepCollectionEquality().hash(_remindersScheduled));
}

@override
String toString() {
    return 'SaveProgress(capturePageId: $capturePageId, itemPages: $itemPages, audioUploadId: $audioUploadId, audioAttached: $audioAttached, markedSaved: $markedSaved, remindersScheduled: $remindersScheduled)';
}


}

/// @nodoc
abstract mixin class _$SaveProgressCopyWith<$Res> implements $SaveProgressCopyWith<$Res> {
  factory _$SaveProgressCopyWith(_SaveProgress value, $Res Function(_SaveProgress) _then) = __$SaveProgressCopyWithImpl;
@override @useResult
$Res call({
 String? capturePageId, Map<String, String> itemPages, String? audioUploadId, bool audioAttached, bool markedSaved, Set<String> remindersScheduled
});




}
/// @nodoc
class __$SaveProgressCopyWithImpl<$Res>
    implements _$SaveProgressCopyWith<$Res> {
  __$SaveProgressCopyWithImpl(this._self, this._then);

  final _SaveProgress _self;
  final $Res Function(_SaveProgress) _then;

/// Create a copy of SaveProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? capturePageId = freezed,Object? itemPages = null,Object? audioUploadId = freezed,Object? audioAttached = null,Object? markedSaved = null,Object? remindersScheduled = null,}) {
  return _then(_SaveProgress(
capturePageId: freezed == capturePageId ? _self.capturePageId : capturePageId // ignore: cast_nullable_to_non_nullable
as String?,itemPages: null == itemPages ? _self._itemPages : itemPages // ignore: cast_nullable_to_non_nullable
as Map<String, String>,audioUploadId: freezed == audioUploadId ? _self.audioUploadId : audioUploadId // ignore: cast_nullable_to_non_nullable
as String?,audioAttached: null == audioAttached ? _self.audioAttached : audioAttached // ignore: cast_nullable_to_non_nullable
as bool,markedSaved: null == markedSaved ? _self.markedSaved : markedSaved // ignore: cast_nullable_to_non_nullable
as bool,remindersScheduled: null == remindersScheduled ? _self._remindersScheduled : remindersScheduled // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
