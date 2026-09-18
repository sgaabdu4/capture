// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryEntryModel {

 String get pageId; String get itemId; String get title; ItemKind get kind; String? get groupId; DueDateModel? get due; DueDateModel? get reminder; bool get done; String? get captureId;
/// Create a copy of LibraryEntryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryEntryModelCopyWith<LibraryEntryModel> get copyWith => _$LibraryEntryModelCopyWithImpl<LibraryEntryModel>(this as LibraryEntryModel, _$identity);

  /// Serializes this LibraryEntryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LibraryEntryModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryEntryModel&&(identical(other.pageId, _this.pageId) || other.pageId == _this.pageId)&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.groupId, _this.groupId) || other.groupId == _this.groupId)&&(identical(other.due, _this.due) || other.due == _this.due)&&(identical(other.reminder, _this.reminder) || other.reminder == _this.reminder)&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.captureId, _this.captureId) || other.captureId == _this.captureId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LibraryEntryModel;
  return Object.hash(runtimeType,_this.pageId,_this.itemId,_this.title,_this.kind,_this.groupId,_this.due,_this.reminder,_this.done,_this.captureId);
}

@override
String toString() {
  final _this = this as LibraryEntryModel;
  return 'LibraryEntryModel(pageId: ${_this.pageId}, itemId: ${_this.itemId}, title: ${_this.title}, kind: ${_this.kind}, groupId: ${_this.groupId}, due: ${_this.due}, reminder: ${_this.reminder}, done: ${_this.done}, captureId: ${_this.captureId})';
}


}

