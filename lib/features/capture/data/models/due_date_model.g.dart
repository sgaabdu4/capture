// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'due_date_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DueDateModel _$DueDateModelFromJson(Map<String, dynamic> json) => _DueDateModel(
  year: (json['year'] as num).toInt(),
  month: (json['month'] as num).toInt(),
  day: (json['day'] as num).toInt(),
  hour: (json['hour'] as num?)?.toInt(),
  minute: (json['minute'] as num?)?.toInt(),
);

Map<String, dynamic> _$DueDateModelToJson(_DueDateModel instance) => <String, dynamic>{
  'year': instance.year,
  'month': instance.month,
  'day': instance.day,
  'hour': instance.hour,
  'minute': instance.minute,
};
