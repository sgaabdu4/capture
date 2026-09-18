// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proposal_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProposalItemModel _$ProposalItemModelFromJson(Map<String, dynamic> json) => _ProposalItemModel(
  id: json['id'] as String,
  sources: (json['sources'] as List<dynamic>)
      .map((e) => SourceSpanModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  kind: $enumDecode(_$ItemKindEnumMap, json['kind']),
  groupId: json['groupId'] as String?,
  title: json['title'] as String,
  body: json['body'] as String,
  due: json['due'] == null ? null : DueDateModel.fromJson(json['due'] as Map<String, dynamic>),
  reminder: json['reminder'] == null
      ? null
      : DueDateModel.fromJson(json['reminder'] as Map<String, dynamic>),
  flags:
      (json['flags'] as List<dynamic>?)?.map((e) => $enumDecode(_$ReviewFlagEnumMap, e)).toSet() ??
      const {},
  edited:
      (json['edited'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$EditedFieldEnumMap, e))
          .toSet() ??
      const {},
  included: json['included'] as bool? ?? true,
);

Map<String, dynamic> _$ProposalItemModelToJson(_ProposalItemModel instance) => <String, dynamic>{
  'id': instance.id,
  'sources': instance.sources.map((e) => e.toJson()).toList(),
  'kind': _$ItemKindEnumMap[instance.kind]!,
  'groupId': instance.groupId,
  'title': instance.title,
  'body': instance.body,
  'due': instance.due?.toJson(),
  'reminder': instance.reminder?.toJson(),
  'flags': instance.flags.map((e) => _$ReviewFlagEnumMap[e]!).toList(),
  'edited': instance.edited.map((e) => _$EditedFieldEnumMap[e]!).toList(),
  'included': instance.included,
};

const _$ItemKindEnumMap = {ItemKind.note: 'note', ItemKind.task: 'task'};

const _$ReviewFlagEnumMap = {
  ReviewFlag.checkSplit: 'checkSplit',
  ReviewFlag.checkGroup: 'checkGroup',
  ReviewFlag.checkTask: 'checkTask',
  ReviewFlag.checkReminder: 'checkReminder',
  ReviewFlag.chooseTime: 'chooseTime',
  ReviewFlag.chooseAmPm: 'chooseAmPm',
  ReviewFlag.chooseDate: 'chooseDate',
  ReviewFlag.checkDate: 'checkDate',
  ReviewFlag.timePassed: 'timePassed',
  ReviewFlag.clockChange: 'clockChange',
  ReviewFlag.correctionElsewhere: 'correctionElsewhere',
  ReviewFlag.recallUnsupported: 'recallUnsupported',
  ReviewFlag.newPiece: 'newPiece',
  ReviewFlag.classificationFailed: 'classificationFailed',
};

const _$EditedFieldEnumMap = {
  EditedField.title: 'title',
  EditedField.body: 'body',
  EditedField.group: 'group',
  EditedField.kind: 'kind',
  EditedField.due: 'due',
  EditedField.reminder: 'reminder',
  EditedField.included: 'included',
};