/// @nodoc
abstract mixin class $LibraryEntryModelCopyWith<$Res>  {
  factory $LibraryEntryModelCopyWith(LibraryEntryModel value, $Res Function(LibraryEntryModel) _then) = _$LibraryEntryModelCopyWithImpl;
@useResult
$Res call({
 String pageId, String itemId, String title, ItemKind kind, String? groupId, DueDateModel? due, DueDateModel? reminder, bool done, String? captureId
});


$DueDateModelCopyWith<$Res>? get due;$DueDateModelCopyWith<$Res>? get reminder;

}
/// @nodoc
class _$LibraryEntryModelCopyWithImpl<$Res>
    implements $LibraryEntryModelCopyWith<$Res> {
  _$LibraryEntryModelCopyWithImpl(this._self, this._then);

  final LibraryEntryModel _self;
  final $Res Function(LibraryEntryModel) _then;

/// Create a copy of LibraryEntryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pageId = null,Object? itemId = null,Object? title = null,Object? kind = null,Object? groupId = freezed,Object? due = freezed,Object? reminder = freezed,Object? done = null,Object? captureId = freezed,}) {
  return _then(LibraryEntryModel(
pageId: null == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ItemKind,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,due: freezed == due ? _self.due : due // ignore: cast_nullable_to_non_nullable
as DueDateModel?,reminder: freezed == reminder ? _self.reminder : reminder // ignore: cast_nullable_to_non_nullable
as DueDateModel?,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,captureId: freezed == captureId ? _self.captureId : captureId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of LibraryEntryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DueDateModelCopyWith<$Res>? get due {
    if (_self.due == null) {
    return null;
  }

  return $DueDateModelCopyWith<$Res>(_self.due!, (value) {
    return _then(_self.copyWith(due: value));
  });
}/// Create a copy of LibraryEntryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DueDateModelCopyWith<$Res>? get reminder {
    if (_self.reminder == null) {
    return null;
  }

  return $DueDateModelCopyWith<$Res>(_self.reminder!, (value) {
    return _then(_self.copyWith(reminder: value));
  });
}
}


/// Adds pattern-matching-related methods to [LibraryEntryModel].
extension LibraryEntryModelPatterns on LibraryEntryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryEntryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryEntryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryEntryModel value)  $default,){
final _that = this;
switch (_that) {
case _LibraryEntryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryEntryModel value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryEntryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String pageId,  String itemId,  String title,  ItemKind kind,  String? groupId,  DueDateModel? due,  DueDateModel? reminder,  bool done,  String? captureId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryEntryModel() when $default != null:
return $default(_that.pageId,_that.itemId,_that.title,_that.kind,_that.groupId,_that.due,_that.reminder,_that.done,_that.captureId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String pageId,  String itemId,  String title,  ItemKind kind,  String? groupId,  DueDateModel? due,  DueDateModel? reminder,  bool done,  String? captureId)  $default,) {final _that = this;
switch (_that) {
case _LibraryEntryModel():
return $default(_that.pageId,_that.itemId,_that.title,_that.kind,_that.groupId,_that.due,_that.reminder,_that.done,_that.captureId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String pageId,  String itemId,  String title,  ItemKind kind,  String? groupId,  DueDateModel? due,  DueDateModel? reminder,  bool done,  String? captureId)?  $default,) {final _that = this;
switch (_that) {
case _LibraryEntryModel() when $default != null:
return $default(_that.pageId,_that.itemId,_that.title,_that.kind,_that.groupId,_that.due,_that.reminder,_that.done,_that.captureId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LibraryEntryModel extends LibraryEntryModel {
  const _LibraryEntryModel({required this.pageId, required this.itemId, required this.title, required this.kind, this.groupId, this.due, this.reminder, this.done = false, this.captureId}): super._();
  factory _LibraryEntryModel.fromJson(Map<String, dynamic> json) => _$LibraryEntryModelFromJson(json);

@override final  String pageId;
@override final  String itemId;
@override final  String title;
@override final  ItemKind kind;
@override final  String? groupId;
@override final  DueDateModel? due;
@override final  DueDateModel? reminder;
@override@JsonKey() final  bool done;
@override final  String? captureId;

/// Create a copy of LibraryEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryEntryModelCopyWith<_LibraryEntryModel> get copyWith => __$LibraryEntryModelCopyWithImpl<_LibraryEntryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryEntryModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryEntryModel&&(identical(other.pageId, pageId) || other.pageId == pageId)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.title, title) || other.title == title)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.due, due) || other.due == due)&&(identical(other.reminder, reminder) || other.reminder == reminder)&&(identical(other.done, done) || other.done == done)&&(identical(other.captureId, captureId) || other.captureId == captureId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,pageId,itemId,title,kind,groupId,due,reminder,done,captureId);
}

@override
String toString() {
    return 'LibraryEntryModel(pageId: $pageId, itemId: $itemId, title: $title, kind: $kind, groupId: $groupId, due: $due, reminder: $reminder, done: $done, captureId: $captureId)';
}


}

/// @nodoc
abstract mixin class _$LibraryEntryModelCopyWith<$Res> implements $LibraryEntryModelCopyWith<$Res> {
  factory _$LibraryEntryModelCopyWith(_LibraryEntryModel value, $Res Function(_LibraryEntryModel) _then) = __$LibraryEntryModelCopyWithImpl;
@override @useResult
$Res call({
 String pageId, String itemId, String title, ItemKind kind, String? groupId, DueDateModel? due, DueDateModel? reminder, bool done, String? captureId
});


@override $DueDateModelCopyWith<$Res>? get due;@override $DueDateModelCopyWith<$Res>? get reminder;

}
/// @nodoc
class __$LibraryEntryModelCopyWithImpl<$Res>
    implements _$LibraryEntryModelCopyWith<$Res> {
  __$LibraryEntryModelCopyWithImpl(this._self, this._then);

  final _LibraryEntryModel _self;
  final $Res Function(_LibraryEntryModel) _then;

/// Create a copy of LibraryEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pageId = null,Object? itemId = null,Object? title = null,Object? kind = null,Object? groupId = freezed,Object? due = freezed,Object? reminder = freezed,Object? done = null,Object? captureId = freezed,}) {
  return _then(_LibraryEntryModel(
pageId: null == pageId ? _self.pageId : pageId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ItemKind,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,due: freezed == due ? _self.due : due // ignore: cast_nullable_to_non_nullable
as DueDateModel?,reminder: freezed == reminder ? _self.reminder : reminder // ignore: cast_nullable_to_non_nullable
as DueDateModel?,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,captureId: freezed == captureId ? _self.captureId : captureId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of LibraryEntryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DueDateModelCopyWith<$Res>? get due {
    if (_self.due == null) {
    return null;
  }

  return $DueDateModelCopyWith<$Res>(_self.due!, (value) {
    return _then(_self.copyWith(due: value));
  });
}/// Create a copy of LibraryEntryModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DueDateModelCopyWith<$Res>? get reminder {
    if (_self.reminder == null) {
    return null;
  }

  return $DueDateModelCopyWith<$Res>(_self.reminder!, (value) {
    return _then(_self.copyWith(reminder: value));
  });
}
}

// dart format on
