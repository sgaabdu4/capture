// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notion_workspace.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotionWorkspace {

 String get parentPageId; String get areaPageId;/// Data source ids.
 String get groups; String get captures; String get library; int get maxUploadBytes; String? get workspaceName;
/// Create a copy of NotionWorkspace
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotionWorkspaceCopyWith<NotionWorkspace> get copyWith => _$NotionWorkspaceCopyWithImpl<NotionWorkspace>(this as NotionWorkspace, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as NotionWorkspace;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotionWorkspace&&(identical(other.parentPageId, _this.parentPageId) || other.parentPageId == _this.parentPageId)&&(identical(other.areaPageId, _this.areaPageId) || other.areaPageId == _this.areaPageId)&&(identical(other.groups, _this.groups) || other.groups == _this.groups)&&(identical(other.captures, _this.captures) || other.captures == _this.captures)&&(identical(other.library, _this.library) || other.library == _this.library)&&(identical(other.maxUploadBytes, _this.maxUploadBytes) || other.maxUploadBytes == _this.maxUploadBytes)&&(identical(other.workspaceName, _this.workspaceName) || other.workspaceName == _this.workspaceName));
}


@override
int get hashCode {
  final _this = this as NotionWorkspace;
  return Object.hash(runtimeType,_this.parentPageId,_this.areaPageId,_this.groups,_this.captures,_this.library,_this.maxUploadBytes,_this.workspaceName);
}

@override
String toString() {
  final _this = this as NotionWorkspace;
  return 'NotionWorkspace(parentPageId: ${_this.parentPageId}, areaPageId: ${_this.areaPageId}, groups: ${_this.groups}, captures: ${_this.captures}, library: ${_this.library}, maxUploadBytes: ${_this.maxUploadBytes}, workspaceName: ${_this.workspaceName})';
}


}

