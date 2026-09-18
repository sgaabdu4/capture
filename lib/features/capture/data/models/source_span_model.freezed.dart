// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'source_span_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SourceSpanModel {

 int get start; int get end; String get excerpt;
/// Create a copy of SourceSpanModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SourceSpanModelCopyWith<SourceSpanModel> get copyWith => _$SourceSpanModelCopyWithImpl<SourceSpanModel>(this as SourceSpanModel, _$identity);

  /// Serializes this SourceSpanModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SourceSpanModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SourceSpanModel&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.end, _this.end) || other.end == _this.end)&&(identical(other.excerpt, _this.excerpt) || other.excerpt == _this.excerpt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SourceSpanModel;
  return Object.hash(runtimeType,_this.start,_this.end,_this.excerpt);
}

@override
String toString() {
  final _this = this as SourceSpanModel;
  return 'SourceSpanModel(start: ${_this.start}, end: ${_this.end}, excerpt: ${_this.excerpt})';
}


}

/// @nodoc
abstract mixin class $SourceSpanModelCopyWith<$Res>  {
  factory $SourceSpanModelCopyWith(SourceSpanModel value, $Res Function(SourceSpanModel) _then) = _$SourceSpanModelCopyWithImpl;
@useResult
$Res call({
 int start, int end, String excerpt
});




}
/// @nodoc
class _$SourceSpanModelCopyWithImpl<$Res>
    implements $SourceSpanModelCopyWith<$Res> {
  _$SourceSpanModelCopyWithImpl(this._self, this._then);

  final SourceSpanModel _self;
  final $Res Function(SourceSpanModel) _then;

/// Create a copy of SourceSpanModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,Object? excerpt = null,}) {
  return _then(SourceSpanModel(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as int,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as int,excerpt: null == excerpt ? _self.excerpt : excerpt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SourceSpanModel].
extension SourceSpanModelPatterns on SourceSpanModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SourceSpanModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SourceSpanModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SourceSpanModel value)  $default,){
final _that = this;
switch (_that) {
case _SourceSpanModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SourceSpanModel value)?  $default,){
final _that = this;
switch (_that) {
case _SourceSpanModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int start,  int end,  String excerpt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SourceSpanModel() when $default != null:
return $default(_that.start,_that.end,_that.excerpt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int start,  int end,  String excerpt)  $default,) {final _that = this;
switch (_that) {
case _SourceSpanModel():
return $default(_that.start,_that.end,_that.excerpt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int start,  int end,  String excerpt)?  $default,) {final _that = this;
switch (_that) {
case _SourceSpanModel() when $default != null:
return $default(_that.start,_that.end,_that.excerpt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SourceSpanModel extends SourceSpanModel {
  const _SourceSpanModel({required this.start, required this.end, required this.excerpt}): super._();
  factory _SourceSpanModel.fromJson(Map<String, dynamic> json) => _$SourceSpanModelFromJson(json);

@override final  int start;
@override final  int end;
@override final  String excerpt;

/// Create a copy of SourceSpanModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SourceSpanModelCopyWith<_SourceSpanModel> get copyWith => __$SourceSpanModelCopyWithImpl<_SourceSpanModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SourceSpanModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SourceSpanModel&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.excerpt, excerpt) || other.excerpt == excerpt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,start,end,excerpt);
}

@override
String toString() {
    return 'SourceSpanModel(start: $start, end: $end, excerpt: $excerpt)';
}


}

/// @nodoc
abstract mixin class _$SourceSpanModelCopyWith<$Res> implements $SourceSpanModelCopyWith<$Res> {
  factory _$SourceSpanModelCopyWith(_SourceSpanModel value, $Res Function(_SourceSpanModel) _then) = __$SourceSpanModelCopyWithImpl;
@override @useResult
$Res call({
 int start, int end, String excerpt
});




}
/// @nodoc
class __$SourceSpanModelCopyWithImpl<$Res>
    implements _$SourceSpanModelCopyWith<$Res> {
  __$SourceSpanModelCopyWithImpl(this._self, this._then);

  final _SourceSpanModel _self;
  final $Res Function(_SourceSpanModel) _then;

/// Create a copy of SourceSpanModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,Object? excerpt = null,}) {
  return _then(_SourceSpanModel(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as int,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as int,excerpt: null == excerpt ? _self.excerpt : excerpt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
