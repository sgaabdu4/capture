import 'package:capture/core/data/notion/notion_shapes.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:flutter_test/flutter_test.dart';

const _id = '0123456789abcdef0123456789abcdef';
const _dashed = '01234567-89ab-cdef-0123-456789abcdef';

DueDate? _dateOf(Object? date) => propDate({
  'properties': {'When': date},
}, 'When');

void main() {
  group('a date property', () {
    test('keeps the wall-clock day and time Notion holds, whatever its zone offset', () {
      expect(
        _dateOf({
          'date': {'start': '2026-09-18T09:30:00.000+01:00'},
        }),
        equals(const DueDate(2026, 9, 18, hour: 9, minute: 30)),
      );
    });

    test('a date with no time stays a day', () {
      expect(
        _dateOf({
          'date': {'start': '2026-09-18'},
        }),
        equals(const DueDate(2026, 9, 18)),
      );
    });

    test('text that is not a date reads as no date', () {
      expect(
        _dateOf({
          'date': {'start': 'tomorrow'},
        }),
        isNull,
      );
    });

    test('an empty or missing property reads as no date', () {
      expect(_dateOf({'date': null}), isNull);
      expect(_dateOf(null), isNull);
    });
  });

  group('a Notion page link', () {
    test('a page URL gives the id at the end of its last path segment', () {
      expect(parseNotionId('https://www.notion.so/team/Capture-tests-$_id'), equals(_dashed));
    });

    test('the view id in the query is never taken for the page id', () {
      const view = 'fedcba9876543210fedcba9876543210';
      expect(parseNotionId('https://www.notion.so/Page-$_id?v=$view'), equals(_dashed));
    });

    test('a bare id, dashed or not, in any case, gives the dashed lower-case id', () {
      expect(parseNotionId(' $_id '), equals(_dashed));
      expect(parseNotionId(_dashed.toUpperCase()), equals(_dashed));
    });

    test('text with no id gives null', () {
      expect(parseNotionId('https://www.notion.so/'), isNull);
      expect(parseNotionId('not a link'), isNull);
    });
  });
}
