import 'package:capture/features/capture/domain/text/candidate_splitter.dart';
import 'package:capture/features/capture/domain/text/coverage.dart';
import 'package:test/test.dart';

String _longTranscript() {
  const sentences = [
    'I learned about Jev today and it could help organise my notes.',
    'I had a lovely evening with Sarah, and I thought of a meal-planning app.',
    'Remind me to buy groceries tomorrow at 2pm. Actually, make that 3pm.',
    'Buy milk and book a haircut',
    'so um anyway I need to call James but don’t remind me',
    'Café meeting with Zoë 😀 went well, also the build finally passed.',
  ];
  final buffer = StringBuffer();
  int i = 0;
  while (buffer.length < 7000) {
    buffer
      ..write(sentences[i % sentences.length])
      ..write(' ');
    i++;
  }
  return buffer.toString().trim();
}

void main() {
  test('candidate splitting + coverage of a 5-minute transcript stays under budget', () {
    final text = _longTranscript();
    // Warm up JIT.
    for (int i = 0; i < 3; i++) {
      splitCandidates(text);
    }
    const runs = 20;
    final watch = Stopwatch()..start();
    for (int i = 0; i < runs; i++) {
      final units = splitCandidates(text);
      expect(coverageProblems(text, units.map((u) => u.span)), isEmpty);
    }
    watch.stop();
    final perRunMs = watch.elapsedMicroseconds / runs / 1000;
    const budgetMs = 50;
    printOnFailure('split+coverage per run: ${perRunMs.toStringAsFixed(2)} ms');
    expect(perRunMs, lessThan(budgetMs));
  });
}
