import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/features/library/presentation/extensions/library_labels.dart';
import 'package:capture/features/library/presentation/notifiers/library_state.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('en'));
  final l10n = lookupAppLocalizations(const Locale('en'));
  final now = DateTime.utc(2026, 11, 23, 12);

  test('a library that was never refreshed has no sync line', () {
    expect(const LibraryState(entries: []).syncLabel(l10n, now), isNull);
  });

  test('a refreshing library says so', () {
    expect(
      const LibraryState(entries: [], refreshing: true).syncLabel(l10n, now),
      l10n.syncRefreshing,
    );
  });

  test('a refreshed library says how long ago', () {
    final state = LibraryState(
      entries: const [],
      refreshedAtUtc: now.subtract(const Duration(minutes: 5)),
    );
    expect(state.syncLabel(l10n, now), contains('5'));
  });

  group('an entry under its day heading', () {
    final entry = LibraryEntry(
      pageId: .new('p1'),
      itemId: .new('i1'),
      title: 'Book the car in',
      kind: .task,
      due: const DueDate(2026, 11, 24, hour: 9, minute: 0),
    );
    final today = DateTime(2026, 11, 23);

    test('shows its time without repeating the day', () {
      expect(
        entry.detail(l10n, today, null, underDay: true),
        allOf(contains('9:00'), isNot(contains('Tomorrow'))),
      );
    });

    test('keeps the day when the entry has no title to carry it', () {
      final untitled = LibraryEntry(
        pageId: .new('p2'),
        itemId: .new('i2'),
        kind: .task,
        due: const DueDate(2026, 11, 24),
      );

      expect(untitled.detail(l10n, today, null, underDay: true), contains('Tomorrow'));
    });

    test('names the day on a list that has no day headings', () {
      expect(entry.detail(l10n, today, null), contains('Tomorrow'));
    });
  });
}
