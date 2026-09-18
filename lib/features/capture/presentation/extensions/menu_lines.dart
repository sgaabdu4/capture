import 'package:capture/core/extensions/date_format.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/presentation/extensions/capture_labels.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/l10n/app_localizations.dart';

extension MenuNextUp on LibraryEntry? {
  /// "Call the dentist · Tomorrow 9:00 AM", or the empty line.
  String nextUpLine(AppLocalizations l10n, DateTime today) => switch (this) {
    LibraryEntry(:final title, when: final due?) => l10n.menuNextUp(title, due.label(l10n, today)),
    _ => l10n.menuNothingScheduled,
  };
}

extension MenuLatest on CaptureRecord? {
  /// What happened to the newest capture.
  String latestLine(AppLocalizations l10n) => switch (this) {
    null => l10n.menuNoCaptures,
    CaptureRecord(stage: .saved, :final includedItems) => includedItems.summary(l10n),
    CaptureRecord(stage: .proposed) => l10n.statusWaitingReview,
    CaptureRecord(stage: .approved) => l10n.statusSaveIncomplete,
    CaptureRecord(stage: .dismissed) => l10n.statusNotSaved,
    CaptureRecord(failure: null) => l10n.statusProcessing,
    CaptureRecord() => l10n.statusNeedsAttention,
  };
}
