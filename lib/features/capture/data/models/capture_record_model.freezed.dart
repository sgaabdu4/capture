// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'capture_record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CaptureRecordModel {

 String get id; DateTime get capturedAtUtc; String get timeZone; String get audioPath; int get durationMs; CaptureStage get stage; String? get transcript; List<ProposalItemModel> get items; SaveProgressModel get progress; CaptureFailure? get failure; String? get m4aPath;
/// Create a copy of CaptureRecordModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CaptureRecordModelCopyWith<CaptureRecordModel> get copyWith => _$CaptureRecordModelCopyWithImpl<CaptureRecordModel>(this as CaptureRecordModel, _$identity);

  /// Serializes this CaptureRecordModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CaptureRecordModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CaptureRecordModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.capturedAtUtc, _this.capturedAtUtc) || other.capturedAtUtc == _this.capturedAtUtc)&&(identical(other.timeZone, _this.timeZone) || other.timeZone == _this.timeZone)&&(identical(other.audioPath, _this.audioPath) || other.audioPath == _this.audioPath)&&(identical(other.durationMs, _this.durationMs) || other.durationMs == _this.durationMs)&&(identical(other.stage, _this.stage) || other.stage == _this.stage)&&(identical(other.transcript, _this.transcript) || other.transcript == _this.transcript)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.progress, _this.progress) || other.progress == _this.progress)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.m4aPath, _this.m4aPath) || other.m4aPath == _this.m4aPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CaptureRecordModel;
  return Object.hash(runtimeType,_this.id,_this.capturedAtUtc,_this.timeZone,_this.audioPath,_this.durationMs,_this.stage,_this.transcript,const DeepCollectionEquality().hash(_this.items),_this.progress,_this.failure,_this.m4aPath);
}

@override
String toString() {
  final _this = this as CaptureRecordModel;
  return 'CaptureRecordModel(id: ${_this.id}, capturedAtUtc: ${_this.capturedAtUtc}, timeZone: ${_this.timeZone}, audioPath: ${_this.audioPath}, durationMs: ${_this.durationMs}, stage: ${_this.stage}, transcript: ${_this.transcript}, items: ${_this.items}, progress: ${_this.progress}, failure: ${_this.failure}, m4aPath: ${_this.m4aPath})';
}


}

