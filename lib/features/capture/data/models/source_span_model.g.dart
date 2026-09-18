// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_span_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SourceSpanModel _$SourceSpanModelFromJson(Map<String, dynamic> json) => _SourceSpanModel(
  start: (json['start'] as num).toInt(),
  end: (json['end'] as num).toInt(),
  excerpt: json['excerpt'] as String,
);

Map<String, dynamic> _$SourceSpanModelToJson(_SourceSpanModel instance) => <String, dynamic>{
  'start': instance.start,
  'end': instance.end,
  'excerpt': instance.excerpt,
};
