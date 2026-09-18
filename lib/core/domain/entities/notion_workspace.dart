import 'package:freezed_annotation/freezed_annotation.dart';

part 'notion_workspace.freezed.dart';

/// The Capture area inside the user's authorised Notion page.
@freezed
sealed class NotionWorkspace with _$NotionWorkspace {
  const factory NotionWorkspace({
    required String parentPageId,
    required String areaPageId,

    /// Data source ids.
    required String groups,
    required String captures,
    required String library,
    required int maxUploadBytes,
    String? workspaceName,
  }) = _NotionWorkspace;
}
