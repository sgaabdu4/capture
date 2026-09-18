import 'package:freezed_annotation/freezed_annotation.dart';

part 'save_progress.freezed.dart';

/// Which Notion save steps are confirmed. Retries skip confirmed steps and
/// look up by stable IDs before creating anything, so nothing duplicates.
@freezed
sealed class SaveProgress with _$SaveProgress {
  const factory SaveProgress({
    String? capturePageId,

    /// Proposal item id → Notion Library page id.
    @Default({}) Map<String, String> itemPages,
    String? audioUploadId,
    @Default(false) bool audioAttached,
    @Default(false) bool markedSaved,
    @Default({}) Set<String> remindersScheduled,
  }) = _SaveProgress;
}
