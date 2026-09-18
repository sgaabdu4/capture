import 'package:capture/domain/models.dart';

/// Labelled, synthetic evaluation set (no real diary content). Each expected
/// item is identified by the start of its source text; the item boundaries
/// are therefore gold thought boundaries.
class Expected {
  const Expected(
    this.startsWith,
    this.groups,
    this.kind, {
    this.reminder,
    this.due,
    this.included = true,
    this.flags = const {},
  });

  final String startsWith;

  /// Acceptable primary groups (one coherent thought can fit several).
  final Set<String> groups;
  final ItemKind kind;
  final DueDate? reminder;
  final DueDate? due;
  final bool included;

  /// Review flags that must be present.
  final Set<ReviewFlag> flags;
}

class EvalCase {
  const EvalCase(
    this.id,
    this.transcript,
    this.expected, {
    this.customGroups,
    this.capturedAtUtc,
  });

  final String id;
  final String transcript;
  final List<Expected> expected;
  final List<Group>? customGroups;
  List<Group> get groups => customGroups ?? defaultEvalGroups;

  /// Defaults to Thu 17 Sep 2026 20:09 Europe/London.
  final DateTime? capturedAtUtc;

  DateTime get captured => capturedAtUtc ?? DateTime.utc(2026, 9, 17, 19, 9);

  /// Offsets where a new item must start (excluding the first).
  List<int> get goldBoundaries => [
    for (final e in expected.skip(1)) transcript.indexOf(e.startsWith),
  ];
}

const _tech = {'Tech'};
const _personal = {'Personal'};
const _work = {'Work'};
const _ideas = {'Ideas'};
const note = ItemKind.note;
const task = ItemKind.task;

final defaultEvalGroups = [
  for (final g in defaultGroups)
    Group(
      id: 'g-${g.name.toLowerCase()}',
      name: g.name,
      description: g.description,
    ),
];

