import 'package:capture/features/capture/domain/entities/capture_failure.dart';
import 'package:capture/features/capture/domain/entities/capture_stage.dart';
import 'package:capture/features/capture/domain/entities/proposal_item.dart';
import 'package:capture/features/capture/domain/entities/save_progress.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'capture_record.freezed.dart';

/// One voice capture and everything derived from it. Stored locally as a
/// draft until saved; audio and transcript never leave the Mac except in the
/// approved Notion save (and transcript text to Jev for analysis).
@freezed
sealed class CaptureRecord with _$CaptureRecord {
  const CaptureRecord._();

  const factory CaptureRecord({
    required String id,
    required DateTime capturedAtUtc,

    /// IANA zone at capture time; dates in the proposal are resolved in it.
    required String timeZone,

    /// Raw PCM16 16 kHz mono file written while recording.
    required String audioPath,
    @Default(Duration.zero) Duration duration,
    @Default(CaptureStage.recorded) CaptureStage stage,
    String? transcript,
    @Default([]) List<ProposalItem> items,
    @Default(SaveProgress()) SaveProgress progress,

    /// Last failure; cleared when the step succeeds.
    CaptureFailure? failure,

    /// Compressed audio uploaded to Notion.
    String? m4aPath,
  }) = _CaptureRecord;

  bool get isOpen => stage != .saved && stage != .dismissed;

  List<ProposalItem> get includedItems => [
    for (final i in items)
      if (i.included) i,
  ];
}
