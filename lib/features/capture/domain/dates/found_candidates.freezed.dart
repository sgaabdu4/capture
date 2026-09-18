// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'found_candidates.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FoundCandidates {

 List<DayCandidate> get days; List<TimeCandidate> get times;
/// Create a copy of FoundCandidates
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoundCandidatesCopyWith<FoundCandidates> get copyWith => _$FoundCandidatesCopyWithImpl<FoundCandidates>(this as FoundCandidates, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FoundCandidates;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoundCandidates&&const DeepCollectionEquality().equals(other.days, _this.days)&&const DeepCollectionEquality().equals(other.times, _this.times));
}


@override
int get hashCode {
  final _this = this as FoundCandidates;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.days),const DeepCollectionEquality().hash(_this.times));
}

@override
String toString() {
  final _this = this as FoundCandidates;
  return 'FoundCandidates(days: ${_this.days}, times: ${_this.times})';
}


}

/// @nodoc
abstract mixin class $FoundCandidatesCopyWith<$Res>  {
  factory $FoundCandidatesCopyWith(FoundCandidates value, $Res Function(FoundCandidates) _then) = _$FoundCandidatesCopyWithImpl;
@useResult
$Res call({
 List<DayCandidate> days, List<TimeCandidate> times
});




}
/// @nodoc
class _$FoundCandidatesCopyWithImpl<$Res>
    implements $FoundCandidatesCopyWith<$Res> {
  _$FoundCandidatesCopyWithImpl(this._self, this._then);

  final FoundCandidates _self;
  final $Res Function(FoundCandidates) _then;

/// Create a copy of FoundCandidates
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? days = null,Object? times = null,}) {
  return _then(FoundCandidates(
null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<DayCandidate>,null == times ? _self.times : times // ignore: cast_nullable_to_non_nullable
as List<TimeCandidate>,
  ));
}

}


/// Adds pattern-matching-related methods to [FoundCandidates].
extension FoundCandidatesPatterns on FoundCandidates {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoundCandidates value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoundCandidates() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoundCandidates value)  $default,){
final _that = this;
switch (_that) {
case _FoundCandidates():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoundCandidates value)?  $default,){
final _that = this;
switch (_that) {
case _FoundCandidates() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DayCandidate> days,  List<TimeCandidate> times)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoundCandidates() when $default != null:
return $default(_that.days,_that.times);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DayCandidate> days,  List<TimeCandidate> times)  $default,) {final _that = this;
switch (_that) {
case _FoundCandidates():
return $default(_that.days,_that.times);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DayCandidate> days,  List<TimeCandidate> times)?  $default,) {final _that = this;
switch (_that) {
case _FoundCandidates() when $default != null:
return $default(_that.days,_that.times);case _:
  return null;

}
}

}

/// @nodoc


class _FoundCandidates extends FoundCandidates {
  const _FoundCandidates( List<DayCandidate> days,  List<TimeCandidate> times): _days = days,_times = times,super._();
  

 final  List<DayCandidate> _days;
@override List<DayCandidate> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

 final  List<TimeCandidate> _times;
@override List<TimeCandidate> get times {
  if (_times is EqualUnmodifiableListView) return _times;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_times);
}


/// Create a copy of FoundCandidates
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoundCandidatesCopyWith<_FoundCandidates> get copyWith => __$FoundCandidatesCopyWithImpl<_FoundCandidates>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoundCandidates&&const DeepCollectionEquality().equals(other.days, _days)&&const DeepCollectionEquality().equals(other.times, _times));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_days),const DeepCollectionEquality().hash(_times));
}

@override
String toString() {
    return 'FoundCandidates(days: $days, times: $times)';
}


}

/// @nodoc
abstract mixin class _$FoundCandidatesCopyWith<$Res> implements $FoundCandidatesCopyWith<$Res> {
  factory _$FoundCandidatesCopyWith(_FoundCandidates value, $Res Function(_FoundCandidates) _then) = __$FoundCandidatesCopyWithImpl;
@override @useResult
$Res call({
 List<DayCandidate> days, List<TimeCandidate> times
});




}
/// @nodoc
class __$FoundCandidatesCopyWithImpl<$Res>
    implements _$FoundCandidatesCopyWith<$Res> {
  __$FoundCandidatesCopyWithImpl(this._self, this._then);

  final _FoundCandidates _self;
  final $Res Function(_FoundCandidates) _then;

/// Create a copy of FoundCandidates
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? days = null,Object? times = null,}) {
  return _then(_FoundCandidates(
null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<DayCandidate>,null == times ? _self._times : times // ignore: cast_nullable_to_non_nullable
as List<TimeCandidate>,
  ));
}


}

// dart format on
