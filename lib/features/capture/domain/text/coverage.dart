import 'package:capture/features/capture/domain/entities/source_span.dart';
import 'package:capture/features/capture/domain/values/excerpt.dart';

/// Span over [text] from [start] to [end] with its exact excerpt.
SourceSpan spanOf(String text, int start, int end) =>
    .new(start, end, Excerpt(text.substring(start, end)));

/// Returns the non-whitespace text of [text] that is not covered by [spans],
/// or that is covered more than once. Empty result means every source
/// passage is accounted for exactly once.
List<String> coverageProblems(String text, Iterable<SourceSpan> spans) {
  final counts = List<int>.filled(text.length, 0);
  final problems = <String>[];
  for (final span in spans) {
    final problem = _spanProblem(text, span);
    if (problem != null) problems.add(problem);
    if (problem == null || problem.startsWith('excerpt')) {
      for (int i = span.start; i < span.end; i++) {
        counts[i]++;
      }
    }
  }
  return [...problems, ..._coverageRuns(text, counts)];
}

String? _spanProblem(String text, SourceSpan span) {
  final SourceSpan(:start, :end, :excerpt) = span;
  if (start < 0 || end > text.length || start > end) return 'invalid span $start-$end';
  if (text.substring(start, end) != excerpt.value) return 'excerpt mismatch at $start';
  return null;
}

final _whitespace = RegExp(r'\s');

/// How often a source character is covered; names are the report labels.
enum _Coverage { once, missing, duplicated }

/// Groups uncovered (non-whitespace) and duplicated characters into runs;
/// uncovered whitespace neither starts nor ends a run.
List<String> _coverageRuns(String text, List<int> counts) {
  final runs = <String>[];
  int runStart = -1;
  _Coverage runKind = .once;
  for (int i = 0; i <= text.length; i++) {
    final kind = i == text.length ? _Coverage.once : _kindAt(text, counts, i);
    if (kind != null && (kind != runKind || runStart < 0)) {
      if (runStart >= 0) runs.add('${runKind.name}: "${text.substring(runStart, i).trim()}"');
      runStart = kind == .once ? -1 : i;
      runKind = kind;
    }
  }
  return runs;
}

/// `null` = uncovered whitespace (ignored).
_Coverage? _kindAt(String text, List<int> counts, int i) {
  if (counts[i] > 1) return .duplicated;
  if (counts[i] == 1) return .once;
  return _whitespace.hasMatch(text[i]) ? null : .missing;
}
