// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'due_date_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DueDateModel {

 int get year; int get month; int get day; int? get hour; int? get minute;
/// Create a copy of DueDateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DueDateModelCopyWith<DueDateModel> get copyWith => _$DueDateModelCopyWithImpl<DueDateModel>(this as DueDateModel, _$identity);

  /// Serializes this DueDateModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DueDateModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DueDateModel&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.hour, _this.hour) || other.hour == _this.hour)&&(identical(other.minute, _this.minute) || other.minute == _this.minute));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DueDateModel;
  return Object.hash(runtimeType,_this.year,_this.month,_this.day,_this.hour,_this.minute);
}

@override
String toString() {
  final _this = this as DueDateModel;
  return 'DueDateModel(year: ${_this.year}, month: ${_this.month}, day: ${_this.day}, hour: ${_this.hour}, minute: ${_this.minute})';
}


}

/// @nodoc
abstract mixin class $DueDateModelCopyWith<$Res>  {
  factory $DueDateModelCopyWith(DueDateModel value, $Res Function(DueDateModel) _then) = _$DueDateModelCopyWithImpl;
@useResult
$Res call({
 int year, int month, int day, int? hour, int? minute
});




}
/// @nodoc
class _$DueDateModelCopyWithImpl<$Res>
    implements $DueDateModelCopyWith<$Res> {
  _$DueDateModelCopyWithImpl(this._self, this._then);

  final DueDateModel _self;
  final $Res Function(DueDateModel) _then;

/// Create a copy of DueDateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? day = null,Object? hour = freezed,Object? minute = freezed,}) {
  return _then(DueDateModel(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,hour: freezed == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int?,minute: freezed == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DueDateModel].
extension DueDateModelPatterns on DueDateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DueDateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DueDateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DueDateModel value)  $default,){
final _that = this;
switch (_that) {
case _DueDateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DueDateModel value)?  $default,){
final _that = this;
switch (_that) {
case _DueDateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month,  int day,  int? hour,  int? minute)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DueDateModel() when $default != null:
return $default(_that.year,_that.month,_that.day,_that.hour,_that.minute);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month,  int day,  int? hour,  int? minute)  $default,) {final _that = this;
switch (_that) {
case _DueDateModel():
return $default(_that.year,_that.month,_that.day,_that.hour,_that.minute);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month,  int day,  int? hour,  int? minute)?  $default,) {final _that = this;
switch (_that) {
case _DueDateModel() when $default != null:
return $default(_that.year,_that.month,_that.day,_that.hour,_that.minute);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DueDateModel extends DueDateModel {
  const _DueDateModel({required this.year, required this.month, required this.day, this.hour, this.minute}): super._();
  factory _DueDateModel.fromJson(Map<String, dynamic> json) => _$DueDateModelFromJson(json);

@override final  int year;
@override final  int month;
@override final  int day;
@override final  int? hour;
@override final  int? minute;

/// Create a copy of DueDateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DueDateModelCopyWith<_DueDateModel> get copyWith => __$DueDateModelCopyWithImpl<_DueDateModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DueDateModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DueDateModel&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.day, day) || other.day == day)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,year,month,day,hour,minute);
}

@override
String toString() {
    return 'DueDateModel(year: $year, month: $month, day: $day, hour: $hour, minute: $minute)';
}


}

/// @nodoc
abstract mixin class _$DueDateModelCopyWith<$Res> implements $DueDateModelCopyWith<$Res> {
  factory _$DueDateModelCopyWith(_DueDateModel value, $Res Function(_DueDateModel) _then) = __$DueDateModelCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, int day, int? hour, int? minute
});




}
/// @nodoc
class __$DueDateModelCopyWithImpl<$Res>
    implements _$DueDateModelCopyWith<$Res> {
  __$DueDateModelCopyWithImpl(this._self, this._then);

  final _DueDateModel _self;
  final $Res Function(_DueDateModel) _then;

/// Create a copy of DueDateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? day = null,Object? hour = freezed,Object? minute = freezed,}) {
  return _then(_DueDateModel(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,hour: freezed == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int?,minute: freezed == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
