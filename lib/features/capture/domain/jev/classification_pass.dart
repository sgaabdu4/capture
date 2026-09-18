import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/capture/domain/dates/date_candidates.dart';
import 'package:capture/features/capture/domain/jev/classification_plan.dart';
import 'package:capture/features/capture/domain/jev/jev_keys.dart';
import 'package:capture/features/capture/domain/jev/jev_protocol.dart';
import 'package:capture/features/capture/domain/jev/thought_decision.dart';
import 'package:capture/features/capture/domain/text/thought.dart';
import 'package:capture/features/groups/domain/entities/group.dart';

export 'package:capture/features/capture/domain/jev/classification_plan.dart';
export 'package:capture/features/capture/domain/jev/thought_decision.dart';

const noneOption = 'none';

ClassificationPlan planClassification(
  String transcript,
  List<Thought> thoughts,
  List<Group> groups,
) {
  final groupOptions = _groupOptions(groups);
  final criteria = <String, String?>{
    for (final g in groups.where((g) => !g.archived)) g.name.trim(): g.description,
  };
  if (!criteria.keys.any((k) => k.toLowerCase() == Group.unsortedName.toLowerCase())) {
    criteria[Group.unsortedName] = 'None of the other groups clearly fits.';
  }
  final questions = <String, JevQuestion>{};
  final candidates = <String, FoundCandidates>{};
  for (final t in thoughts) {
    final found = findDateCandidates(transcript, t.span, prefix: t.id);
    candidates[t.id] = found;
    questions.addAll(_thoughtQuestions(t.id, criteria, found));
  }
  return .new(
    state: _state(thoughts),
    questions: questions,
    groupOptions: groupOptions,
    unsortedGroupId: groups.where((g) => g.isUnsorted && !g.archived).firstOrNull?.id,
    candidates: candidates,
  );
}

Map<String, String?> _groupOptions(List<Group> groups) {
  final map = <String, String?>{
    for (final g in groups.where((g) => !g.archived)) g.name.trim(): g.id,
  };
  if (!map.keys.any((k) => k.toLowerCase() == Group.unsortedName.toLowerCase())) {
    map[Group.unsortedName] = null;
  }
  return map;
}

String _state(List<Thought> thoughts) => [
  'Thoughts from one voice diary recording, in spoken order.',
  'Each line is "<thought id>| <exact words>". Judge each thought by its own words; other lines are context only.',
  '',
  for (final t in thoughts) '${t.id}| ${t.span.excerpt}',
].join('\n');

Map<String, JevQuestion> _thoughtQuestions(
  String id,
  Map<String, String?> groupCriteria,
  FoundCandidates found,
) => {
  groupQuestionKey(id): ChoiceQuestion(
    'Consider only thought $id. Which group should thought $id be filed under? Choose the group whose description best fits the main subject of $id. Choose ${Group.unsortedName} if no group clearly fits.',
    groupCriteria,
  ),
  taskQuestionKey(id): NoulQuestion(
    "Consider only thought $id. Does $id state a present or future action that the speaker personally intends or needs to do and would want to track as a to-do? Answer no for things already done, possibilities or wishes ('I might', 'maybe'), hypotheticals, words quoted from someone else, other people's actions, questions, and actions the speaker says not to do.",
    yes: '$id contains a to-do the speaker wants to track.',
    no: '$id is a note, memory, idea, question or non-committal thought.',
  ),
  alertQuestionKey(id): NoulQuestion(
    'Consider only thought $id. Does the speaker explicitly ask to be reminded or notified in $id? Answer no if $id says not to remind them, or only mentions a time or deadline without asking for a reminder.',
    yes: '$id explicitly asks for a reminder or notification.',
    no: '$id does not ask for a reminder.',
  ),
  recallQuestionKey(id): NoulQuestion(
    'Consider only thought $id. Is $id a question or request asking this app to find, recall, summarise or answer something (for example "What did I say yesterday?"), rather than something to save?',
  ),
  if (found.days.isNotEmpty)
    dayQuestionKey(id): ChoiceQuestion(
      'Consider only thought $id. Which listed day expression in $id gives the day the speaker finally intends for this task, deadline or reminder? Ignore expressions describing past events, negated expressions, and expressions replaced by a later correction. Choose $noneOption if none applies or it is unclear.',
      {
        for (final d in found.days) d.id: '"${d.span.excerpt}" in $id',
        noneOption: 'No listed expression gives the intended day.',
      },
    ),
  if (found.times.isNotEmpty)
    timeQuestionKey(id): ChoiceQuestion(
      'Consider only thought $id. Which listed time expression in $id gives the time of day the speaker finally intends for this task or reminder? If the speaker corrects a time (for example "at 2pm, actually 3pm"), choose the corrected one. Ignore past, negated or replaced times. Choose $noneOption if none applies or it is unclear.',
      {
        for (final t in found.times) t.id: '"${t.span.excerpt}" in $id',
        noneOption: 'No listed expression gives the intended time.',
      },
    ),
};

/// Decodes one decision per thought, in order. Fails when an asked
/// question has no answer of its type.
Result<List<ThoughtDecision>, JevProtocolFailure> decodeClassification(
  ClassificationPlan plan,
  List<Thought> thoughts,
  Map<String, JevAnswer> answers,
) {
  final decisions = <ThoughtDecision>[];
  for (final thought in thoughts) {
    final decision = _decodeThought(plan, thought, answers);
    if (decision == null) return const .err(.missingAnswer);
    decisions.add(decision);
  }
  return .ok(decisions);
}

ThoughtDecision? _decodeThought(
  ClassificationPlan plan,
  Thought thought,
  Map<String, JevAnswer> answers,
) {
  final id = thought.id;
  final group = answers[groupQuestionKey(id)];
  final task = answers[taskQuestionKey(id)];
  final alert = answers[alertQuestionKey(id)];
  final recall = answers[recallQuestionKey(id)];
  final found = plan.candidates[id];
  if (found == null) return null;
  if (group is! ChoiceAnswer ||
      task is! NoulAnswer ||
      alert is! NoulAnswer ||
      recall is! NoulAnswer) {
    return null;
  }
  final day = answers[dayQuestionKey(id)];
  final time = answers[timeQuestionKey(id)];
  return .new(
    thought: thought,
    groupOption: group.choice,
    groupConfidence: group.confidence,
    task: task.yes,
    alert: alert.yes,
    recall: recall.yes,
    day: day is ChoiceAnswer ? found.days.where((d) => d.id == day.choice).firstOrNull : null,
    dayConfidence: day is ChoiceAnswer ? day.confidence : 1,
    time: time is ChoiceAnswer ? found.times.where((t) => t.id == time.choice).firstOrNull : null,
    timeConfidence: time is ChoiceAnswer ? time.confidence : 1,
  );
}
