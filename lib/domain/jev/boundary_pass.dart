import '../text/candidate_splitter.dart';
import 'jev_protocol.dart';

/// State shown to Jev for boundary decisions: ordered, labelled units.
String boundaryState(List<TranscriptUnit> units) => [
  'Voice diary transcript split into numbered units, in spoken order.',
  'Each line is "<unit id>| <exact words>".',
  '',
  for (final u in units) '${u.id}| ${u.span.excerpt}',
].join('\n');

String boundaryKey(TranscriptUnit unit) => 'boundary_${unit.id}';

/// One focused Noul per candidate boundary (every unit after the first).
/// The unit id is in the instructions because keys are not seen by Jev.
Map<String, JevQuestion> boundaryQuestions(List<TranscriptUnit> units) => {
  for (var i = 1; i < units.length; i++)
    boundaryKey(units[i]): NoulQuestion(
      'Look at unit ${units[i].id} and the unit immediately before it '
      '(${units[i - 1].id}). Immediately before unit ${units[i].id}, does a '
      'new, independently useful note or action begin, rather than a '
      'continuation, explanation, correction or reference belonging to the '
      'preceding thought? Answer yes when ${units[i].id} starts a separate '
      'thought or a separate action that makes sense filed on its own, even '
      'if it is about the same topic (two different errands are two '
      'actions). Answer no when ${units[i].id} continues or explains the '
      'previous words (for example "It was useful"), corrects them (for '
      'example "Actually, make that 3pm"), adds a detail such as a time, or '
      'only lists more objects for the same action (for example "and '
      'bread").',
      yes: 'A new, independent note or action starts at ${units[i].id}.',
      no:
          '${units[i].id} continues, explains or corrects the thought before '
          'it.',
    ),
};

/// Split decision per unit index (index ≥ 1). `uncertain` feeds review
/// flags; provisional grouping still uses `split`.
class BoundaryDecision {
  const BoundaryDecision(this.split, this.uncertain, this.yes);
  final bool split;
  final bool uncertain;
  final double yes;
}
