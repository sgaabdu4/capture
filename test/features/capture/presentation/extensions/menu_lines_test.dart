import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/domain/entities/capture_stage.dart';
import 'package:capture/features/capture/presentation/extensions/capture_status.dart';
import 'package:capture/features/capture/presentation/extensions/menu_lines.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

final _l10n = lookupAppLocalizations(const .new('en'));

CaptureRecord _record(CaptureStage stage, {bool failed = false}) => .new(
  id: .new('c1'),
  capturedAtUtc: .utc(2026, 9, 18),
  timeZone: .new('UTC'),
  audioPath: .new('c1.pcm'),
  stage: stage,
  failure: failed ? .transcription : null,
  items: [
    .new(id: .new('a'), sources: [], kind: .task, groupId: .new('g'), title: 'Call', body: ''),
  ],
);

void main() {
  final l10n = _l10n;

  setUpAll(() => initializeDateFormatting('en'));

  test('latest line reports what happened to the newest capture', () {
    expect(null.latestLine(l10n), equals(l10n.menuNoCaptures));
    expect(_record(.saved).latestLine(l10n), equals('1 task'));
    expect(_record(.proposed).latestLine(l10n), equals(l10n.statusWaitingReview));
    expect(_record(.approved).latestLine(l10n), equals(l10n.statusSaveIncomplete));
    expect(_record(.dismissed).latestLine(l10n), equals(l10n.statusNotSaved));
    expect(_record(.recorded).latestLine(l10n), equals(l10n.statusProcessing));
    expect(_record(.transcribed, failed: true).latestLine(l10n), equals(l10n.statusNeedsAttention));
  });

  test('next-up line names the soonest dated task, or says nothing is scheduled', () {
    final entry = LibraryEntry(
      pageId: .new('p'),
      itemId: .new('i'),
      title: 'Dentist',
      kind: .task,
      due: const .new(2026, 9, 19),
    );

    expect(entry.nextUpLine(l10n, .new(2026, 9, 18)), equals('Dentist · Tomorrow'));
    expect(null.nextUpLine(l10n, .new(2026, 9, 18)), equals(l10n.menuNothingScheduled));
  });

  test('a failed step is distinguished from one still waiting', () {
    expect(_record(.recorded).status, equals(CaptureStatus.notTranscribed));
    expect(_record(.recorded, failed: true).status, equals(CaptureStatus.transcriptionFailed));
    expect(_record(.transcribed).status, equals(CaptureStatus.notSorted));
    expect(_record(.transcribed, failed: true).status, equals(CaptureStatus.needsAttention));
  });
}
