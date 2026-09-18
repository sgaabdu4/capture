// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'boundary_decision.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BoundaryDecision {

 bool get split; bool get uncertain;/// Jev's P(yes) for "a new thought starts here".
 double get yes; bool get lateCorrection;
/// Create a copy of BoundaryDecision
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoundaryDecisionCopyWith<BoundaryDecision> get copyWith => _$BoundaryDecisionCopyWithImpl<BoundaryDecision>(this as BoundaryDecision, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BoundaryDecision;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoundaryDecision&&(identical(other.split, _this.split) || other.split == _this.split)&&(identical(other.uncertain, _this.uncertain) || other.uncertain == _this.uncertain)&&(identical(other.yes, _this.yes) || other.yes == _this.yes)&&(identical(other.lateCorrection, _this.lateCorrection) || other.lateCorrection == _this.lateCorrection));
}


@override
int get hashCode {
  final _this = this as BoundaryDecision;
  return Object.hash(runtimeType,_this.split,_this.uncertain,_this.yes,_this.lateCorrection);
}

@override
String toString() {
  final _this = this as BoundaryDecision;
  return 'BoundaryDecision(split: ${_this.split}, uncertain: ${_this.uncertain}, yes: ${_this.yes}, lateCorrection: ${_this.lateCorrection})';
}


}

/// @nodoc
abstract mixin class $BoundaryDecisionCopyWith<$Res>  {
  factory $BoundaryDecisionCopyWith(BoundaryDecision value, $Res Function(BoundaryDecision) _then) = _$BoundaryDecisionCopyWithImpl;
@useResult
$Res call({
 bool split, bool uncertain, double yes, bool lateCorrection
});




}
/// @nodoc
class _$BoundaryDecisionCopyWithImpl<$Res>
    implements $BoundaryDecisionCopyWith<$Res> {
  _$BoundaryDecisionCopyWithImpl(this._self, this._then);

  final BoundaryDecision _self;
  final $Res Function(BoundaryDecision) _then;

/// Create a copy of BoundaryDecision
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? split = null,Object? uncertain = null,Object? yes = null,Object? lateCorrection = null,}) {
  return _then(BoundaryDecision(
split: null == split ? _self.split : split // ignore: cast_nullable_to_non_nullable
as bool,uncertain: null == uncertain ? _self.uncertain : uncertain // ignore: cast_nullable_to_non_nullable
as bool,yes: null == yes ? _self.yes : yes // ignore: cast_nullable_to_non_nullable
as double,lateCorrection: null == lateCorrection ? _self.lateCorrection : lateCorrection // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BoundaryDecision].
extension BoundaryDecisionPatterns on BoundaryDecision {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BoundaryDecision value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BoundaryDecision() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BoundaryDecision value)  $default,){
final _that = this;
switch (_that) {
case _BoundaryDecision():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BoundaryDecision value)?  $default,){
final _that = this;
switch (_that) {
case _BoundaryDecision() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool split,  bool uncertain,  double yes,  bool lateCorrection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BoundaryDecision() when $default != null:
return $default(_that.split,_that.uncertain,_that.yes,_that.lateCorrection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool split,  bool uncertain,  double yes,  bool lateCorrection)  $default,) {final _that = this;
switch (_that) {
case _BoundaryDecision():
return $default(_that.split,_that.uncertain,_that.yes,_that.lateCorrection);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool split,  bool uncertain,  double yes,  bool lateCorrection)?  $default,) {final _that = this;
switch (_that) {
case _BoundaryDecision() when $default != null:
return $default(_that.split,_that.uncertain,_that.yes,_that.lateCorrection);case _:
  return null;

}
}

}

/// @nodoc


class _BoundaryDecision implements BoundaryDecision {
  const _BoundaryDecision({required this.split, required this.uncertain, required this.yes, this.lateCorrection = false});
  

@override final  bool split;
@override final  bool uncertain;
/// Jev's P(yes) for "a new thought starts here".
@override final  double yes;
@override@JsonKey() final  bool lateCorrection;

/// Create a copy of BoundaryDecision
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoundaryDecisionCopyWith<_BoundaryDecision> get copyWith => __$BoundaryDecisionCopyWithImpl<_BoundaryDecision>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoundaryDecision&&(identical(other.split, split) || other.split == split)&&(identical(other.uncertain, uncertain) || other.uncertain == uncertain)&&(identical(other.yes, yes) || other.yes == yes)&&(identical(other.lateCorrection, lateCorrection) || other.lateCorrection == lateCorrection));
}


@override
int get hashCode {
    return Object.hash(runtimeType,split,uncertain,yes,lateCorrection);
}

@override
String toString() {
    return 'BoundaryDecision(split: $split, uncertain: $uncertain, yes: $yes, lateCorrection: $lateCorrection)';
}


}

/// @nodoc
abstract mixin class _$BoundaryDecisionCopyWith<$Res> implements $BoundaryDecisionCopyWith<$Res> {
  factory _$BoundaryDecisionCopyWith(_BoundaryDecision value, $Res Function(_BoundaryDecision) _then) = __$BoundaryDecisionCopyWithImpl;
@override @useResult
$Res call({
 bool split, bool uncertain, double yes, bool lateCorrection
});




}
/// @nodoc
class __$BoundaryDecisionCopyWithImpl<$Res>
    implements _$BoundaryDecisionCopyWith<$Res> {
  __$BoundaryDecisionCopyWithImpl(this._self, this._then);

  final _BoundaryDecision _self;
  final $Res Function(_BoundaryDecision) _then;

/// Create a copy of BoundaryDecision
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? split = null,Object? uncertain = null,Object? yes = null,Object? lateCorrection = null,}) {
  return _then(_BoundaryDecision(
split: null == split ? _self.split : split // ignore: cast_nullable_to_non_nullable
as bool,uncertain: null == uncertain ? _self.uncertain : uncertain // ignore: cast_nullable_to_non_nullable
as bool,yes: null == yes ? _self.yes : yes // ignore: cast_nullable_to_non_nullable
as double,lateCorrection: null == lateCorrection ? _self.lateCorrection : lateCorrection // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
