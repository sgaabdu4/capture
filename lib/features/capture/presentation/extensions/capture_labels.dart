import 'package:capture/features/capture/data/datasources/jev_remote_datasource.dart';
import 'package:capture/features/capture/domain/entities/approval_problem.dart';
import 'package:capture/features/capture/domain/entities/capture_failure.dart';
import 'package:capture/features/capture/domain/entities/item_kind.dart';
import 'package:capture/features/capture/domain/entities/proposal_item.dart';
import 'package:capture/features/capture/domain/entities/review_flag.dart';
import 'package:capture/features/capture/domain/proposal/proposal_counts.dart';
import 'package:capture/features/capture/presentation/extensions/capture_status.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_notice.dart';
import 'package:capture/l10n/app_localizations.dart';

extension CaptureNoticeLabel on CaptureNotice {
  String label(AppLocalizations l10n) => switch (this) {
    .setupIncomplete => l10n.noticeSetupIncomplete,
    .micDenied => l10n.noticeMicDenied,
    .recordingNotStarted => l10n.noticeRecordingNotStarted,
    .tooShort => l10n.noticeTooShort,
    .limitReached => l10n.noticeLimitReached,
    .recordingInterrupted => l10n.noticeRecordingInterrupted,
    .dismissed => l10n.noticeDismissed,
    .reviewLater => l10n.noticeReviewLater,
    .saved => l10n.noticeSaved,
    .savedNotificationsOff => l10n.noticeSavedNotificationsOff,
    .notionNotConnected => l10n.noticeNotionNotConnected,
  };
}

extension CaptureFailureLabel on CaptureFailure {
  String label(AppLocalizations l10n) => switch (this) {
    .transcription => l10n.failureTranscription,
    .jevKey => l10n.failureJevKey,
    .jevUnavailable => l10n.failureJevUnavailable,
    .jevResponse => l10n.failureJevResponse,
    .audioTooLarge => l10n.failureAudioTooLarge,
    .audioMissing => l10n.failureAudioMissing,
    .notionAuth => l10n.failureNotionAuth,
    .notionAccess => l10n.failureNotionAccess,
    .notionBlockLimit => l10n.failureNotionBlockLimit,
    .notionUnavailable => l10n.failureNotionUnavailable,
    .notionRejected => l10n.failureNotionRejected,
  };
}

extension JevFailureLabel on JevFailure {
  String label(AppLocalizations l10n) => switch (this) {
    .invalidKey => l10n.jevInvalidKey,
    .rateLimited => l10n.jevRateLimited,
    .unavailable => l10n.jevUnavailable,
    .network => l10n.jevNetwork,
    .invalidResponse => l10n.jevInvalidResponse,
  };
}

extension ReviewFlagLabel on ReviewFlag {
  String label(AppLocalizations l10n) => switch (this) {
    .checkSplit => l10n.flagCheckSplit,
    .checkGroup => l10n.flagCheckGroup,
    .checkTask => l10n.flagCheckTask,
    .checkReminder => l10n.flagCheckReminder,
    .chooseTime => l10n.flagChooseTime,
    .chooseAmPm => l10n.flagChooseAmPm,
    .chooseDate => l10n.flagChooseDate,
    .checkDate => l10n.flagCheckDate,
    .timePassed => l10n.flagTimePassed,
    .clockChange => l10n.flagClockChange,
    .correctionElsewhere => l10n.flagCorrectionElsewhere,
    .recallUnsupported => l10n.flagRecallUnsupported,
    .newPiece => l10n.flagNewPiece,
    .classificationFailed => l10n.flagClassificationFailed,
  };
}

extension ApprovalProblemLabel on ApprovalProblem {
  String label(AppLocalizations l10n) => switch (this) {
    .chooseGroup => l10n.problemChooseGroup,
    .addTitle => l10n.problemAddTitle,
    .chooseAmPm => l10n.problemChooseAmPm,
    .checkClockChange => l10n.problemCheckClockChange,
  };
}

extension ItemKindLabel on ItemKind {
  String label(AppLocalizations l10n) => switch (this) {
    .note => l10n.kindNote,
    .task => l10n.kindTask,
  };
}

extension CaptureStatusLabel on CaptureStatus {
  String label(AppLocalizations l10n) => switch (this) {
    .saved => l10n.statusSaved,
    .waitingReview => l10n.statusWaitingReview,
    .saveIncomplete => l10n.statusSaveIncomplete,
    .notSaved => l10n.statusNotSaved,
    .notTranscribed => l10n.statusNotTranscribed,
    .transcriptionFailed => l10n.statusTranscriptionFailed,
    .notSorted => l10n.statusNotSorted,
    .needsAttention => l10n.statusNeedsAttention,
  };
}

extension ProposalSummary on Iterable<ProposalItem> {
  /// "2 notes · 1 task · 1 reminder"; empty parts are left out.
  String summary(AppLocalizations l10n) {
    final (:notes, :tasks, :reminders) = countProposal(this);
    return [
      if (notes > 0) l10n.countNotes(notes),
      if (tasks > 0) l10n.countTasks(tasks),
      if (reminders > 0) l10n.countReminders(reminders),
    ].join(l10n.detailSeparator);
  }
}
