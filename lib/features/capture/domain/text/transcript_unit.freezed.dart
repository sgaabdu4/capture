// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transcript_unit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TranscriptUnit {

 String get id; SourceSpan get span; BoundaryKind get boundaryBefore;
/// Create a copy of TranscriptUnit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranscriptUnitCopyWith<TranscriptUnit> get copyWith => _$TranscriptUnitCopyWithImpl<TranscriptUnit>(this as TranscriptUnit, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TranscriptUnit;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranscriptUnit&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.span, _this.span) || other.span == _this.span)&&(identical(other.boundaryBefore, _this.boundaryBefore) || other.boundaryBefore == _this.boundaryBefore));
}


@override
int get hashCode {
  final _this = this as TranscriptUnit;
  return Object.hash(runtimeType,_this.id,_this.span,_this.boundaryBefore);
}

@override
String toString() {
  final _this = this as TranscriptUnit;
  return 'TranscriptUnit(id: ${_this.id}, span: ${_this.span}, boundaryBefore: ${_this.boundaryBefore})';
}


}

/// @nodoc
abstract mixin class $TranscriptUnitCopyWith<$Res>  {
  factory $TranscriptUnitCopyWith(TranscriptUnit value, $Res Function(TranscriptUnit) _then) = _$TranscriptUnitCopyWithImpl;
@useResult
$Res call({
 String id, SourceSpan span, BoundaryKind boundaryBefore
});


$SourceSpanCopyWith<$Res> get span;

}
/// @nodoc
class _$TranscriptUnitCopyWithImpl<$Res>
    implements $TranscriptUnitCopyWith<$Res> {
  _$TranscriptUnitCopyWithImpl(this._self, this._then);

  final TranscriptUnit _self;
  final $Res Function(TranscriptUnit) _then;

/// Create a copy of TranscriptUnit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? span = null,Object? boundaryBefore = null,}) {
  return _then(TranscriptUnit(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == span ? _self.span : span // ignore: cast_nullable_to_non_nullable
as SourceSpan,null == boundaryBefore ? _self.boundaryBefore : boundaryBefore // ignore: cast_nullable_to_non_nullable
as BoundaryKind,
  ));
}
/// Create a copy of TranscriptUnit
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SourceSpanCopyWith<$Res> get span {
  
  return $SourceSpanCopyWith<$Res>(_self.span, (value) {
    return _then(_self.copyWith(span: value));
  });
}
}


/// Adds pattern-matching-related methods to [TranscriptUnit].
extension TranscriptUnitPatterns on TranscriptUnit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranscriptUnit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranscriptUnit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranscriptUnit value)  $default,){
final _that = this;
switch (_that) {
case _TranscriptUnit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranscriptUnit value)?  $default,){
final _that = this;
switch (_that) {
case _TranscriptUnit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  SourceSpan span,  BoundaryKind boundaryBefore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranscriptUnit() when $default != null:
return $default(_that.id,_that.span,_that.boundaryBefore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  SourceSpan span,  BoundaryKind boundaryBefore)  $default,) {final _that = this;
switch (_that) {
case _TranscriptUnit():
return $default(_that.id,_that.span,_that.boundaryBefore);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  SourceSpan span,  BoundaryKind boundaryBefore)?  $default,) {final _that = this;
switch (_that) {
case _TranscriptUnit() when $default != null:
return $default(_that.id,_that.span,_that.boundaryBefore);case _:
  return null;

}
}

}

/// @nodoc


class _TranscriptUnit implements TranscriptUnit {
  const _TranscriptUnit(this.id, this.span, this.boundaryBefore);
  

@override final  String id;
@override final  SourceSpan span;
@override final  BoundaryKind boundaryBefore;

/// Create a copy of TranscriptUnit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranscriptUnitCopyWith<_TranscriptUnit> get copyWith => __$TranscriptUnitCopyWithImpl<_TranscriptUnit>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranscriptUnit&&(identical(other.id, id) || other.id == id)&&(identical(other.span, span) || other.span == span)&&(identical(other.boundaryBefore, boundaryBefore) || other.boundaryBefore == boundaryBefore));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,span,boundaryBefore);
}

@override
String toString() {
    return 'TranscriptUnit(id: $id, span: $span, boundaryBefore: $boundaryBefore)';
}


}

/// @nodoc
abstract mixin class _$TranscriptUnitCopyWith<$Res> implements $TranscriptUnitCopyWith<$Res> {
  factory _$TranscriptUnitCopyWith(_TranscriptUnit value, $Res Function(_TranscriptUnit) _then) = __$TranscriptUnitCopyWithImpl;
@override @useResult
$Res call({
 String id, SourceSpan span, BoundaryKind boundaryBefore
});


@override $SourceSpanCopyWith<$Res> get span;

}
/// @nodoc
class __$TranscriptUnitCopyWithImpl<$Res>
    implements _$TranscriptUnitCopyWith<$Res> {
  __$TranscriptUnitCopyWithImpl(this._self, this._then);

  final _TranscriptUnit _self;
  final $Res Function(_TranscriptUnit) _then;

/// Create a copy of TranscriptUnit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? span = null,Object? boundaryBefore = null,}) {
  return _then(_TranscriptUnit(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == span ? _self.span : span // ignore: cast_nullable_to_non_nullable
as SourceSpan,null == boundaryBefore ? _self.boundaryBefore : boundaryBefore // ignore: cast_nullable_to_non_nullable
as BoundaryKind,
  ));
}

/// Create a copy of TranscriptUnit
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SourceSpanCopyWith<$Res> get span {
  
  return $SourceSpanCopyWith<$Res>(_self.span, (value) {
    return _then(_self.copyWith(span: value));
  });
}
}

// dart format on
