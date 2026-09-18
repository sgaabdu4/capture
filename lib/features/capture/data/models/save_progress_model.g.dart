// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SaveProgressModel _$SaveProgressModelFromJson(Map<String, dynamic> json) => _SaveProgressModel(
  capturePageId: json['capturePageId'] as String?,
  itemPages:
      (json['itemPages'] as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as String)) ??
      const {},
  audioUploadId: json['audioUploadId'] as String?,
  audioAttached: json['audioAttached'] as bool? ?? false,
  markedSaved: json['markedSaved'] as bool? ?? false,
  remindersScheduled:
      (json['remindersScheduled'] as List<dynamic>?)?.map((e) => e as String).toSet() ?? const {},
);

Map<String, dynamic> _$SaveProgressModelToJson(_SaveProgressModel instance) => <String, dynamic>{
  'capturePageId': instance.capturePageId,
  'itemPages': instance.itemPages,
  'audioUploadId': instance.audioUploadId,
  'audioAttached': instance.audioAttached,
  'markedSaved': instance.markedSaved,
  'remindersScheduled': instance.remindersScheduled.toList(),
};
