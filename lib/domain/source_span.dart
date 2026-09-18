/// Offsets convention (shared by all Dart code; native code never produces
/// offsets): UTF-16 code-unit indices into the transcript string, half-open
/// `[start, end)`. Boundaries are only ever placed on whitespace/word starts,
/// so a span never splits a surrogate pair.
class SourceSpan {
  const SourceSpan(this.start, this.end, this.excerpt);

  factory SourceSpan.of(String text, int start, int end) =>
      SourceSpan(start, end, text.substring(start, end));

  factory SourceSpan.fromJson(Map<String, Object?> json) => SourceSpan(
    json['start']! as int,
    json['end']! as int,
    json['excerpt']! as String,
  );

  final int start;
  final int end;

  /// Exact copy of the source text; kept separately because offsets alone go
  /// stale if the transcript is later edited outside the app.
  final String excerpt;

  Map<String, Object?> toJson() => {
    'start': start,
    'end': end,
    'excerpt': excerpt,
  };

  @override
  bool operator ==(Object other) =>
      other is SourceSpan &&
      other.start == start &&
      other.end == end &&
      other.excerpt == excerpt;

  @override
  int get hashCode => Object.hash(start, end, excerpt);

  @override
  String toString() => 'SourceSpan($start, $end, "$excerpt")';
}

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
      for (var i = span.start; i < span.end; i++) {
        counts[i]++;
      }
    }
  }
  return [...problems, ..._coverageRuns(text, counts)];
}

String? _spanProblem(String text, SourceSpan span) {
  if (span.start < 0 || span.end > text.length || span.start > span.end) {
    return 'invalid span ${span.start}-${span.end}';
  }
  if (text.substring(span.start, span.end) != span.excerpt) {
    return 'excerpt mismatch at ${span.start}';
  }
  return null;
}

final _whitespace = RegExp(r'\s');

/// Groups uncovered (non-whitespace) and duplicated characters into runs;
/// uncovered whitespace neither starts nor ends a run.
List<String> _coverageRuns(String text, List<int> counts) {
  final runs = <String>[];
  var runStart = -1;
  var runKind = '';
  for (var i = 0; i <= text.length; i++) {
    final kind = i == text.length ? '' : _kindAt(text, counts, i);
    if (kind == null) continue;
    if (kind == runKind && runStart >= 0) continue;
    if (runStart >= 0) {
      runs.add('$runKind: "${text.substring(runStart, i).trim()}"');
    }
    runStart = kind.isEmpty ? -1 : i;
    runKind = kind;
  }
  return runs;
}

/// `null` = uncovered whitespace (ignored), `''` = covered once.
String? _kindAt(String text, List<int> counts, int i) {
  if (counts[i] > 1) return 'duplicated';
  if (counts[i] == 1) return '';
  return _whitespace.hasMatch(text[i]) ? null : 'missing';
}
