import 'package:capture/core/domain/values/byte_size.dart';
import 'package:capture/core/domain/values/notion_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notion_workspace.freezed.dart';

/// The Capture area inside the user's authorised Notion page.
@freezed
sealed class NotionWorkspace with _$NotionWorkspace {
  const factory NotionWorkspace({
    required NotionId parentPageId,
    required NotionId areaPageId,

    /// Data source ids.
    required NotionId groups,
    required NotionId captures,
    required NotionId library,
    required ByteSize maxUpload,
    String? workspaceName,
  }) = _NotionWorkspace;
}
