import 'package:capture/features/capture/domain/jev/jev_protocol.dart';
import 'package:capture/features/capture/domain/text/candidate_splitter.dart';

/// State shown to Jev for boundary decisions: ordered, labelled units.
String boundaryState(List<TranscriptUnit> units) => [
  'Voice diary transcript split into numbered units, in spoken order.',
  'Each line is "<unit id>| <exact words>".',
  '',
  for (final u in units) '${u.id}| ${u.span.excerpt}',
].join('\n');

String boundaryKey(TranscriptUnit unit) => 'boundary_${unit.id}';

String lateCorrectionKey(TranscriptUnit unit) => 'late_${unit.id}';

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
      'previous words (for example "It went well"), corrects them (for '
      'example "Sorry, I meant Tuesday"), adds a detail such as a time, or '
      'only lists more objects for the same action (for example "and some '
      'eggs").',
      yes: 'A new, independent note or action starts at ${units[i].id}.',
      no:
          '${units[i].id} continues, explains or corrects the thought before '
          'it.',
    ),
};

/// One Noul per unit from the third onwards: does it correct something said
/// before the immediately preceding unit? Such late corrections are kept out
/// of unrelated items and flagged instead of being attached silently.
Map<String, JevQuestion> lateCorrectionQuestions(List<TranscriptUnit> units) => {
  for (var i = 2; i < units.length; i++)
    lateCorrectionKey(units[i]): NoulQuestion(
      'Look at unit ${units[i].id}. Does ${units[i].id} change or correct a '
      'detail (such as a time, date, name or amount) of something said '
      'earlier than the unit immediately before it (${units[i - 1].id})? '
      'Answer no if ${units[i].id} only corrects ${units[i - 1].id}, or if it '
      'is new content of its own.',
      yes: '${units[i].id} corrects something said before ${units[i - 1].id}.',
      no: '${units[i].id} is new content or corrects only ${units[i - 1].id}.',
    ),
};

/// Split decision per unit index (index ≥ 1). `uncertain` feeds review
/// flags; provisional grouping still uses `split`. A late correction always
/// starts its own item.
class BoundaryDecision {
  const BoundaryDecision(this.split, this.uncertain, this.yes, {this.lateCorrection = false});
  final bool split;
  final bool uncertain;
  final double yes;
  final bool lateCorrection;
}
