// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryEntryModel _$LibraryEntryModelFromJson(Map<String, dynamic> json) => _LibraryEntryModel(
  pageId: json['pageId'] as String,
  itemId: json['itemId'] as String,
  title: json['title'] as String,
  kind: $enumDecode(_$ItemKindEnumMap, json['kind']),
  groupId: json['groupId'] as String?,
  due: json['due'] == null ? null : DueDateModel.fromJson(json['due'] as Map<String, dynamic>),
  reminder: json['reminder'] == null
      ? null
      : DueDateModel.fromJson(json['reminder'] as Map<String, dynamic>),
  done: json['done'] as bool? ?? false,
  captureId: json['captureId'] as String?,
);

Map<String, dynamic> _$LibraryEntryModelToJson(_LibraryEntryModel instance) => <String, dynamic>{
  'pageId': instance.pageId,
  'itemId': instance.itemId,
  'title': instance.title,
  'kind': _$ItemKindEnumMap[instance.kind]!,
  'groupId': instance.groupId,
  'due': instance.due?.toJson(),
  'reminder': instance.reminder?.toJson(),
  'done': instance.done,
  'captureId': instance.captureId,
};

const _$ItemKindEnumMap = {ItemKind.note: 'note', ItemKind.task: 'task'};
