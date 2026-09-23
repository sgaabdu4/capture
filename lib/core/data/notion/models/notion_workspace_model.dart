import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/core/domain/values/notion_id.dart';
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
    parentPageId: w.parentPageId.value,
    areaPageId: w.areaPageId.value,
    groups: w.groups.value,
    captures: w.captures.value,
    library: w.library.value,
    maxUploadBytes: w.maxUpload.inBytes,
    workspaceName: w.workspaceName,
  );

  NotionWorkspace toEntity() => .new(
    parentPageId: NotionId(parentPageId),
    areaPageId: NotionId(areaPageId),
    groups: NotionId(groups),
    captures: NotionId(captures),
    library: NotionId(library),
    maxUpload: .fromBytes(maxUploadBytes),
    workspaceName: workspaceName,
  );
}
