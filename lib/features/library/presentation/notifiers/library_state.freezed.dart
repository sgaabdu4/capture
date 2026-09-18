// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LibraryState {

 List<LibraryEntry> get entries; bool get refreshing; NotionFailure? get failure; int get failureSerial; DateTime? get refreshedAtUtc;/// Text typed into search; empty when not searching.
 String get query;
/// Create a copy of LibraryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryStateCopyWith<LibraryState> get copyWith => _$LibraryStateCopyWithImpl<LibraryState>(this as LibraryState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LibraryState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryState&&const DeepCollectionEquality().equals(other.entries, _this.entries)&&(identical(other.refreshing, _this.refreshing) || other.refreshing == _this.refreshing)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.failureSerial, _this.failureSerial) || other.failureSerial == _this.failureSerial)&&(identical(other.refreshedAtUtc, _this.refreshedAtUtc) || other.refreshedAtUtc == _this.refreshedAtUtc)&&(identical(other.query, _this.query) || other.query == _this.query));
}


@override
int get hashCode {
  final _this = this as LibraryState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.entries),_this.refreshing,_this.failure,_this.failureSerial,_this.refreshedAtUtc,_this.query);
}

@override
String toString() {
  final _this = this as LibraryState;
  return 'LibraryState(entries: ${_this.entries}, refreshing: ${_this.refreshing}, failure: ${_this.failure}, failureSerial: ${_this.failureSerial}, refreshedAtUtc: ${_this.refreshedAtUtc}, query: ${_this.query})';
}


}

/// @nodoc
abstract mixin class $LibraryStateCopyWith<$Res>  {
  factory $LibraryStateCopyWith(LibraryState value, $Res Function(LibraryState) _then) = _$LibraryStateCopyWithImpl;
@useResult
$Res call({
 List<LibraryEntry> entries, bool refreshing, NotionFailure? failure, int failureSerial, DateTime? refreshedAtUtc, String query
});




}
/// @nodoc
class _$LibraryStateCopyWithImpl<$Res>
    implements $LibraryStateCopyWith<$Res> {
  _$LibraryStateCopyWithImpl(this._self, this._then);

  final LibraryState _self;
  final $Res Function(LibraryState) _then;

/// Create a copy of LibraryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? refreshing = null,Object? failure = freezed,Object? failureSerial = null,Object? refreshedAtUtc = freezed,Object? query = null,}) {
  return _then(LibraryState(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<LibraryEntry>,refreshing: null == refreshing ? _self.refreshing : refreshing // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as NotionFailure?,failureSerial: null == failureSerial ? _self.failureSerial : failureSerial // ignore: cast_nullable_to_non_nullable
as int,refreshedAtUtc: freezed == refreshedAtUtc ? _self.refreshedAtUtc : refreshedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryState].
extension LibraryStatePatterns on LibraryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryState value)  $default,){
final _that = this;
switch (_that) {
case _LibraryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryState value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LibraryEntry> entries,  bool refreshing,  NotionFailure? failure,  int failureSerial,  DateTime? refreshedAtUtc,  String query)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryState() when $default != null:
return $default(_that.entries,_that.refreshing,_that.failure,_that.failureSerial,_that.refreshedAtUtc,_that.query);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LibraryEntry> entries,  bool refreshing,  NotionFailure? failure,  int failureSerial,  DateTime? refreshedAtUtc,  String query)  $default,) {final _that = this;
switch (_that) {
case _LibraryState():
return $default(_that.entries,_that.refreshing,_that.failure,_that.failureSerial,_that.refreshedAtUtc,_that.query);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LibraryEntry> entries,  bool refreshing,  NotionFailure? failure,  int failureSerial,  DateTime? refreshedAtUtc,  String query)?  $default,) {final _that = this;
switch (_that) {
case _LibraryState() when $default != null:
return $default(_that.entries,_that.refreshing,_that.failure,_that.failureSerial,_that.refreshedAtUtc,_that.query);case _:
  return null;

}
}

}

/// @nodoc


class _LibraryState extends LibraryState {
  const _LibraryState({required  List<LibraryEntry> entries, this.refreshing = false, this.failure, this.failureSerial = 0, this.refreshedAtUtc, this.query = ''}): _entries = entries,super._();
  

 final  List<LibraryEntry> _entries;
@override List<LibraryEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@override@JsonKey() final  bool refreshing;
@override final  NotionFailure? failure;
@override@JsonKey() final  int failureSerial;
@override final  DateTime? refreshedAtUtc;
/// Text typed into search; empty when not searching.
@override@JsonKey() final  String query;

/// Create a copy of LibraryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryStateCopyWith<_LibraryState> get copyWith => __$LibraryStateCopyWithImpl<_LibraryState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryState&&const DeepCollectionEquality().equals(other.entries, _entries)&&(identical(other.refreshing, refreshing) || other.refreshing == refreshing)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.failureSerial, failureSerial) || other.failureSerial == failureSerial)&&(identical(other.refreshedAtUtc, refreshedAtUtc) || other.refreshedAtUtc == refreshedAtUtc)&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),refreshing,failure,failureSerial,refreshedAtUtc,query);
}

@override
String toString() {
    return 'LibraryState(entries: $entries, refreshing: $refreshing, failure: $failure, failureSerial: $failureSerial, refreshedAtUtc: $refreshedAtUtc, query: $query)';
}


}

/// @nodoc
abstract mixin class _$LibraryStateCopyWith<$Res> implements $LibraryStateCopyWith<$Res> {
  factory _$LibraryStateCopyWith(_LibraryState value, $Res Function(_LibraryState) _then) = __$LibraryStateCopyWithImpl;
@override @useResult
$Res call({
 List<LibraryEntry> entries, bool refreshing, NotionFailure? failure, int failureSerial, DateTime? refreshedAtUtc, String query
});




}
/// @nodoc
class __$LibraryStateCopyWithImpl<$Res>
    implements _$LibraryStateCopyWith<$Res> {
  __$LibraryStateCopyWithImpl(this._self, this._then);

  final _LibraryState _self;
  final $Res Function(_LibraryState) _then;

/// Create a copy of LibraryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? refreshing = null,Object? failure = freezed,Object? failureSerial = null,Object? refreshedAtUtc = freezed,Object? query = null,}) {
  return _then(_LibraryState(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<LibraryEntry>,refreshing: null == refreshing ? _self.refreshing : refreshing // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as NotionFailure?,failureSerial: null == failureSerial ? _self.failureSerial : failureSerial // ignore: cast_nullable_to_non_nullable
as int,refreshedAtUtc: freezed == refreshedAtUtc ? _self.refreshedAtUtc : refreshedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
