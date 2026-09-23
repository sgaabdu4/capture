// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'capture_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CaptureRecord {

 CaptureId get id; DateTime get capturedAtUtc;/// IANA zone at capture time; dates in the proposal are resolved in it.
 TimeZoneId get timeZone;/// Raw PCM16 16 kHz mono file written while recording.
 AudioPath get audioPath; Duration get duration; CaptureStage get stage; String? get transcript; List<ProposalItem> get items; SaveProgress get progress;/// Last failure; cleared when the step succeeds.
 CaptureFailure? get failure;/// Compressed audio uploaded to Notion.
 String? get m4aPath;
/// Create a copy of CaptureRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CaptureRecordCopyWith<CaptureRecord> get copyWith => _$CaptureRecordCopyWithImpl<CaptureRecord>(this as CaptureRecord, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CaptureRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CaptureRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.capturedAtUtc, _this.capturedAtUtc) || other.capturedAtUtc == _this.capturedAtUtc)&&(identical(other.timeZone, _this.timeZone) || other.timeZone == _this.timeZone)&&(identical(other.audioPath, _this.audioPath) || other.audioPath == _this.audioPath)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.stage, _this.stage) || other.stage == _this.stage)&&(identical(other.transcript, _this.transcript) || other.transcript == _this.transcript)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.progress, _this.progress) || other.progress == _this.progress)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.m4aPath, _this.m4aPath) || other.m4aPath == _this.m4aPath));
}


@override
int get hashCode {
  final _this = this as CaptureRecord;
  return Object.hash(runtimeType,_this.id,_this.capturedAtUtc,_this.timeZone,_this.audioPath,_this.duration,_this.stage,_this.transcript,const DeepCollectionEquality().hash(_this.items),_this.progress,_this.failure,_this.m4aPath);
}

@override
String toString() {
  final _this = this as CaptureRecord;
  return 'CaptureRecord(id: ${_this.id}, capturedAtUtc: ${_this.capturedAtUtc}, timeZone: ${_this.timeZone}, audioPath: ${_this.audioPath}, duration: ${_this.duration}, stage: ${_this.stage}, transcript: ${_this.transcript}, items: ${_this.items}, progress: ${_this.progress}, failure: ${_this.failure}, m4aPath: ${_this.m4aPath})';
}


}

