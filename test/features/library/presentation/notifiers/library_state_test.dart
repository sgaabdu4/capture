import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/features/library/presentation/notifiers/library_state.dart';
import 'package:flutter_test/flutter_test.dart';

final _entries = [
  LibraryEntry(
    pageId: .new('p1'),
    itemId: .new('i1'),
    title: 'Buy oat MILK',
    kind: .task,
    done: true,
  ),
  LibraryEntry(pageId: .new('p2'), itemId: .new('i2'), title: 'Milk frother idea', kind: .note),
  LibraryEntry(pageId: .new('p3'), itemId: .new('i3'), title: 'Call the dentist', kind: .task),
];

void main() {
  test('search matches saved titles ignoring case, notes and done tasks included', () {
    final state = LibraryState(entries: _entries, query: '  milk ');

    expect([for (final e in state.matches()) e.itemId.value], equals(['i1', 'i2']));
  });

  test('an empty search matches nothing', () {
    final state = LibraryState(entries: _entries, query: ' ');

    expect(state.matches(), isEmpty);
  });
}
