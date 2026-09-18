// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resolved_date.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResolvedDate {

/// Local wall-clock date (and time when known) in the capture time zone.
 DueDate? get date; Set<ReviewFlag> get flags;/// 1–12 when AM/PM must be chosen by the user.
 int? get ambiguousHour;
/// Create a copy of ResolvedDate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResolvedDateCopyWith<ResolvedDate> get copyWith => _$ResolvedDateCopyWithImpl<ResolvedDate>(this as ResolvedDate, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ResolvedDate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResolvedDate&&(identical(other.date, _this.date) || other.date == _this.date)&&const DeepCollectionEquality().equals(other.flags, _this.flags)&&(identical(other.ambiguousHour, _this.ambiguousHour) || other.ambiguousHour == _this.ambiguousHour));
}


@override
int get hashCode {
  final _this = this as ResolvedDate;
  return Object.hash(runtimeType,_this.date,const DeepCollectionEquality().hash(_this.flags),_this.ambiguousHour);
}

@override
String toString() {
  final _this = this as ResolvedDate;
  return 'ResolvedDate(date: ${_this.date}, flags: ${_this.flags}, ambiguousHour: ${_this.ambiguousHour})';
}


}

/// @nodoc
abstract mixin class $ResolvedDateCopyWith<$Res>  {
  factory $ResolvedDateCopyWith(ResolvedDate value, $Res Function(ResolvedDate) _then) = _$ResolvedDateCopyWithImpl;
@useResult
$Res call({
 DueDate? date, Set<ReviewFlag> flags, int? ambiguousHour
});


$DueDateCopyWith<$Res>? get date;

}
/// @nodoc
class _$ResolvedDateCopyWithImpl<$Res>
    implements $ResolvedDateCopyWith<$Res> {
  _$ResolvedDateCopyWithImpl(this._self, this._then);

  final ResolvedDate _self;
  final $Res Function(ResolvedDate) _then;

/// Create a copy of ResolvedDate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = freezed,Object? flags = null,Object? ambiguousHour = freezed,}) {
  return _then(ResolvedDate(
date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DueDate?,flags: null == flags ? _self.flags : flags // ignore: cast_nullable_to_non_nullable
as Set<ReviewFlag>,ambiguousHour: freezed == ambiguousHour ? _self.ambiguousHour : ambiguousHour // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of ResolvedDate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DueDateCopyWith<$Res>? get date {
    if (_self.date == null) {
    return null;
  }

  return $DueDateCopyWith<$Res>(_self.date!, (value) {
    return _then(_self.copyWith(date: value));
  });
}
}


/// Adds pattern-matching-related methods to [ResolvedDate].
extension ResolvedDatePatterns on ResolvedDate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResolvedDate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResolvedDate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResolvedDate value)  $default,){
final _that = this;
switch (_that) {
case _ResolvedDate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResolvedDate value)?  $default,){
final _that = this;
switch (_that) {
case _ResolvedDate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DueDate? date,  Set<ReviewFlag> flags,  int? ambiguousHour)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResolvedDate() when $default != null:
return $default(_that.date,_that.flags,_that.ambiguousHour);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DueDate? date,  Set<ReviewFlag> flags,  int? ambiguousHour)  $default,) {final _that = this;
switch (_that) {
case _ResolvedDate():
return $default(_that.date,_that.flags,_that.ambiguousHour);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DueDate? date,  Set<ReviewFlag> flags,  int? ambiguousHour)?  $default,) {final _that = this;
switch (_that) {
case _ResolvedDate() when $default != null:
return $default(_that.date,_that.flags,_that.ambiguousHour);case _:
  return null;

}
}

}

/// @nodoc


class _ResolvedDate implements ResolvedDate {
  const _ResolvedDate({this.date,  Set<ReviewFlag> flags = const {}, this.ambiguousHour}): _flags = flags;
  

/// Local wall-clock date (and time when known) in the capture time zone.
@override final  DueDate? date;
 final  Set<ReviewFlag> _flags;
@override@JsonKey() Set<ReviewFlag> get flags {
  if (_flags is EqualUnmodifiableSetView) return _flags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_flags);
}

/// 1–12 when AM/PM must be chosen by the user.
@override final  int? ambiguousHour;

/// Create a copy of ResolvedDate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResolvedDateCopyWith<_ResolvedDate> get copyWith => __$ResolvedDateCopyWithImpl<_ResolvedDate>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResolvedDate&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.flags, _flags)&&(identical(other.ambiguousHour, ambiguousHour) || other.ambiguousHour == ambiguousHour));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,const DeepCollectionEquality().hash(_flags),ambiguousHour);
}

@override
String toString() {
    return 'ResolvedDate(date: $date, flags: $flags, ambiguousHour: $ambiguousHour)';
}


}

/// @nodoc
abstract mixin class _$ResolvedDateCopyWith<$Res> implements $ResolvedDateCopyWith<$Res> {
  factory _$ResolvedDateCopyWith(_ResolvedDate value, $Res Function(_ResolvedDate) _then) = __$ResolvedDateCopyWithImpl;
@override @useResult
$Res call({
 DueDate? date, Set<ReviewFlag> flags, int? ambiguousHour
});


@override $DueDateCopyWith<$Res>? get date;

}
/// @nodoc
class __$ResolvedDateCopyWithImpl<$Res>
    implements _$ResolvedDateCopyWith<$Res> {
  __$ResolvedDateCopyWithImpl(this._self, this._then);

  final _ResolvedDate _self;
  final $Res Function(_ResolvedDate) _then;

/// Create a copy of ResolvedDate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = freezed,Object? flags = null,Object? ambiguousHour = freezed,}) {
  return _then(_ResolvedDate(
date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DueDate?,flags: null == flags ? _self._flags : flags // ignore: cast_nullable_to_non_nullable
as Set<ReviewFlag>,ambiguousHour: freezed == ambiguousHour ? _self.ambiguousHour : ambiguousHour // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of ResolvedDate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DueDateCopyWith<$Res>? get date {
    if (_self.date == null) {
    return null;
  }

  return $DueDateCopyWith<$Res>(_self.date!, (value) {
    return _then(_self.copyWith(date: value));
  });
}
}

// dart format on
