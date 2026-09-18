// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupModel _$GroupModelFromJson(Map<String, dynamic> json) => _GroupModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  archived: json['archived'] as bool? ?? false,
);

Map<String, dynamic> _$GroupModelToJson(_GroupModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'archived': instance.archived,
};
