import 'package:capture/core/domain/values/notion_id.dart';
import 'package:capture/features/capture/domain/entities/save_progress.dart';
import 'package:capture/features/capture/domain/values/item_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'save_progress_model.freezed.dart';
part 'save_progress_model.g.dart';

@freezed
sealed class SaveProgressModel with _$SaveProgressModel {
  const SaveProgressModel._();

  const factory SaveProgressModel({
    String? capturePageId,
    @Default({}) Map<String, String> itemPages,
    String? audioUploadId,
    @Default(false) bool audioAttached,
    @Default(false) bool markedSaved,
    @Default({}) Set<String> remindersScheduled,
  }) = _SaveProgressModel;

  factory SaveProgressModel.fromJson(Map<String, dynamic> json) =>
      _$SaveProgressModelFromJson(json);

  factory SaveProgressModel.fromEntity(SaveProgress p) => SaveProgressModel(
    capturePageId: p.capturePageId?.value,
    itemPages: {for (final MapEntry(:key, :value) in p.itemPages.entries) key.value: value.value},
    audioUploadId: p.audioUploadId?.value,
    audioAttached: p.audioAttached,
    markedSaved: p.markedSaved,
    remindersScheduled: {for (final id in p.remindersScheduled) id.value},
  );

  SaveProgress toEntity() => .new(
    capturePageId: switch (capturePageId) {
      final value? => NotionId(value),
      null => null,
    },
    itemPages: {
      for (final MapEntry(:key, :value) in itemPages.entries) ItemId(key): NotionId(value),
    },
    audioUploadId: switch (audioUploadId) {
      final value? => NotionId(value),
      null => null,
    },
    audioAttached: audioAttached,
    markedSaved: markedSaved,
    remindersScheduled: {for (final id in remindersScheduled) ItemId(id)},
  );
}
