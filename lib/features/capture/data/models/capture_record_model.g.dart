// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capture_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CaptureRecordModel _$CaptureRecordModelFromJson(Map<String, dynamic> json) => _CaptureRecordModel(
  id: json['id'] as String,
  capturedAtUtc: DateTime.parse(json['capturedAtUtc'] as String),
  timeZone: json['timeZone'] as String,
  audioPath: json['audioPath'] as String,
  durationMs: (json['durationMs'] as num?)?.toInt() ?? 0,
  stage: $enumDecodeNullable(_$CaptureStageEnumMap, json['stage']) ?? CaptureStage.recorded,
  transcript: json['transcript'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => ProposalItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  progress: json['progress'] == null
      ? const SaveProgressModel()
      : SaveProgressModel.fromJson(json['progress'] as Map<String, dynamic>),
  failure: $enumDecodeNullable(_$CaptureFailureEnumMap, json['failure']),
  m4aPath: json['m4aPath'] as String?,
);

Map<String, dynamic> _$CaptureRecordModelToJson(_CaptureRecordModel instance) => <String, dynamic>{
  'id': instance.id,
  'capturedAtUtc': instance.capturedAtUtc.toIso8601String(),
  'timeZone': instance.timeZone,
  'audioPath': instance.audioPath,
  'durationMs': instance.durationMs,
  'stage': _$CaptureStageEnumMap[instance.stage]!,
  'transcript': instance.transcript,
  'items': instance.items.map((e) => e.toJson()).toList(),
  'progress': instance.progress.toJson(),
  'failure': _$CaptureFailureEnumMap[instance.failure],
  'm4aPath': instance.m4aPath,
};

const _$CaptureStageEnumMap = {
  CaptureStage.recorded: 'recorded',
  CaptureStage.transcribed: 'transcribed',
  CaptureStage.proposed: 'proposed',
  CaptureStage.approved: 'approved',
  CaptureStage.saved: 'saved',
  CaptureStage.dismissed: 'dismissed',
};

const _$CaptureFailureEnumMap = {
  CaptureFailure.transcription: 'transcription',
  CaptureFailure.jevKey: 'jevKey',
  CaptureFailure.jevUnavailable: 'jevUnavailable',
  CaptureFailure.jevResponse: 'jevResponse',
  CaptureFailure.audioTooLarge: 'audioTooLarge',
  CaptureFailure.audioMissing: 'audioMissing',
  CaptureFailure.notionAuth: 'notionAuth',
  CaptureFailure.notionAccess: 'notionAccess',
  CaptureFailure.notionBlockLimit: 'notionBlockLimit',
  CaptureFailure.notionUnavailable: 'notionUnavailable',
  CaptureFailure.notionRejected: 'notionRejected',
};
