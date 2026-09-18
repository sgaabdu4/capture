import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/features/library/presentation/notifiers/library_state.dart';
import 'package:flutter_test/flutter_test.dart';

const _entries = [
  LibraryEntry(pageId: 'p1', itemId: 'i1', title: 'Buy oat MILK', kind: .task, done: true),
  LibraryEntry(pageId: 'p2', itemId: 'i2', title: 'Milk frother idea', kind: .note),
  LibraryEntry(pageId: 'p3', itemId: 'i3', title: 'Call the dentist', kind: .task),
];

void main() {
  test('search matches saved titles ignoring case, notes and done tasks included', () {
    const state = LibraryState(entries: _entries, query: '  milk ');

    expect([for (final e in state.matches()) e.itemId], equals(['i1', 'i2']));
  });

  test('an empty search matches nothing', () {
    const state = LibraryState(entries: _entries, query: ' ');

    expect(state.matches(), isEmpty);
  });
}
