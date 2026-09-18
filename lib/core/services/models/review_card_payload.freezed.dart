// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_card_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReviewCardPayload {

 String get countLine; List<ReviewCardRow> get rows; bool get canApprove; String? get blockedReason;
/// Create a copy of ReviewCardPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewCardPayloadCopyWith<ReviewCardPayload> get copyWith => _$ReviewCardPayloadCopyWithImpl<ReviewCardPayload>(this as ReviewCardPayload, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReviewCardPayload;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewCardPayload&&(identical(other.countLine, _this.countLine) || other.countLine == _this.countLine)&&const DeepCollectionEquality().equals(other.rows, _this.rows)&&(identical(other.canApprove, _this.canApprove) || other.canApprove == _this.canApprove)&&(identical(other.blockedReason, _this.blockedReason) || other.blockedReason == _this.blockedReason));
}


@override
int get hashCode {
  final _this = this as ReviewCardPayload;
  return Object.hash(runtimeType,_this.countLine,const DeepCollectionEquality().hash(_this.rows),_this.canApprove,_this.blockedReason);
}

@override
String toString() {
  final _this = this as ReviewCardPayload;
  return 'ReviewCardPayload(countLine: ${_this.countLine}, rows: ${_this.rows}, canApprove: ${_this.canApprove}, blockedReason: ${_this.blockedReason})';
}


}

/// @nodoc
abstract mixin class $ReviewCardPayloadCopyWith<$Res>  {
  factory $ReviewCardPayloadCopyWith(ReviewCardPayload value, $Res Function(ReviewCardPayload) _then) = _$ReviewCardPayloadCopyWithImpl;
@useResult
$Res call({
 String countLine, List<ReviewCardRow> rows, bool canApprove, String? blockedReason
});




}
/// @nodoc
class _$ReviewCardPayloadCopyWithImpl<$Res>
    implements $ReviewCardPayloadCopyWith<$Res> {
  _$ReviewCardPayloadCopyWithImpl(this._self, this._then);

  final ReviewCardPayload _self;
  final $Res Function(ReviewCardPayload) _then;

/// Create a copy of ReviewCardPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? countLine = null,Object? rows = null,Object? canApprove = null,Object? blockedReason = freezed,}) {
  return _then(ReviewCardPayload(
countLine: null == countLine ? _self.countLine : countLine // ignore: cast_nullable_to_non_nullable
as String,rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<ReviewCardRow>,canApprove: null == canApprove ? _self.canApprove : canApprove // ignore: cast_nullable_to_non_nullable
as bool,blockedReason: freezed == blockedReason ? _self.blockedReason : blockedReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewCardPayload].
extension ReviewCardPayloadPatterns on ReviewCardPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewCardPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewCardPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewCardPayload value)  $default,){
final _that = this;
switch (_that) {
case _ReviewCardPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewCardPayload value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewCardPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String countLine,  List<ReviewCardRow> rows,  bool canApprove,  String? blockedReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewCardPayload() when $default != null:
return $default(_that.countLine,_that.rows,_that.canApprove,_that.blockedReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String countLine,  List<ReviewCardRow> rows,  bool canApprove,  String? blockedReason)  $default,) {final _that = this;
switch (_that) {
case _ReviewCardPayload():
return $default(_that.countLine,_that.rows,_that.canApprove,_that.blockedReason);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String countLine,  List<ReviewCardRow> rows,  bool canApprove,  String? blockedReason)?  $default,) {final _that = this;
switch (_that) {
case _ReviewCardPayload() when $default != null:
return $default(_that.countLine,_that.rows,_that.canApprove,_that.blockedReason);case _:
  return null;

}
}

}

/// @nodoc


class _ReviewCardPayload implements ReviewCardPayload {
  const _ReviewCardPayload({required this.countLine, required  List<ReviewCardRow> rows, required this.canApprove, this.blockedReason}): _rows = rows;
  

@override final  String countLine;
 final  List<ReviewCardRow> _rows;
@override List<ReviewCardRow> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

@override final  bool canApprove;
@override final  String? blockedReason;

/// Create a copy of ReviewCardPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewCardPayloadCopyWith<_ReviewCardPayload> get copyWith => __$ReviewCardPayloadCopyWithImpl<_ReviewCardPayload>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewCardPayload&&(identical(other.countLine, countLine) || other.countLine == countLine)&&const DeepCollectionEquality().equals(other.rows, _rows)&&(identical(other.canApprove, canApprove) || other.canApprove == canApprove)&&(identical(other.blockedReason, blockedReason) || other.blockedReason == blockedReason));
}


@override
int get hashCode {
    return Object.hash(runtimeType,countLine,const DeepCollectionEquality().hash(_rows),canApprove,blockedReason);
}

@override
String toString() {
    return 'ReviewCardPayload(countLine: $countLine, rows: $rows, canApprove: $canApprove, blockedReason: $blockedReason)';
}


}

/// @nodoc
abstract mixin class _$ReviewCardPayloadCopyWith<$Res> implements $ReviewCardPayloadCopyWith<$Res> {
  factory _$ReviewCardPayloadCopyWith(_ReviewCardPayload value, $Res Function(_ReviewCardPayload) _then) = __$ReviewCardPayloadCopyWithImpl;
@override @useResult
$Res call({
 String countLine, List<ReviewCardRow> rows, bool canApprove, String? blockedReason
});




}
/// @nodoc
class __$ReviewCardPayloadCopyWithImpl<$Res>
    implements _$ReviewCardPayloadCopyWith<$Res> {
  __$ReviewCardPayloadCopyWithImpl(this._self, this._then);

  final _ReviewCardPayload _self;
  final $Res Function(_ReviewCardPayload) _then;

/// Create a copy of ReviewCardPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? countLine = null,Object? rows = null,Object? canApprove = null,Object? blockedReason = freezed,}) {
  return _then(_ReviewCardPayload(
countLine: null == countLine ? _self.countLine : countLine // ignore: cast_nullable_to_non_nullable
as String,rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<ReviewCardRow>,canApprove: null == canApprove ? _self.canApprove : canApprove // ignore: cast_nullable_to_non_nullable
as bool,blockedReason: freezed == blockedReason ? _self.blockedReason : blockedReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
