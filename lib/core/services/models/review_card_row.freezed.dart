// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_card_row.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReviewCardRow {

 String get id;/// SF Symbol name.
 String get icon; String get title; String get detail;
/// Create a copy of ReviewCardRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewCardRowCopyWith<ReviewCardRow> get copyWith => _$ReviewCardRowCopyWithImpl<ReviewCardRow>(this as ReviewCardRow, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReviewCardRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewCardRow&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.detail, _this.detail) || other.detail == _this.detail));
}


@override
int get hashCode {
  final _this = this as ReviewCardRow;
  return Object.hash(runtimeType,_this.id,_this.icon,_this.title,_this.detail);
}

@override
String toString() {
  final _this = this as ReviewCardRow;
  return 'ReviewCardRow(id: ${_this.id}, icon: ${_this.icon}, title: ${_this.title}, detail: ${_this.detail})';
}


}

/// @nodoc
abstract mixin class $ReviewCardRowCopyWith<$Res>  {
  factory $ReviewCardRowCopyWith(ReviewCardRow value, $Res Function(ReviewCardRow) _then) = _$ReviewCardRowCopyWithImpl;
@useResult
$Res call({
 String id, String icon, String title, String detail
});




}
/// @nodoc
class _$ReviewCardRowCopyWithImpl<$Res>
    implements $ReviewCardRowCopyWith<$Res> {
  _$ReviewCardRowCopyWithImpl(this._self, this._then);

  final ReviewCardRow _self;
  final $Res Function(ReviewCardRow) _then;

/// Create a copy of ReviewCardRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? icon = null,Object? title = null,Object? detail = null,}) {
  return _then(ReviewCardRow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewCardRow].
extension ReviewCardRowPatterns on ReviewCardRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewCardRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewCardRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewCardRow value)  $default,){
final _that = this;
switch (_that) {
case _ReviewCardRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewCardRow value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewCardRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String icon,  String title,  String detail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewCardRow() when $default != null:
return $default(_that.id,_that.icon,_that.title,_that.detail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String icon,  String title,  String detail)  $default,) {final _that = this;
switch (_that) {
case _ReviewCardRow():
return $default(_that.id,_that.icon,_that.title,_that.detail);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String icon,  String title,  String detail)?  $default,) {final _that = this;
switch (_that) {
case _ReviewCardRow() when $default != null:
return $default(_that.id,_that.icon,_that.title,_that.detail);case _:
  return null;

}
}

}

/// @nodoc


class _ReviewCardRow implements ReviewCardRow {
  const _ReviewCardRow({required this.id, required this.icon, required this.title, required this.detail});
  

@override final  String id;
/// SF Symbol name.
@override final  String icon;
@override final  String title;
@override final  String detail;

/// Create a copy of ReviewCardRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewCardRowCopyWith<_ReviewCardRow> get copyWith => __$ReviewCardRowCopyWithImpl<_ReviewCardRow>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewCardRow&&(identical(other.id, id) || other.id == id)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.title, title) || other.title == title)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,icon,title,detail);
}

@override
String toString() {
    return 'ReviewCardRow(id: $id, icon: $icon, title: $title, detail: $detail)';
}


}

/// @nodoc
abstract mixin class _$ReviewCardRowCopyWith<$Res> implements $ReviewCardRowCopyWith<$Res> {
  factory _$ReviewCardRowCopyWith(_ReviewCardRow value, $Res Function(_ReviewCardRow) _then) = __$ReviewCardRowCopyWithImpl;
@override @useResult
$Res call({
 String id, String icon, String title, String detail
});




}
/// @nodoc
class __$ReviewCardRowCopyWithImpl<$Res>
    implements _$ReviewCardRowCopyWith<$Res> {
  __$ReviewCardRowCopyWithImpl(this._self, this._then);

  final _ReviewCardRow _self;
  final $Res Function(_ReviewCardRow) _then;

/// Create a copy of ReviewCardRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? icon = null,Object? title = null,Object? detail = null,}) {
  return _then(_ReviewCardRow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
