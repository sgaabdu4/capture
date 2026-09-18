import 'package:capture/features/capture/domain/entities/capture_record.dart';

/// Where a capture stands, as the Recordings list and the menu show it.
enum CaptureStatus {
  saved,
  waitingReview,
  saveIncomplete,
  notSaved,
  notTranscribed,
  transcriptionFailed,
  notSorted,
  needsAttention,
}

extension CaptureRecordStatus on CaptureRecord {
  CaptureStatus get status => switch ((stage: stage, failed: failure != null)) {
    (stage: .saved, failed: _) => .saved,
    (stage: .proposed, failed: _) => .waitingReview,
    (stage: .approved, failed: _) => .saveIncomplete,
    (stage: .dismissed, failed: _) => .notSaved,
    (stage: .recorded, failed: false) => .notTranscribed,
    (stage: .recorded, failed: true) => .transcriptionFailed,
    (stage: .transcribed, failed: false) => .notSorted,
    (stage: .transcribed, failed: true) => .needsAttention,
  };
}