/// @nodoc
abstract mixin class $CaptureRecordCopyWith<$Res>  {
  factory $CaptureRecordCopyWith(CaptureRecord value, $Res Function(CaptureRecord) _then) = _$CaptureRecordCopyWithImpl;
@useResult
$Res call({
 CaptureId id, DateTime capturedAtUtc, TimeZoneId timeZone, AudioPath audioPath, Duration duration, CaptureStage stage, String? transcript, List<ProposalItem> items, SaveProgress progress, CaptureFailure? failure, String? m4aPath
});


$SaveProgressCopyWith<$Res> get progress;

}
/// @nodoc
class _$CaptureRecordCopyWithImpl<$Res>
    implements $CaptureRecordCopyWith<$Res> {
  _$CaptureRecordCopyWithImpl(this._self, this._then);

  final CaptureRecord _self;
  final $Res Function(CaptureRecord) _then;

/// Create a copy of CaptureRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? capturedAtUtc = null,Object? timeZone = null,Object? audioPath = null,Object? duration = null,Object? stage = null,Object? transcript = freezed,Object? items = null,Object? progress = null,Object? failure = freezed,Object? m4aPath = freezed,}) {
  return _then(CaptureRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as CaptureId,capturedAtUtc: null == capturedAtUtc ? _self.capturedAtUtc : capturedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,timeZone: null == timeZone ? _self.timeZone : timeZone // ignore: cast_nullable_to_non_nullable
as TimeZoneId,audioPath: null == audioPath ? _self.audioPath : audioPath // ignore: cast_nullable_to_non_nullable
as AudioPath,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as CaptureStage,transcript: freezed == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ProposalItem>,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as SaveProgress,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as CaptureFailure?,m4aPath: freezed == m4aPath ? _self.m4aPath : m4aPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CaptureRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaveProgressCopyWith<$Res> get progress {
  
  return $SaveProgressCopyWith<$Res>(_self.progress, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}


/// Adds pattern-matching-related methods to [CaptureRecord].
extension CaptureRecordPatterns on CaptureRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CaptureRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CaptureRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CaptureRecord value)  $default,){
final _that = this;
switch (_that) {
case _CaptureRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CaptureRecord value)?  $default,){
final _that = this;
switch (_that) {
case _CaptureRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CaptureId id,  DateTime capturedAtUtc,  TimeZoneId timeZone,  AudioPath audioPath,  Duration duration,  CaptureStage stage,  String? transcript,  List<ProposalItem> items,  SaveProgress progress,  CaptureFailure? failure,  String? m4aPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CaptureRecord() when $default != null:
return $default(_that.id,_that.capturedAtUtc,_that.timeZone,_that.audioPath,_that.duration,_that.stage,_that.transcript,_that.items,_that.progress,_that.failure,_that.m4aPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CaptureId id,  DateTime capturedAtUtc,  TimeZoneId timeZone,  AudioPath audioPath,  Duration duration,  CaptureStage stage,  String? transcript,  List<ProposalItem> items,  SaveProgress progress,  CaptureFailure? failure,  String? m4aPath)  $default,) {final _that = this;
switch (_that) {
case _CaptureRecord():
return $default(_that.id,_that.capturedAtUtc,_that.timeZone,_that.audioPath,_that.duration,_that.stage,_that.transcript,_that.items,_that.progress,_that.failure,_that.m4aPath);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CaptureId id,  DateTime capturedAtUtc,  TimeZoneId timeZone,  AudioPath audioPath,  Duration duration,  CaptureStage stage,  String? transcript,  List<ProposalItem> items,  SaveProgress progress,  CaptureFailure? failure,  String? m4aPath)?  $default,) {final _that = this;
switch (_that) {
case _CaptureRecord() when $default != null:
return $default(_that.id,_that.capturedAtUtc,_that.timeZone,_that.audioPath,_that.duration,_that.stage,_that.transcript,_that.items,_that.progress,_that.failure,_that.m4aPath);case _:
  return null;

}
}

}

/// @nodoc


class _CaptureRecord extends CaptureRecord {
  const _CaptureRecord({required this.id, required this.capturedAtUtc, required this.timeZone, required this.audioPath, this.duration = Duration.zero, this.stage = CaptureStage.recorded, this.transcript,  List<ProposalItem> items = const [], this.progress = const SaveProgress(), this.failure, this.m4aPath}): _items = items,super._();
  

@override final  CaptureId id;
@override final  DateTime capturedAtUtc;
/// IANA zone at capture time; dates in the proposal are resolved in it.
@override final  TimeZoneId timeZone;
/// Raw PCM16 16 kHz mono file written while recording.
@override final  AudioPath audioPath;
@override@JsonKey() final  Duration duration;
@override@JsonKey() final  CaptureStage stage;
@override final  String? transcript;
 final  List<ProposalItem> _items;
@override@JsonKey() List<ProposalItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  SaveProgress progress;
/// Last failure; cleared when the step succeeds.
@override final  CaptureFailure? failure;
/// Compressed audio uploaded to Notion.
@override final  String? m4aPath;

/// Create a copy of CaptureRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CaptureRecordCopyWith<_CaptureRecord> get copyWith => __$CaptureRecordCopyWithImpl<_CaptureRecord>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CaptureRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.capturedAtUtc, capturedAtUtc) || other.capturedAtUtc == capturedAtUtc)&&(identical(other.timeZone, timeZone) || other.timeZone == timeZone)&&(identical(other.audioPath, audioPath) || other.audioPath == audioPath)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.transcript, transcript) || other.transcript == transcript)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.m4aPath, m4aPath) || other.m4aPath == m4aPath));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,capturedAtUtc,timeZone,audioPath,duration,stage,transcript,const DeepCollectionEquality().hash(_items),progress,failure,m4aPath);
}

@override
String toString() {
    return 'CaptureRecord(id: $id, capturedAtUtc: $capturedAtUtc, timeZone: $timeZone, audioPath: $audioPath, duration: $duration, stage: $stage, transcript: $transcript, items: $items, progress: $progress, failure: $failure, m4aPath: $m4aPath)';
}


}

/// @nodoc
abstract mixin class _$CaptureRecordCopyWith<$Res> implements $CaptureRecordCopyWith<$Res> {
  factory _$CaptureRecordCopyWith(_CaptureRecord value, $Res Function(_CaptureRecord) _then) = __$CaptureRecordCopyWithImpl;
@override @useResult
$Res call({
 CaptureId id, DateTime capturedAtUtc, TimeZoneId timeZone, AudioPath audioPath, Duration duration, CaptureStage stage, String? transcript, List<ProposalItem> items, SaveProgress progress, CaptureFailure? failure, String? m4aPath
});


@override $SaveProgressCopyWith<$Res> get progress;

}
/// @nodoc
class __$CaptureRecordCopyWithImpl<$Res>
    implements _$CaptureRecordCopyWith<$Res> {
  __$CaptureRecordCopyWithImpl(this._self, this._then);

  final _CaptureRecord _self;
  final $Res Function(_CaptureRecord) _then;

/// Create a copy of CaptureRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? capturedAtUtc = null,Object? timeZone = null,Object? audioPath = null,Object? duration = null,Object? stage = null,Object? transcript = freezed,Object? items = null,Object? progress = null,Object? failure = freezed,Object? m4aPath = freezed,}) {
  return _then(_CaptureRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as CaptureId,capturedAtUtc: null == capturedAtUtc ? _self.capturedAtUtc : capturedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,timeZone: null == timeZone ? _self.timeZone : timeZone // ignore: cast_nullable_to_non_nullable
as TimeZoneId,audioPath: null == audioPath ? _self.audioPath : audioPath // ignore: cast_nullable_to_non_nullable
as AudioPath,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as CaptureStage,transcript: freezed == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ProposalItem>,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as SaveProgress,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as CaptureFailure?,m4aPath: freezed == m4aPath ? _self.m4aPath : m4aPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CaptureRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaveProgressCopyWith<$Res> get progress {
  
  return $SaveProgressCopyWith<$Res>(_self.progress, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}

// dart format on
