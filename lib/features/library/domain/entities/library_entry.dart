import 'package:capture/core/domain/values/notion_id.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/capture/domain/entities/item_kind.dart';
import 'package:capture/features/capture/domain/values/item_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_entry.freezed.dart';

/// A saved Library entry as mirrored locally for the To-do and Upcoming
/// views (refreshed from Notion; Notion is the source of truth).
@freezed
sealed class LibraryEntry with _$LibraryEntry {
  const LibraryEntry._();

  const factory LibraryEntry({
    required NotionId pageId,
    required ItemId itemId,
    String? title,
    required ItemKind kind,
    NotionId? groupId,
    DueDate? due,
    DueDate? reminder,
    @Default(false) bool done,
    String? captureId,
  }) = _LibraryEntry;

  /// Reminder time if set, else the due date.
  DueDate? get when => reminder ?? due;
}
