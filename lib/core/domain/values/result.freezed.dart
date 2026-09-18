// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Result<T,E> {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Result<T, E>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'Result<$T, $E>()';
}


}

/// @nodoc
class $ResultCopyWith<T,E,$Res>  {
$ResultCopyWith(Result<T, E> _, $Res Function(Result<T, E>) __);
}



/// @nodoc


class Ok<T,E> extends Result<T, E> {
  const Ok(this.value): super._();
  

 final  T value;

/// Create a copy of Result
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OkCopyWith<T, E, Ok<T, E>> get copyWith => _$OkCopyWithImpl<T, E, Ok<T, E>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Ok<T, E>&&const DeepCollectionEquality().equals(other.value, value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(value));
}

@override
String toString() {
    return 'Result<$T, $E>.ok(value: $value)';
}


}

/// @nodoc
abstract mixin class $OkCopyWith<T,E,$Res> implements $ResultCopyWith<T, E, $Res> {
  factory $OkCopyWith(Ok<T, E> value, $Res Function(Ok<T, E>) _then) = _$OkCopyWithImpl;
@useResult
$Res call({
 T value
});




}
/// @nodoc
class _$OkCopyWithImpl<T,E,$Res>
    implements $OkCopyWith<T, E, $Res> {
  _$OkCopyWithImpl(this._self, this._then);

  final Ok<T, E> _self;
  final $Res Function(Ok<T, E>) _then;

/// Create a copy of Result
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = freezed,}) {
  return _then(Ok<T, E>(
freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class Err<T,E> extends Result<T, E> {
  const Err(this.failure): super._();
  

 final  E failure;

/// Create a copy of Result
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrCopyWith<T, E, Err<T, E>> get copyWith => _$ErrCopyWithImpl<T, E, Err<T, E>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Err<T, E>&&const DeepCollectionEquality().equals(other.failure, failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(failure));
}

@override
String toString() {
    return 'Result<$T, $E>.err(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ErrCopyWith<T,E,$Res> implements $ResultCopyWith<T, E, $Res> {
  factory $ErrCopyWith(Err<T, E> value, $Res Function(Err<T, E>) _then) = _$ErrCopyWithImpl;
@useResult
$Res call({
 E failure
});




}
/// @nodoc
class _$ErrCopyWithImpl<T,E,$Res>
    implements $ErrCopyWith<T, E, $Res> {
  _$ErrCopyWithImpl(this._self, this._then);

  final Err<T, E> _self;
  final $Res Function(Err<T, E>) _then;

/// Create a copy of Result
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = freezed,}) {
  return _then(Err<T, E>(
freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as E,
  ));
}


}

// dart format on
