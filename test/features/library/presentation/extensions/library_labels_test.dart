import 'package:capture/features/library/presentation/extensions/library_labels.dart';
import 'package:capture/features/library/presentation/notifiers/library_state.dart';
import 'package:capture/l10n/app_localizations.g.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
}
