import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notion_workspace_model.freezed.dart';
part 'notion_workspace_model.g.dart';

@freezed
sealed class NotionWorkspaceModel with _$NotionWorkspaceModel {
  const NotionWorkspaceModel._();

  const factory NotionWorkspaceModel({
    required String parentPageId,
    required String areaPageId,
    required String groups,
    required String captures,
    required String library,
    required int maxUploadBytes,
    String? workspaceName,
  }) = _NotionWorkspaceModel;

  factory NotionWorkspaceModel.fromJson(Map<String, dynamic> json) =>
      _$NotionWorkspaceModelFromJson(json);

  factory NotionWorkspaceModel.fromEntity(NotionWorkspace w) => NotionWorkspaceModel(
    parentPageId: w.parentPageId,
    areaPageId: w.areaPageId,
    groups: w.groups,
    captures: w.captures,
    library: w.library,
    maxUploadBytes: w.maxUploadBytes,
    workspaceName: w.workspaceName,
  );

  NotionWorkspace toEntity() => .new(
    parentPageId: parentPageId,
    areaPageId: areaPageId,
    groups: groups,
    captures: captures,
    library: library,
    maxUploadBytes: maxUploadBytes,
    workspaceName: workspaceName,
  );
}
