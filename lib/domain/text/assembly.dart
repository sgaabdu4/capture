import '../jev/boundary_pass.dart';
import '../source_span.dart';
import 'candidate_splitter.dart';

/// A complete thought: consecutive units joined at the selected boundaries.
/// Its span runs from the first unit's start to the last unit's end, so the
/// text between units is copied exactly (never re-joined or rewritten).
class Thought {
  const Thought(
    this.id,
    this.units,
    this.span, {
    this.uncertainStart = false,
    this.lateCorrection = false,
  });

  final String id;
  final List<TranscriptUnit> units;
  final SourceSpan span;

  /// True when the boundary that started this thought was uncertain.
  final bool uncertainStart;

  /// True when the thought starts with a correction of an earlier,
  /// non-adjacent thought.
  final bool lateCorrection;
}

/// Assembles thoughts from candidate units and Jev boundary decisions keyed
/// by unit index (index ≥ 1). A missing decision keeps units together.
/// Every unit lands in exactly one thought.
List<Thought> assembleThoughts(
  String transcript,
  List<TranscriptUnit> units,
  Map<int, BoundaryDecision> decisions,
) {
  final groups = <List<int>>[];
  for (var i = 0; i < units.length; i++) {
    final d = decisions[i];
    final split = i == 0 || (d?.split ?? false) || (d?.lateCorrection ?? false);
    if (split) {
      groups.add([i]);
    } else {
      groups.last.add(i);
    }
  }
  return [
    for (var g = 0; g < groups.length; g++)
      Thought(
        'T${g + 1}',
        [for (final i in groups[g]) units[i]],
        SourceSpan.of(
          transcript,
          units[groups[g].first].span.start,
          units[groups[g].last].span.end,
        ),
        uncertainStart: _uncertainAround(groups[g], decisions),
        lateCorrection: decisions[groups[g].first]?.lateCorrection ?? false,
      ),
  ];
}

/// A thought is flagged when its own start was uncertain or when an
/// uncertain "no split" was absorbed inside it.
bool _uncertainAround(List<int> group, Map<int, BoundaryDecision> decisions) =>
    group.any((i) => decisions[i]?.uncertain ?? false);