/// @nodoc
abstract mixin class $CaptureRecordModelCopyWith<$Res>  {
  factory $CaptureRecordModelCopyWith(CaptureRecordModel value, $Res Function(CaptureRecordModel) _then) = _$CaptureRecordModelCopyWithImpl;
@useResult
$Res call({
 String id, DateTime capturedAtUtc, String timeZone, String audioPath, int durationMs, CaptureStage stage, String? transcript, List<ProposalItemModel> items, SaveProgressModel progress, CaptureFailure? failure, String? m4aPath
});


$SaveProgressModelCopyWith<$Res> get progress;

}
/// @nodoc
class _$CaptureRecordModelCopyWithImpl<$Res>
    implements $CaptureRecordModelCopyWith<$Res> {
  _$CaptureRecordModelCopyWithImpl(this._self, this._then);

  final CaptureRecordModel _self;
  final $Res Function(CaptureRecordModel) _then;

/// Create a copy of CaptureRecordModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? capturedAtUtc = null,Object? timeZone = null,Object? audioPath = null,Object? durationMs = null,Object? stage = null,Object? transcript = freezed,Object? items = null,Object? progress = null,Object? failure = freezed,Object? m4aPath = freezed,}) {
  return _then(CaptureRecordModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,capturedAtUtc: null == capturedAtUtc ? _self.capturedAtUtc : capturedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,timeZone: null == timeZone ? _self.timeZone : timeZone // ignore: cast_nullable_to_non_nullable
as String,audioPath: null == audioPath ? _self.audioPath : audioPath // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as CaptureStage,transcript: freezed == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ProposalItemModel>,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as SaveProgressModel,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as CaptureFailure?,m4aPath: freezed == m4aPath ? _self.m4aPath : m4aPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CaptureRecordModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaveProgressModelCopyWith<$Res> get progress {
  
  return $SaveProgressModelCopyWith<$Res>(_self.progress, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}


/// Adds pattern-matching-related methods to [CaptureRecordModel].
extension CaptureRecordModelPatterns on CaptureRecordModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CaptureRecordModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CaptureRecordModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CaptureRecordModel value)  $default,){
final _that = this;
switch (_that) {
case _CaptureRecordModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CaptureRecordModel value)?  $default,){
final _that = this;
switch (_that) {
case _CaptureRecordModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime capturedAtUtc,  String timeZone,  String audioPath,  int durationMs,  CaptureStage stage,  String? transcript,  List<ProposalItemModel> items,  SaveProgressModel progress,  CaptureFailure? failure,  String? m4aPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CaptureRecordModel() when $default != null:
return $default(_that.id,_that.capturedAtUtc,_that.timeZone,_that.audioPath,_that.durationMs,_that.stage,_that.transcript,_that.items,_that.progress,_that.failure,_that.m4aPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime capturedAtUtc,  String timeZone,  String audioPath,  int durationMs,  CaptureStage stage,  String? transcript,  List<ProposalItemModel> items,  SaveProgressModel progress,  CaptureFailure? failure,  String? m4aPath)  $default,) {final _that = this;
switch (_that) {
case _CaptureRecordModel():
return $default(_that.id,_that.capturedAtUtc,_that.timeZone,_that.audioPath,_that.durationMs,_that.stage,_that.transcript,_that.items,_that.progress,_that.failure,_that.m4aPath);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime capturedAtUtc,  String timeZone,  String audioPath,  int durationMs,  CaptureStage stage,  String? transcript,  List<ProposalItemModel> items,  SaveProgressModel progress,  CaptureFailure? failure,  String? m4aPath)?  $default,) {final _that = this;
switch (_that) {
case _CaptureRecordModel() when $default != null:
return $default(_that.id,_that.capturedAtUtc,_that.timeZone,_that.audioPath,_that.durationMs,_that.stage,_that.transcript,_that.items,_that.progress,_that.failure,_that.m4aPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CaptureRecordModel extends CaptureRecordModel {
  const _CaptureRecordModel({required this.id, required this.capturedAtUtc, required this.timeZone, required this.audioPath, this.durationMs = 0, this.stage = CaptureStage.recorded, this.transcript,  List<ProposalItemModel> items = const [], this.progress = const SaveProgressModel(), this.failure, this.m4aPath}): _items = items,super._();
  factory _CaptureRecordModel.fromJson(Map<String, dynamic> json) => _$CaptureRecordModelFromJson(json);

@override final  String id;
@override final  DateTime capturedAtUtc;
@override final  String timeZone;
@override final  String audioPath;
@override@JsonKey() final  int durationMs;
@override@JsonKey() final  CaptureStage stage;
@override final  String? transcript;
 final  List<ProposalItemModel> _items;
@override@JsonKey() List<ProposalItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  SaveProgressModel progress;
@override final  CaptureFailure? failure;
@override final  String? m4aPath;

/// Create a copy of CaptureRecordModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CaptureRecordModelCopyWith<_CaptureRecordModel> get copyWith => __$CaptureRecordModelCopyWithImpl<_CaptureRecordModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CaptureRecordModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CaptureRecordModel&&(identical(other.id, id) || other.id == id)&&(identical(other.capturedAtUtc, capturedAtUtc) || other.capturedAtUtc == capturedAtUtc)&&(identical(other.timeZone, timeZone) || other.timeZone == timeZone)&&(identical(other.audioPath, audioPath) || other.audioPath == audioPath)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.transcript, transcript) || other.transcript == transcript)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.m4aPath, m4aPath) || other.m4aPath == m4aPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,capturedAtUtc,timeZone,audioPath,durationMs,stage,transcript,const DeepCollectionEquality().hash(_items),progress,failure,m4aPath);
}

@override
String toString() {
    return 'CaptureRecordModel(id: $id, capturedAtUtc: $capturedAtUtc, timeZone: $timeZone, audioPath: $audioPath, durationMs: $durationMs, stage: $stage, transcript: $transcript, items: $items, progress: $progress, failure: $failure, m4aPath: $m4aPath)';
}


}

/// @nodoc
abstract mixin class _$CaptureRecordModelCopyWith<$Res> implements $CaptureRecordModelCopyWith<$Res> {
  factory _$CaptureRecordModelCopyWith(_CaptureRecordModel value, $Res Function(_CaptureRecordModel) _then) = __$CaptureRecordModelCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime capturedAtUtc, String timeZone, String audioPath, int durationMs, CaptureStage stage, String? transcript, List<ProposalItemModel> items, SaveProgressModel progress, CaptureFailure? failure, String? m4aPath
});


@override $SaveProgressModelCopyWith<$Res> get progress;

}
/// @nodoc
class __$CaptureRecordModelCopyWithImpl<$Res>
    implements _$CaptureRecordModelCopyWith<$Res> {
  __$CaptureRecordModelCopyWithImpl(this._self, this._then);

  final _CaptureRecordModel _self;
  final $Res Function(_CaptureRecordModel) _then;

/// Create a copy of CaptureRecordModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? capturedAtUtc = null,Object? timeZone = null,Object? audioPath = null,Object? durationMs = null,Object? stage = null,Object? transcript = freezed,Object? items = null,Object? progress = null,Object? failure = freezed,Object? m4aPath = freezed,}) {
  return _then(_CaptureRecordModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,capturedAtUtc: null == capturedAtUtc ? _self.capturedAtUtc : capturedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,timeZone: null == timeZone ? _self.timeZone : timeZone // ignore: cast_nullable_to_non_nullable
as String,audioPath: null == audioPath ? _self.audioPath : audioPath // ignore: cast_nullable_to_non_nullable
as String,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as CaptureStage,transcript: freezed == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ProposalItemModel>,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as SaveProgressModel,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as CaptureFailure?,m4aPath: freezed == m4aPath ? _self.m4aPath : m4aPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CaptureRecordModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaveProgressModelCopyWith<$Res> get progress {
  
  return $SaveProgressModelCopyWith<$Res>(_self.progress, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}

// dart format on
