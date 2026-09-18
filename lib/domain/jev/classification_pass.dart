import '../dates/date_candidates.dart';
import '../models.dart';
import '../text/assembly.dart';
import 'jev_protocol.dart';

/// Everything needed to ask and later decode the classification pass. The
/// option → group-id mapping is local; Jev never sees ids and cannot invent
/// groups.
class ClassificationPlan {
  ClassificationPlan._(
    this.state,
    this.questions,
    this.groupOptions,
    this.candidates,
  );

  final String state;
  final Map<String, JevQuestion> questions;

  /// Option name → group id (null for the implicit Unsorted fallback).
  final Map<String, String?> groupOptions;
  final Map<String, FoundCandidates> candidates;
}

const noneOption = 'none';

ClassificationPlan planClassification(
  String transcript,
  List<Thought> thoughts,
  List<Group> groups,
) {
  final groupOptions = _groupOptions(groups);
  final criteria = <String, String?>{
    for (final g in groups.where((g) => !g.archived))
      g.name.trim(): g.description,
  };
  if (!criteria.keys.any(
    (k) => k.toLowerCase() == unsortedName.toLowerCase(),
  )) {
    criteria[unsortedName] = 'None of the other groups clearly fits.';
  }
  final questions = <String, JevQuestion>{};
  final candidates = <String, FoundCandidates>{};
  for (final t in thoughts) {
    final found = findDateCandidates(transcript, t.span, prefix: t.id);
    candidates[t.id] = found;
    questions.addAll(_thoughtQuestions(t.id, criteria, found));
  }
  return ClassificationPlan._(
    _state(thoughts),
    questions,
    groupOptions,
    candidates,
  );
}

Map<String, String?> _groupOptions(List<Group> groups) {
  final map = <String, String?>{
    for (final g in groups.where((g) => !g.archived)) g.name.trim(): g.id,
  };
  if (!map.keys.any((k) => k.toLowerCase() == unsortedName.toLowerCase())) {
    map[unsortedName] = null;
  }
  return map;
}

String _state(List<Thought> thoughts) => [
  'Thoughts from one voice diary recording, in spoken order.',
  'Each line is "<thought id>| <exact words>". Judge each thought by its '
      'own words; other lines are context only.',
  '',
  for (final t in thoughts) '${t.id}| ${t.span.excerpt}',
].join('\n');

Map<String, JevQuestion> _thoughtQuestions(
  String id,
  Map<String, String?> groupCriteria,
  FoundCandidates found,
) => {
  '${id}_group': ChoiceQuestion(
    'Consider only thought $id. Which group should thought $id be filed '
    'under? Choose the group whose description best fits the main subject '
    'of $id. Choose $unsortedName if no group clearly fits.',
    groupCriteria,
  ),
  '${id}_task': NoulQuestion(
    'Consider only thought $id. Does $id state a present or future action '
    'that the speaker personally intends or needs to do and would want to '
    'track as a to-do? Answer no for things already done, possibilities or '
    "wishes ('I might', 'maybe'), hypotheticals, words quoted from someone "
    "else, other people's actions, questions, and actions the speaker says "
    'not to do.',
    yes: '$id contains a to-do the speaker wants to track.',
    no: '$id is a note, memory, idea, question or non-committal thought.',
  ),
  '${id}_alert': NoulQuestion(
    'Consider only thought $id. Does the speaker explicitly ask to be '
    'reminded or notified in $id? Answer no if $id says not to remind them, '
    'or only mentions a time or deadline without asking for a reminder.',
    yes: '$id explicitly asks for a reminder or notification.',
    no: '$id does not ask for a reminder.',
  ),
  '${id}_recall': NoulQuestion(
    'Consider only thought $id. Is $id a question or request asking this '
    'app to find, recall, summarise or answer something (for example "What '
    'did I say yesterday?"), rather than something to save?',
  ),
  if (found.days.isNotEmpty)
    '${id}_day': ChoiceQuestion(
      'Consider only thought $id. Which listed day expression in $id gives '
      'the day the speaker finally intends for this task, deadline or '
      'reminder? Ignore expressions describing past events, negated '
      'expressions, and expressions replaced by a later correction. Choose '
      '$noneOption if none applies or it is unclear.',
      {
        for (final d in found.days) d.id: '"${d.span.excerpt}" in $id',
        noneOption: 'No listed expression gives the intended day.',
      },
    ),
  if (found.times.isNotEmpty)
    '${id}_time': ChoiceQuestion(
      'Consider only thought $id. Which listed time expression in $id gives '
      'the time of day the speaker finally intends for this task or '
      'reminder? If the speaker corrects a time (for example "at 2pm, '
      'actually 3pm"), choose the corrected one. Ignore past, negated or '
      'replaced times. Choose $noneOption if none applies or it is unclear.',
      {
        for (final t in found.times) t.id: '"${t.span.excerpt}" in $id',
        noneOption: 'No listed expression gives the intended time.',
      },
    ),
};

/// Decoded per-thought decisions. Code combines them; no answer assumes
/// another's result.
class ThoughtDecision {
  const ThoughtDecision({
    required this.groupOption,
    required this.groupConfidence,
    required this.task,
    required this.alert,
    required this.recall,
    this.day,
    this.dayConfidence = 1,
    this.time,
    this.timeConfidence = 1,
  });

  final String groupOption;
  final double groupConfidence;
  final double task;
  final double alert;
  final double recall;
  final DayCandidate? day;
  final double dayConfidence;
  final TimeCandidate? time;
  final double timeConfidence;
}

Map<String, ThoughtDecision> decodeClassification(
  ClassificationPlan plan,
  List<Thought> thoughts,
  Map<String, JevAnswer> answers,
) => {for (final t in thoughts) t.id: _decodeThought(plan, t.id, answers)};

ThoughtDecision _decodeThought(
  ClassificationPlan plan,
  String id,
  Map<String, JevAnswer> answers,
) {
  T answer<T extends JevAnswer>(String key) {
    final a = answers[key];
    if (a is T) return a;
    throw JevDecodeException('missing $key');
  }

  final group = answer<ChoiceAnswer>('${id}_group');
  final found = plan.candidates[id]!;
  final day = answers['${id}_day'];
  final time = answers['${id}_time'];
  return ThoughtDecision(
    groupOption: group.choice,
    groupConfidence: group.confidence,
    task: answer<NoulAnswer>('${id}_task').yes,
    alert: answer<NoulAnswer>('${id}_alert').yes,
    recall: answer<NoulAnswer>('${id}_recall').yes,
    day: day is ChoiceAnswer
        ? found.days.where((d) => d.id == day.choice).firstOrNull
        : null,
    dayConfidence: day is ChoiceAnswer ? day.confidence : 1,
    time: time is ChoiceAnswer
        ? found.times.where((t) => t.id == time.choice).firstOrNull
        : null,
    timeConfidence: time is ChoiceAnswer ? time.confidence : 1,
  );
}
