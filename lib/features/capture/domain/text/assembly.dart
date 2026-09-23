import 'package:capture/features/capture/domain/jev/boundary_decision.dart';
import 'package:capture/features/capture/domain/text/coverage.dart';
import 'package:capture/features/capture/domain/text/thought.dart';
import 'package:capture/features/capture/domain/text/transcript_unit.dart';
import 'package:capture/features/capture/domain/values/passage_id.dart';

export 'package:capture/features/capture/domain/text/thought.dart';

/// Assembles thoughts from candidate units and Jev boundary decisions keyed
/// by unit index (index ≥ 1). A missing decision keeps units together.
/// Every unit lands in exactly one thought.
List<Thought> assembleThoughts(
  String transcript,
  List<TranscriptUnit> units,
  Map<int, BoundaryDecision> decisions,
) {
  final starts = [
    for (int i = 0; i < units.length; i++)
      if (i == 0 || _startsThought(decisions[i])) i,
  ];
  final ends = [...starts.skip(1), units.length];
  return [
    for (int g = 0; g < starts.length; g++)
      Thought(
        PassageId('T${g + 1}'),
        units.sublist(starts[g], ends[g]),
        spanOf(transcript, units[starts[g]].span.start, units[ends[g] - 1].span.end),
        uncertainStart: _uncertainAround(starts[g], ends[g], decisions),
        lateCorrection: _isLateCorrection(decisions[starts[g]]),
      ),
  ];
}

bool _startsThought(BoundaryDecision? decision) =>
    decision != null && (decision.split || decision.lateCorrection);

bool _isLateCorrection(BoundaryDecision? decision) => decision != null && decision.lateCorrection;

/// A thought is flagged when its own start was uncertain or when an
/// uncertain "no split" was absorbed inside it.
bool _uncertainAround(int from, int to, Map<int, BoundaryDecision> decisions) =>
    [for (int i = from; i < to; i++) decisions[i]].any((d) => d != null && d.uncertain);
