import 'package:capture/features/capture/data/models/due_date_model.dart';
import 'package:capture/features/capture/domain/entities/item_kind.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_entry_model.freezed.dart';
part 'library_entry_model.g.dart';

@freezed
sealed class LibraryEntryModel with _$LibraryEntryModel {
  const LibraryEntryModel._();

  const factory LibraryEntryModel({
    required String pageId,
    required String itemId,
    required String title,
    required ItemKind kind,
    String? groupId,
    DueDateModel? due,
    DueDateModel? reminder,
    @Default(false) bool done,
    String? captureId,
  }) = _LibraryEntryModel;

  factory LibraryEntryModel.fromJson(Map<String, dynamic> json) =>
      _$LibraryEntryModelFromJson(json);

  factory LibraryEntryModel.fromEntity(LibraryEntry e) => LibraryEntryModel(
    pageId: e.pageId,
    itemId: e.itemId,
    title: e.title,
    kind: e.kind,
    groupId: e.groupId,
    due: switch (e.due) {
      final d? => .fromEntity(d),
      null => null,
    },
    reminder: switch (e.reminder) {
      final r? => .fromEntity(r),
      null => null,
    },
    done: e.done,
    captureId: e.captureId,
  );

  LibraryEntry toEntity() => .new(
    pageId: pageId,
    itemId: itemId,
    title: title,
    kind: kind,
    groupId: groupId,
    due: due?.toEntity(),
    reminder: reminder?.toEntity(),
    done: done,
    captureId: captureId,
  );
}
