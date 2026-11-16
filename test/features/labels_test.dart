import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/features/capture/data/datasources/jev_remote_datasource.dart';
import 'package:capture/features/capture/domain/entities/approval_problem.dart';
import 'package:capture/features/capture/domain/entities/capture_failure.dart';
import 'package:capture/features/capture/domain/entities/item_kind.dart';
import 'package:capture/features/capture/domain/entities/review_flag.dart';
import 'package:capture/features/capture/presentation/extensions/capture_labels.dart';
import 'package:capture/features/capture/presentation/extensions/capture_status.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_notice.dart';
import 'package:capture/features/groups/domain/entities/group_problem.dart';
import 'package:capture/features/groups/presentation/extensions/group_labels.dart';
import 'package:capture/features/settings/domain/entities/shortcut_problem.dart';
import 'package:capture/features/settings/domain/entities/speech_model_failure.dart';
import 'package:capture/features/settings/presentation/extensions/settings_labels.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter_test/flutter_test.dart';

final _l10n = lookupAppLocalizations(const .new('en'));

void _eachValueHasItsOwnText(String name, List<String> labels) {
  test('every $name has its own non-empty text', () {
    expect(labels.every((label) => label.trim().isNotEmpty), isTrue);
    expect(labels.toSet().length, equals(labels.length));
  });
}

void main() {
  _eachValueHasItsOwnText('capture notice', [for (final v in CaptureNotice.values) v.label(_l10n)]);
  _eachValueHasItsOwnText('capture failure', [
    for (final v in CaptureFailure.values) v.label(_l10n),
  ]);
  _eachValueHasItsOwnText('Jev failure', [for (final v in JevFailure.values) v.label(_l10n)]);
  _eachValueHasItsOwnText('review flag', [for (final v in ReviewFlag.values) v.label(_l10n)]);
  _eachValueHasItsOwnText('approval problem', [
    for (final v in ApprovalProblem.values) v.label(_l10n),
  ]);
  _eachValueHasItsOwnText('item kind', [for (final v in ItemKind.values) v.label(_l10n)]);
  _eachValueHasItsOwnText('capture status', [for (final v in CaptureStatus.values) v.label(_l10n)]);
  _eachValueHasItsOwnText('group problem', [for (final v in GroupProblem.values) v.label(_l10n)]);
  _eachValueHasItsOwnText('Notion failure', [for (final v in NotionFailure.values) v.label(_l10n)]);
  _eachValueHasItsOwnText('speech model failure', [
    for (final v in SpeechModelFailure.values) v.label(_l10n),
  ]);
  _eachValueHasItsOwnText('shortcut problem', [
    for (final v in ShortcutProblem.values) v.label(_l10n),
  ]);
}