/// @nodoc
abstract mixin class $NotionWorkspaceCopyWith<$Res>  {
  factory $NotionWorkspaceCopyWith(NotionWorkspace value, $Res Function(NotionWorkspace) _then) = _$NotionWorkspaceCopyWithImpl;
@useResult
$Res call({
 String parentPageId, String areaPageId, String groups, String captures, String library, int maxUploadBytes, String? workspaceName
});




}
/// @nodoc
class _$NotionWorkspaceCopyWithImpl<$Res>
    implements $NotionWorkspaceCopyWith<$Res> {
  _$NotionWorkspaceCopyWithImpl(this._self, this._then);

  final NotionWorkspace _self;
  final $Res Function(NotionWorkspace) _then;

/// Create a copy of NotionWorkspace
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parentPageId = null,Object? areaPageId = null,Object? groups = null,Object? captures = null,Object? library = null,Object? maxUploadBytes = null,Object? workspaceName = freezed,}) {
  return _then(NotionWorkspace(
parentPageId: null == parentPageId ? _self.parentPageId : parentPageId // ignore: cast_nullable_to_non_nullable
as String,areaPageId: null == areaPageId ? _self.areaPageId : areaPageId // ignore: cast_nullable_to_non_nullable
as String,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as String,captures: null == captures ? _self.captures : captures // ignore: cast_nullable_to_non_nullable
as String,library: null == library ? _self.library : library // ignore: cast_nullable_to_non_nullable
as String,maxUploadBytes: null == maxUploadBytes ? _self.maxUploadBytes : maxUploadBytes // ignore: cast_nullable_to_non_nullable
as int,workspaceName: freezed == workspaceName ? _self.workspaceName : workspaceName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotionWorkspace].
extension NotionWorkspacePatterns on NotionWorkspace {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotionWorkspace value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotionWorkspace() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotionWorkspace value)  $default,){
final _that = this;
switch (_that) {
case _NotionWorkspace():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotionWorkspace value)?  $default,){
final _that = this;
switch (_that) {
case _NotionWorkspace() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String parentPageId,  String areaPageId,  String groups,  String captures,  String library,  int maxUploadBytes,  String? workspaceName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotionWorkspace() when $default != null:
return $default(_that.parentPageId,_that.areaPageId,_that.groups,_that.captures,_that.library,_that.maxUploadBytes,_that.workspaceName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String parentPageId,  String areaPageId,  String groups,  String captures,  String library,  int maxUploadBytes,  String? workspaceName)  $default,) {final _that = this;
switch (_that) {
case _NotionWorkspace():
return $default(_that.parentPageId,_that.areaPageId,_that.groups,_that.captures,_that.library,_that.maxUploadBytes,_that.workspaceName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String parentPageId,  String areaPageId,  String groups,  String captures,  String library,  int maxUploadBytes,  String? workspaceName)?  $default,) {final _that = this;
switch (_that) {
case _NotionWorkspace() when $default != null:
return $default(_that.parentPageId,_that.areaPageId,_that.groups,_that.captures,_that.library,_that.maxUploadBytes,_that.workspaceName);case _:
  return null;

}
}

}

/// @nodoc


class _NotionWorkspace implements NotionWorkspace {
  const _NotionWorkspace({required this.parentPageId, required this.areaPageId, required this.groups, required this.captures, required this.library, required this.maxUploadBytes, this.workspaceName});
  

@override final  String parentPageId;
@override final  String areaPageId;
/// Data source ids.
@override final  String groups;
@override final  String captures;
@override final  String library;
@override final  int maxUploadBytes;
@override final  String? workspaceName;

/// Create a copy of NotionWorkspace
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotionWorkspaceCopyWith<_NotionWorkspace> get copyWith => __$NotionWorkspaceCopyWithImpl<_NotionWorkspace>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotionWorkspace&&(identical(other.parentPageId, parentPageId) || other.parentPageId == parentPageId)&&(identical(other.areaPageId, areaPageId) || other.areaPageId == areaPageId)&&(identical(other.groups, groups) || other.groups == groups)&&(identical(other.captures, captures) || other.captures == captures)&&(identical(other.library, library) || other.library == library)&&(identical(other.maxUploadBytes, maxUploadBytes) || other.maxUploadBytes == maxUploadBytes)&&(identical(other.workspaceName, workspaceName) || other.workspaceName == workspaceName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,parentPageId,areaPageId,groups,captures,library,maxUploadBytes,workspaceName);
}

@override
String toString() {
    return 'NotionWorkspace(parentPageId: $parentPageId, areaPageId: $areaPageId, groups: $groups, captures: $captures, library: $library, maxUploadBytes: $maxUploadBytes, workspaceName: $workspaceName)';
}


}

/// @nodoc
abstract mixin class _$NotionWorkspaceCopyWith<$Res> implements $NotionWorkspaceCopyWith<$Res> {
  factory _$NotionWorkspaceCopyWith(_NotionWorkspace value, $Res Function(_NotionWorkspace) _then) = __$NotionWorkspaceCopyWithImpl;
@override @useResult
$Res call({
 String parentPageId, String areaPageId, String groups, String captures, String library, int maxUploadBytes, String? workspaceName
});




}
/// @nodoc
class __$NotionWorkspaceCopyWithImpl<$Res>
    implements _$NotionWorkspaceCopyWith<$Res> {
  __$NotionWorkspaceCopyWithImpl(this._self, this._then);

  final _NotionWorkspace _self;
  final $Res Function(_NotionWorkspace) _then;

/// Create a copy of NotionWorkspace
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parentPageId = null,Object? areaPageId = null,Object? groups = null,Object? captures = null,Object? library = null,Object? maxUploadBytes = null,Object? workspaceName = freezed,}) {
  return _then(_NotionWorkspace(
parentPageId: null == parentPageId ? _self.parentPageId : parentPageId // ignore: cast_nullable_to_non_nullable
as String,areaPageId: null == areaPageId ? _self.areaPageId : areaPageId // ignore: cast_nullable_to_non_nullable
as String,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as String,captures: null == captures ? _self.captures : captures // ignore: cast_nullable_to_non_nullable
as String,library: null == library ? _self.library : library // ignore: cast_nullable_to_non_nullable
as String,maxUploadBytes: null == maxUploadBytes ? _self.maxUploadBytes : maxUploadBytes // ignore: cast_nullable_to_non_nullable
as int,workspaceName: freezed == workspaceName ? _self.workspaceName : workspaceName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
