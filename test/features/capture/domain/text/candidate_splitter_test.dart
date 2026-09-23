import 'package:capture/features/capture/domain/entities/source_span.dart';
import 'package:capture/features/capture/domain/text/candidate_splitter.dart';
import 'package:capture/features/capture/domain/text/coverage.dart';
import 'package:test/test.dart';

List<String> _excerpts(String text) => [
  for (final u in splitCandidates(text)) u.span.excerpt.value,
];

void main() {
  test('sentences become candidate units with exact excerpts', () {
    const text =
        'I learned about Jev today. It could help organise my notes. Remind me to buy groceries tomorrow at 2pm. Actually, make that 3pm.';
    expect(
      _excerpts(text),
      equals([
        'I learned about Jev today.',
        'It could help organise my notes.',
        'Remind me to buy groceries tomorrow at 2pm.',
        'Actually, make that 3pm.',
      ]),
    );
  });

  test('two thoughts inside one sentence get a clause candidate', () {
    expect(
      _excerpts('I enjoyed dinner and thought of a new app'),
      equals(['I enjoyed dinner', 'and thought of a new app']),
    );
  });

  test('a short coordinated object is not a candidate', () {
    expect(_excerpts('Buy milk and bread'), equals(['Buy milk and bread']));
    expect(_excerpts('Buy milk, eggs and bread.'), equals(['Buy milk, eggs and bread.']));
  });

  test('two coordinated actions produce a candidate', () {
    expect(_excerpts('Buy milk and book a haircut'), equals(['Buy milk', 'and book a haircut']));
  });

  test('marker runs cut once at their first word', () {
    expect(
      _excerpts('I had a lovely evening with Sarah and also I thought of an app'),
      equals(['I had a lovely evening with Sarah', 'and also I thought of an app']),
    );
  });

  test('unpunctuated speech gets marker candidates', () {
    expect(
      _excerpts('i learned about jev remind me to call james at 5pm'),
      equals(['i learned about jev', 'remind me to call james at 5pm']),
    );
  });

  test('abbreviations do not end sentences', () {
    expect(
      _excerpts('Call Dr. Patel at 2 p.m. tomorrow please.'),
      equals(['Call Dr. Patel at 2 p.m. tomorrow please.']),
    );
  });

  test('unit ids and boundary kinds are ordered', () {
    final units = splitCandidates('First thing here. Second thing and a third one');
    expect(units.map((u) => u.id.value), equals(['U001', 'U002', 'U003']));
    expect(
      units.map((u) => u.boundaryBefore),
      equals([BoundaryKind.start, BoundaryKind.sentence, BoundaryKind.conjunction]),
    );
  });

  test('empty and whitespace-only transcripts produce no units', () {
    expect(splitCandidates(''), isEmpty);
    expect(splitCandidates('   \n '), isEmpty);
    expect(splitCandidates('...'), isEmpty);
  });

  test('Unicode offsets are UTF-16 and never split surrogate pairs', () {
    const text =
        'Café with Zoë 😀 was lovely. Then 👩‍👩‍👧 visited and we cooked dinner together.';
    final units = splitCandidates(text);
    expect(coverageProblems(text, units.map((u) => u.span)), isEmpty);
    for (final unit in units) {
      expect(text.substring(unit.span.start, unit.span.end), equals(unit.span.excerpt.value));
      final first = text.codeUnitAt(unit.span.start);
      expect(first >= 0xDC00 && first <= 0xDFFF, isFalse);
    }
    expect(units.firstOrNull?.span.excerpt.value, equals('Café with Zoë 😀 was lovely.'));
  });

  test('every non-whitespace character is covered exactly once', () {
    const samples = [
      'I learned about Jev today. It could help organise my notes. I had a lovely evening with Sarah, and I thought of a meal-planning app. Remind me to buy groceries tomorrow at 2pm. Actually, make that 3pm.',
      "Don't remind me to call James!  I need to call James but don't remind me.",
      'so um yeah and then also anyway',
      '"Buy milk," she said. I bought groceries yesterday… what did I say?',
    ];
    for (final text in samples) {
      final spans = splitCandidates(text).map((u) => u.span);
      expect(coverageProblems(text, spans), isEmpty, reason: text);
    }
  });

  test('coverageProblems reports missing and duplicated text', () {
    const text = 'one two three';
    expect(coverageProblems(text, [spanOf(text, 0, 3)]), equals(['missing: "two three"']));
    expect(
      coverageProblems(text, [spanOf(text, 0, 7), spanOf(text, 4, 13)]),
      equals(['duplicated: "two"']),
    );
    expect(
      coverageProblems(text, [SourceSpan(0, 3, .new('xyz')), spanOf(text, 3, 13)]),
      equals(['excerpt mismatch at 0']),
    );
  });
}
