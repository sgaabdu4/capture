import 'package:capture/features/capture/domain/text/candidate_splitter.dart';
import 'package:test/test.dart';

import 'eval_cases.dart';

/// Measures candidate-boundary coverage separately from Jev selection: a
/// gold boundary missing from the candidates can never be recovered by Jev.
void main() {
  test('every gold thought boundary is a candidate boundary', () {
    int gold = 0;
    int covered = 0;
    int candidates = 0;
    final missing = <String>[];
    for (final c in evalCases) {
      final starts = splitCandidates(c.transcript).map((u) => u.span.start).toSet();
      candidates += starts.length - (starts.isEmpty ? 0 : 1);
      for (final b in c.goldBoundaries) {
        expect(b, greaterThanOrEqualTo(0), reason: '${c.id}: label not found');
        gold++;
        final hit = starts.contains(b);
        if (hit) covered++;
        if (!hit) missing.add('${c.id}@$b');
      }
    }
    printOnFailure('candidate coverage $covered/$gold, candidates $candidates, missing $missing');
    expect(missing, isEmpty);
  });
}
