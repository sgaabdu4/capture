// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notion_workspace_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotionWorkspaceModel _$NotionWorkspaceModelFromJson(Map<String, dynamic> json) =>
    _NotionWorkspaceModel(
      parentPageId: json['parentPageId'] as String,
      areaPageId: json['areaPageId'] as String,
      groups: json['groups'] as String,
      captures: json['captures'] as String,
      library: json['library'] as String,
      maxUploadBytes: (json['maxUploadBytes'] as num).toInt(),
      workspaceName: json['workspaceName'] as String?,
    );

Map<String, dynamic> _$NotionWorkspaceModelToJson(_NotionWorkspaceModel instance) =>
    <String, dynamic>{
      'parentPageId': instance.parentPageId,
      'areaPageId': instance.areaPageId,
      'groups': instance.groups,
      'captures': instance.captures,
      'library': instance.library,
      'maxUploadBytes': instance.maxUploadBytes,
      'workspaceName': instance.workspaceName,
    };
