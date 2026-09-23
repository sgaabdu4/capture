// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thought.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Thought {

 PassageId get id; List<TranscriptUnit> get units; SourceSpan get span;/// True when the boundary that started this thought was uncertain.
 bool get uncertainStart;/// True when the thought starts with a correction of an earlier,
/// non-adjacent thought.
 bool get lateCorrection;
/// Create a copy of Thought
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThoughtCopyWith<Thought> get copyWith => _$ThoughtCopyWithImpl<Thought>(this as Thought, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Thought;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Thought&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.units, _this.units)&&(identical(other.span, _this.span) || other.span == _this.span)&&(identical(other.uncertainStart, _this.uncertainStart) || other.uncertainStart == _this.uncertainStart)&&(identical(other.lateCorrection, _this.lateCorrection) || other.lateCorrection == _this.lateCorrection));
}


@override
int get hashCode {
  final _this = this as Thought;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.units),_this.span,_this.uncertainStart,_this.lateCorrection);
}

@override
String toString() {
  final _this = this as Thought;
  return 'Thought(id: ${_this.id}, units: ${_this.units}, span: ${_this.span}, uncertainStart: ${_this.uncertainStart}, lateCorrection: ${_this.lateCorrection})';
}


}

/// @nodoc
abstract mixin class $ThoughtCopyWith<$Res>  {
  factory $ThoughtCopyWith(Thought value, $Res Function(Thought) _then) = _$ThoughtCopyWithImpl;
@useResult
$Res call({
 PassageId id, List<TranscriptUnit> units, SourceSpan span, bool uncertainStart, bool lateCorrection
});


$SourceSpanCopyWith<$Res> get span;

}
/// @nodoc
class _$ThoughtCopyWithImpl<$Res>
    implements $ThoughtCopyWith<$Res> {
  _$ThoughtCopyWithImpl(this._self, this._then);

  final Thought _self;
  final $Res Function(Thought) _then;

/// Create a copy of Thought
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? units = null,Object? span = null,Object? uncertainStart = null,Object? lateCorrection = null,}) {
  return _then(Thought(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as PassageId,null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as List<TranscriptUnit>,null == span ? _self.span : span // ignore: cast_nullable_to_non_nullable
as SourceSpan,uncertainStart: null == uncertainStart ? _self.uncertainStart : uncertainStart // ignore: cast_nullable_to_non_nullable
as bool,lateCorrection: null == lateCorrection ? _self.lateCorrection : lateCorrection // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of Thought
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SourceSpanCopyWith<$Res> get span {
  
  return $SourceSpanCopyWith<$Res>(_self.span, (value) {
    return _then(_self.copyWith(span: value));
  });
}
}


/// Adds pattern-matching-related methods to [Thought].
extension ThoughtPatterns on Thought {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Thought value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Thought() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Thought value)  $default,){
final _that = this;
switch (_that) {
case _Thought():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Thought value)?  $default,){
final _that = this;
switch (_that) {
case _Thought() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PassageId id,  List<TranscriptUnit> units,  SourceSpan span,  bool uncertainStart,  bool lateCorrection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Thought() when $default != null:
return $default(_that.id,_that.units,_that.span,_that.uncertainStart,_that.lateCorrection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PassageId id,  List<TranscriptUnit> units,  SourceSpan span,  bool uncertainStart,  bool lateCorrection)  $default,) {final _that = this;
switch (_that) {
case _Thought():
return $default(_that.id,_that.units,_that.span,_that.uncertainStart,_that.lateCorrection);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PassageId id,  List<TranscriptUnit> units,  SourceSpan span,  bool uncertainStart,  bool lateCorrection)?  $default,) {final _that = this;
switch (_that) {
case _Thought() when $default != null:
return $default(_that.id,_that.units,_that.span,_that.uncertainStart,_that.lateCorrection);case _:
  return null;

}
}

}

/// @nodoc


class _Thought implements Thought {
  const _Thought(this.id,  List<TranscriptUnit> units, this.span, {this.uncertainStart = false, this.lateCorrection = false}): _units = units;
  

@override final  PassageId id;
 final  List<TranscriptUnit> _units;
@override List<TranscriptUnit> get units {
  if (_units is EqualUnmodifiableListView) return _units;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_units);
}

@override final  SourceSpan span;
/// True when the boundary that started this thought was uncertain.
@override@JsonKey() final  bool uncertainStart;
/// True when the thought starts with a correction of an earlier,
/// non-adjacent thought.
@override@JsonKey() final  bool lateCorrection;

/// Create a copy of Thought
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThoughtCopyWith<_Thought> get copyWith => __$ThoughtCopyWithImpl<_Thought>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Thought&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.units, _units)&&(identical(other.span, span) || other.span == span)&&(identical(other.uncertainStart, uncertainStart) || other.uncertainStart == uncertainStart)&&(identical(other.lateCorrection, lateCorrection) || other.lateCorrection == lateCorrection));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_units),span,uncertainStart,lateCorrection);
}

@override
String toString() {
    return 'Thought(id: $id, units: $units, span: $span, uncertainStart: $uncertainStart, lateCorrection: $lateCorrection)';
}


}

/// @nodoc
abstract mixin class _$ThoughtCopyWith<$Res> implements $ThoughtCopyWith<$Res> {
  factory _$ThoughtCopyWith(_Thought value, $Res Function(_Thought) _then) = __$ThoughtCopyWithImpl;
@override @useResult
$Res call({
 PassageId id, List<TranscriptUnit> units, SourceSpan span, bool uncertainStart, bool lateCorrection
});


@override $SourceSpanCopyWith<$Res> get span;

}
/// @nodoc
class __$ThoughtCopyWithImpl<$Res>
    implements _$ThoughtCopyWith<$Res> {
  __$ThoughtCopyWithImpl(this._self, this._then);

  final _Thought _self;
  final $Res Function(_Thought) _then;

/// Create a copy of Thought
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? units = null,Object? span = null,Object? uncertainStart = null,Object? lateCorrection = null,}) {
  return _then(_Thought(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as PassageId,null == units ? _self._units : units // ignore: cast_nullable_to_non_nullable
as List<TranscriptUnit>,null == span ? _self.span : span // ignore: cast_nullable_to_non_nullable
as SourceSpan,uncertainStart: null == uncertainStart ? _self.uncertainStart : uncertainStart // ignore: cast_nullable_to_non_nullable
as bool,lateCorrection: null == lateCorrection ? _self.lateCorrection : lateCorrection // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of Thought
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
