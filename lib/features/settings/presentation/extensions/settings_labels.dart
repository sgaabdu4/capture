import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/features/settings/domain/entities/shortcut_problem.dart';
import 'package:capture/features/settings/domain/entities/speech_model_failure.dart';
import 'package:capture/l10n/app_localizations.dart';

extension NotionFailureLabel on NotionFailure {
  String label(AppLocalizations l10n) => switch (this) {
    .invalidToken => l10n.notionInvalidToken,
    .notShared => l10n.notionNotShared,
    .missingCapability => l10n.notionMissingCapability,
    .blockLimit => l10n.notionBlockLimit,
    .rateLimited => l10n.notionRateLimited,
    .unavailable => l10n.notionUnavailable,
    .network => l10n.notionNetwork,
    .invalidRequest => l10n.notionInvalidRequest,
  };
}

extension SpeechModelFailureLabel on SpeechModelFailure {
  String label(AppLocalizations l10n) => switch (this) {
    .network => l10n.modelFailedNetwork,
    .diskSpace => l10n.modelFailedDisk,
    .checksum => l10n.modelFailedChecksum,
    .unknown => l10n.modelFailedUnknown,
  };
}

extension ShortcutProblemLabel on ShortcutProblem {
  String label(AppLocalizations l10n) => switch (this) {
    .unsupportedKey => l10n.shortcutUnsupportedKey,
    .tooFewModifiers => l10n.shortcutTooFewModifiers,
    .taken => l10n.shortcutTaken,
  };
}
