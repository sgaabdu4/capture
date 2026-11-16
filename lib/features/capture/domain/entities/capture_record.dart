import 'package:capture/features/capture/domain/entities/capture_failure.dart';
import 'package:capture/features/capture/domain/entities/capture_stage.dart';
import 'package:capture/features/capture/domain/entities/proposal_item.dart';
import 'package:capture/features/capture/domain/entities/save_progress.dart';
import 'package:capture/features/capture/domain/values/audio_path.dart';
import 'package:capture/features/capture/domain/values/capture_id.dart';
import 'package:capture/features/capture/domain/values/time_zone_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'capture_record.freezed.dart';

@freezed
sealed class CaptureRecord with _$CaptureRecord {
  const CaptureRecord._();

  const factory CaptureRecord({
    required CaptureId id,
    required DateTime capturedAtUtc,

    /// IANA zone at capture time; dates in the proposal are resolved in it.
    required TimeZoneId timeZone,

    /// Raw PCM16 16 kHz mono file written while recording.
    required AudioPath audioPath,
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
