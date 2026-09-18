import 'package:capture/features/capture/domain/entities/save_progress.dart';
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
    capturePageId: p.capturePageId,
    itemPages: p.itemPages,
    audioUploadId: p.audioUploadId,
    audioAttached: p.audioAttached,
    markedSaved: p.markedSaved,
    remindersScheduled: p.remindersScheduled,
  );

  SaveProgress toEntity() => .new(
    capturePageId: capturePageId,
    itemPages: itemPages,
    audioUploadId: audioUploadId,
    audioAttached: audioAttached,
    markedSaved: markedSaved,
    remindersScheduled: remindersScheduled,
  );
}
