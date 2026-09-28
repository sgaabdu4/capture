import 'package:capture/core/domain/values/notion_id.dart';
import 'package:capture/features/capture/domain/values/item_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'save_progress.freezed.dart';

/// Retries skip confirmed steps and look up stable IDs before creating anything.
@freezed
sealed class SaveProgress with _$SaveProgress {
  const factory SaveProgress({
    NotionId? capturePageId,

    /// Proposal item id → Notion Library page id.
    @Default({}) Map<ItemId, NotionId> itemPages,
    NotionId? audioUploadId,
    @Default(false) bool audioAttached,
    @Default(false) bool markedSaved,
    @Default({}) Set<ItemId> remindersScheduled,
  }) = _SaveProgress;
}
