// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speech_model_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpeechModelEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeechModelEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SpeechModelEvent()';
}


}

/// @nodoc
class $SpeechModelEventCopyWith<$Res>  {
$SpeechModelEventCopyWith(SpeechModelEvent _, $Res Function(SpeechModelEvent) __);
}



/// @nodoc


class SpeechModelProgress implements SpeechModelEvent {
  const SpeechModelProgress({required this.received, required this.total});
  

 final  int received;
 final  int total;

/// Create a copy of SpeechModelEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeechModelProgressCopyWith<SpeechModelProgress> get copyWith => _$SpeechModelProgressCopyWithImpl<SpeechModelProgress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeechModelProgress&&(identical(other.received, received) || other.received == received)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode {
    return Object.hash(runtimeType,received,total);
}

@override
String toString() {
    return 'SpeechModelEvent.progress(received: $received, total: $total)';
}


}

/// @nodoc
abstract mixin class $SpeechModelProgressCopyWith<$Res> implements $SpeechModelEventCopyWith<$Res> {
  factory $SpeechModelProgressCopyWith(SpeechModelProgress value, $Res Function(SpeechModelProgress) _then) = _$SpeechModelProgressCopyWithImpl;
@useResult
$Res call({
 int received, int total
});




}
/// @nodoc
class _$SpeechModelProgressCopyWithImpl<$Res>
    implements $SpeechModelProgressCopyWith<$Res> {
  _$SpeechModelProgressCopyWithImpl(this._self, this._then);

  final SpeechModelProgress _self;
  final $Res Function(SpeechModelProgress) _then;

/// Create a copy of SpeechModelEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? received = null,Object? total = null,}) {
  return _then(SpeechModelProgress(
received: null == received ? _self.received : received // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class SpeechModelVerifying implements SpeechModelEvent {
  const SpeechModelVerifying(this.file);
  

 final  String file;

/// Create a copy of SpeechModelEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeechModelVerifyingCopyWith<SpeechModelVerifying> get copyWith => _$SpeechModelVerifyingCopyWithImpl<SpeechModelVerifying>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeechModelVerifying&&(identical(other.file, file) || other.file == file));
}


@override
int get hashCode {
    return Object.hash(runtimeType,file);
}

@override
String toString() {
    return 'SpeechModelEvent.verifying(file: $file)';
}


}

/// @nodoc
abstract mixin class $SpeechModelVerifyingCopyWith<$Res> implements $SpeechModelEventCopyWith<$Res> {
  factory $SpeechModelVerifyingCopyWith(SpeechModelVerifying value, $Res Function(SpeechModelVerifying) _then) = _$SpeechModelVerifyingCopyWithImpl;
@useResult
$Res call({
 String file
});




}
/// @nodoc
class _$SpeechModelVerifyingCopyWithImpl<$Res>
    implements $SpeechModelVerifyingCopyWith<$Res> {
  _$SpeechModelVerifyingCopyWithImpl(this._self, this._then);

  final SpeechModelVerifying _self;
  final $Res Function(SpeechModelVerifying) _then;

/// Create a copy of SpeechModelEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? file = null,}) {
  return _then(SpeechModelVerifying(
null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SpeechModelReady implements SpeechModelEvent {
  const SpeechModelReady();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeechModelReady);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SpeechModelEvent.ready()';
}


}




/// @nodoc


class SpeechModelFailed implements SpeechModelEvent {
  const SpeechModelFailed(this.reason);
  

 final  SpeechModelFailure reason;

/// Create a copy of SpeechModelEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeechModelFailedCopyWith<SpeechModelFailed> get copyWith => _$SpeechModelFailedCopyWithImpl<SpeechModelFailed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeechModelFailed&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode {
    return Object.hash(runtimeType,reason);
}

@override
String toString() {
    return 'SpeechModelEvent.failed(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $SpeechModelFailedCopyWith<$Res> implements $SpeechModelEventCopyWith<$Res> {
  factory $SpeechModelFailedCopyWith(SpeechModelFailed value, $Res Function(SpeechModelFailed) _then) = _$SpeechModelFailedCopyWithImpl;
@useResult
$Res call({
 SpeechModelFailure reason
});




}
/// @nodoc
class _$SpeechModelFailedCopyWithImpl<$Res>
    implements $SpeechModelFailedCopyWith<$Res> {
  _$SpeechModelFailedCopyWithImpl(this._self, this._then);

  final SpeechModelFailed _self;
  final $Res Function(SpeechModelFailed) _then;

/// Create a copy of SpeechModelEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(SpeechModelFailed(
null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as SpeechModelFailure,
  ));
}


}

// dart format on
