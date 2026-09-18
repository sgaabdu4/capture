// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortcut_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShortcutModel _$ShortcutModelFromJson(Map<String, dynamic> json) => _ShortcutModel(
  key: json['key'] as String?,
  modifiers: (json['modifiers'] as List<dynamic>)
      .map((e) => $enumDecode(_$ModifierEnumMap, e))
      .toSet(),
);

Map<String, dynamic> _$ShortcutModelToJson(_ShortcutModel instance) => <String, dynamic>{
  'key': instance.key,
  'modifiers': instance.modifiers.map((e) => _$ModifierEnumMap[e]!).toList(),
};

const _$ModifierEnumMap = {
  Modifier.control: 'control',
  Modifier.option: 'option',
  Modifier.shift: 'shift',
  Modifier.command: 'command',
};
