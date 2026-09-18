import 'package:capture/features/capture/data/models/proposal_item_model.dart';
import 'package:capture/features/capture/data/models/save_progress_model.dart';
import 'package:capture/features/capture/domain/entities/capture_failure.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/domain/entities/capture_stage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'capture_record_model.freezed.dart';
part 'capture_record_model.g.dart';

@freezed
sealed class CaptureRecordModel with _$CaptureRecordModel {
  const CaptureRecordModel._();

  const factory CaptureRecordModel({
    required String id,
    required DateTime capturedAtUtc,
    required String timeZone,
    required String audioPath,
    @Default(0) int durationMs,
    @Default(CaptureStage.recorded) CaptureStage stage,
    String? transcript,
    @Default([]) List<ProposalItemModel> items,
    @Default(SaveProgressModel()) SaveProgressModel progress,
    CaptureFailure? failure,
    String? m4aPath,
  }) = _CaptureRecordModel;

  factory CaptureRecordModel.fromJson(Map<String, dynamic> json) =>
      _$CaptureRecordModelFromJson(json);

  factory CaptureRecordModel.fromEntity(CaptureRecord r) => CaptureRecordModel(
    id: r.id,
    capturedAtUtc: r.capturedAtUtc,
    timeZone: r.timeZone,
    audioPath: r.audioPath,
    durationMs: r.duration.inMilliseconds,
    stage: r.stage,
    transcript: r.transcript,
    items: [for (final i in r.items) ProposalItemModel.fromEntity(i)],
    progress: .fromEntity(r.progress),
    failure: r.failure,
    m4aPath: r.m4aPath,
  );

  CaptureRecord toEntity() => .new(
    id: id,
    capturedAtUtc: capturedAtUtc,
    timeZone: timeZone,
    audioPath: audioPath,
    duration: .new(milliseconds: durationMs),
    stage: stage,
    transcript: transcript,
    items: [for (final i in items) i.toEntity()],
    progress: progress.toEntity(),
    failure: failure,
    m4aPath: m4aPath,
  );
}