final evalCases = <EvalCase>[
  const EvalCase(
    'mixed-brief-example',
    'I learned about Jev today. It could help organise my notes. I had a '
        'lovely evening with Sarah, and I thought of a meal-planning app. '
        'Remind me to buy groceries tomorrow at 2pm. Actually, make that 3pm.',
    [
      Expected('I learned about Jev', _tech, note),
      Expected('I had a lovely evening', _personal, note),
      Expected('and I thought of a meal-planning', _ideas, note),
      Expected(
        'Remind me to buy groceries',
        _personal,
        task,
        reminder: DueDate(2026, 9, 18, hour: 15, minute: 0),
      ),
    ],
  ),
  const EvalCase(
    'related-sentences-one-note',
    'I learned about Dart isolates today. They let heavy work run off the UI thread.',
    [Expected('I learned about Dart isolates', _tech, note)],
  ),
  const EvalCase(
    'two-thoughts-one-sentence',
    'I enjoyed dinner with Priya and thought of a new budgeting app.',
    [
      Expected('I enjoyed dinner', _personal, note),
      Expected('and thought of a new budgeting app', _ideas, note),
    ],
  ),
  const EvalCase(
    'two-tasks-same-group',
    'I need to call the dentist. I also need to pick up the dry cleaning.',
    [
      Expected('I need to call the dentist', _personal, task),
      Expected('I also need to pick up', _personal, task),
    ],
  ),
  const EvalCase('milk-and-bread-one-task', 'Buy milk and bread.', [
    Expected('Buy milk and bread', _personal, task),
  ]),
  const EvalCase('milk-and-haircut-two-tasks', 'Buy milk and book a haircut.', [
    Expected('Buy milk', _personal, task),
    Expected('and book a haircut', _personal, task),
  ]),
  const EvalCase(
    'corrected-reminder',
    'Remind me to call the plumber tomorrow at 2pm. Actually, 3pm.',
    [
      Expected(
        'Remind me to call the plumber',
        _personal,
        task,
        reminder: DueDate(2026, 9, 18, hour: 15, minute: 0),
      ),
    ],
  ),
  const EvalCase(
    'pronoun-continuations',
    'I met Tom at the conference. He works on compilers at Google. He '
        'suggested I try Zig for systems work.',
    [
      // Relabelled after the first live run: meeting someone is also a
      // defensible Personal note.
      Expected('I met Tom', {'Tech', 'Work', 'Personal'}, note),
    ],
  ),
  const EvalCase(
    'one-thought-two-groups',
    'Our team decided to migrate the build pipeline to Bazel next quarter.',
    [
      Expected('Our team decided', {'Work', 'Tech'}, note),
    ],
  ),
  const EvalCase(
    'late-ambiguous-correction',
    'Remind me to call mum at 5pm. Buy stamps. Oh, and make the call at 6pm instead.',
    [
      // The later "6pm instead" makes the time genuinely uncertain: the item
      // must not silently keep a reminder; it asks for a time instead. The
      // correction stays a separate, flagged item.
      Expected(
        'Remind me to call mum',
        _personal,
        task,
        flags: {ReviewFlag.chooseTime},
      ),
      Expected('Buy stamps', _personal, task),
      Expected(
        'Oh, and make the call',
        _personal,
        task,
        flags: {ReviewFlag.correctionElsewhere},
      ),
    ],
  ),
  const EvalCase(
    'hypothetical-negated-quoted-historical',
    'I might buy a bike. I bought groceries yesterday. Don’t remind me to '
        'call James. Sarah said "you should book the flights".',
    [
      // A possibility, so Ideas is also acceptable (relabelled after review).
      Expected('I might buy a bike', {'Personal', 'Ideas'}, note),
      Expected('I bought groceries yesterday', _personal, note),
      Expected('Don’t remind me to call James', _personal, note),
      Expected('Sarah said', _personal, note),
    ],
  ),
  const EvalCase(
    'task-without-alert',
    "I need to call James but don't remind me.",
    [Expected('I need to call James', _personal, task)],
  ),
  const EvalCase(
    'date-only-deadline',
    'Finish the quarterly report by Friday.',
    [
      Expected(
        'Finish the quarterly report',
        _work,
        task,
        due: DueDate(2026, 9, 18),
      ),
    ],
  ),
  const EvalCase(
    'ambiguous-am-pm',
    'Remind me to water the plants tomorrow at two.',
    [
      Expected(
        'Remind me to water the plants',
        _personal,
        task,
        flags: {ReviewFlag.chooseAmPm},
      ),
    ],
  ),
  EvalCase(
    'daylight-saving-overlap',
    'Remind me tomorrow at 1:30am to check the boiler timer.',
    const [
      Expected(
        'Remind me tomorrow',
        _personal,
        task,
        // Proposed as said but flagged; approvalProblems blocks it until the
        // user picks which 01:30 they mean.
        reminder: DueDate(2026, 10, 25, hour: 1, minute: 30),
        flags: {ReviewFlag.clockChange},
      ),
    ],
    capturedAtUtc: DateTime.utc(2026, 10, 24, 18),
  ),
  EvalCase(
    'custom-group-description',
    'The tomatoes need more water this week.',
    const [
      Expected('The tomatoes', {'Garden'}, note),
    ],
    customGroups: [
      ...defaultEvalGroups,
      const Group(
        id: 'g-garden',
        name: 'Garden',
        description: 'Plants, vegetables, watering and the allotment.',
      ),
    ],
  ),
  const EvalCase('silent', '', []),
  const EvalCase(
    'poorly-punctuated',
    'so i was thinking about the new api design it should use cursor '
        'pagination also remind me to email sam tomorrow at 10am',
    [
      // A design idea: Ideas is also acceptable (relabelled after review).
      Expected('so i was thinking', {'Tech', 'Ideas'}, note),
      Expected(
        'also remind me',
        _work,
        task,
        reminder: DueDate(2026, 9, 18, hour: 10, minute: 0),
      ),
    ],
  ),
  const EvalCase(
    'retrieval-question',
    'What did I say about the budget yesterday?',
    [
      Expected(
        'What did I say',
        {'Unsorted', 'Work', 'Personal'},
        note,
        included: false,
        flags: {ReviewFlag.recallUnsupported},
      ),
    ],
  ),
];
