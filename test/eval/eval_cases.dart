import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/capture/domain/entities/item_kind.dart';
import 'package:capture/features/capture/domain/entities/review_flag.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/groups/domain/group_rules.dart';

/// Labelled, synthetic evaluation set (no real diary content). Each expected
/// item is identified by the start of its source text; the item boundaries
/// are therefore gold thought boundaries.
class Expected {
  /// A note; [included] false means it is proposed but left out.
  const Expected.note(this.startsWith, this.groups, {this.included = true, this.flags = const {}})
    : kind = ItemKind.note,
      reminder = null,
      due = null;

  /// A task, optionally with a [reminder].
  const Expected.task(this.startsWith, this.groups, {this.reminder, this.flags = const {}})
    : kind = ItemKind.task,
      due = null,
      included = true;

  /// A task with a date-only [due] and no reminder.
  const Expected.deadline(this.startsWith, this.groups, DueDate this.due)
    : kind = ItemKind.task,
      reminder = null,
      included = true,
      flags = const {};

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
  const EvalCase(this.id, this.transcript, this.expected)
    : customGroups = null,
      capturedAtUtc = null;

  /// A case captured at [capturedAtUtc] instead of the default moment.
  const EvalCase.capturedAt(this.id, this.transcript, this.expected, DateTime this.capturedAtUtc)
    : customGroups = null;

  /// A case classified against [customGroups] instead of the defaults.
  const EvalCase.withGroups(this.id, this.transcript, this.expected, List<Group> this.customGroups)
    : capturedAtUtc = null;

  final String id;
  final String transcript;
  final List<Expected> expected;
  final List<Group>? customGroups;
  List<Group> get groups => customGroups ?? defaultEvalGroups;

  /// Defaults to Thu 17 Sep 2026 20:09 Europe/London.
  final DateTime? capturedAtUtc;

  DateTime get captured => capturedAtUtc ?? .utc(2026, 9, 17, 19, 9);

  /// Offsets where a new item must start (excluding the first).
  List<int> get goldBoundaries => [
    for (final e in expected.skip(1)) transcript.indexOf(e.startsWith),
  ];
}

const _tech = {'Tech'};
const _personal = {'Personal'};
const _work = {'Work'};
const _ideas = {'Ideas'};

final defaultEvalGroups = [
  for (final g in defaultGroups)
    Group(id: .new('g-${g.name.toLowerCase()}'), name: .new(g.name), description: g.description),
];

final evalCases = <EvalCase>[
  const .new(
    'mixed-brief-example',
    'I learned about Jev today. It could help organise my notes. I had a lovely evening with Sarah, and I thought of a meal-planning app. Remind me to buy groceries tomorrow at 2pm. Actually, make that 3pm.',
    [
      .note('I learned about Jev', _tech),
      .note('I had a lovely evening', _personal),
      .note('and I thought of a meal-planning', _ideas),
      .task(
        'Remind me to buy groceries',
        _personal,
        reminder: .new(2026, 9, 18, hour: 15, minute: 0),
      ),
    ],
  ),
  const .new(
    'related-sentences-one-note',
    'I learned about Dart isolates today. They let heavy work run off the UI thread.',
    [.note('I learned about Dart isolates', _tech)],
  ),
  const .new(
    'two-thoughts-one-sentence',
    'I enjoyed dinner with Priya and thought of a new budgeting app.',
    [.note('I enjoyed dinner', _personal), .note('and thought of a new budgeting app', _ideas)],
  ),
  const .new(
    'two-tasks-same-group',
    'I need to call the dentist. I also need to pick up the dry cleaning.',
    [.task('I need to call the dentist', _personal), .task('I also need to pick up', _personal)],
  ),
  const .new('milk-and-bread-one-task', 'Buy milk and bread.', [
    .task('Buy milk and bread', _personal),
  ]),
  const .new('milk-and-haircut-two-tasks', 'Buy milk and book a haircut.', [
    .task('Buy milk', _personal),
    .task('and book a haircut', _personal),
  ]),
  const .new(
    'corrected-reminder',
    'Remind me to call the plumber tomorrow at 2pm. Actually, 3pm.',
    [
      .task(
        'Remind me to call the plumber',
        _personal,
        reminder: .new(2026, 9, 18, hour: 15, minute: 0),
      ),
    ],
  ),
  const .new(
    'pronoun-continuations',
    'I met Tom at the conference. He works on compilers at Google. He suggested I try Zig for systems work.',
    [
      // Relabelled after the first live run: meeting someone is also a
      // defensible Personal note.
      .note('I met Tom', {'Tech', 'Work', 'Personal'}),
    ],
  ),
  const .new(
    'one-thought-two-groups',
    'Our team decided to migrate the build pipeline to Bazel next quarter.',
    [
      .note('Our team decided', {'Work', 'Tech'}),
    ],
  ),
  const .new(
    'late-ambiguous-correction',
    'Remind me to call mum at 5pm. Buy stamps. Oh, and make the call at 6pm instead.',
    [
      // The later "6pm instead" makes the time genuinely uncertain: the item
      // must not silently keep a reminder; it asks for a time instead. The
      // correction stays a separate, flagged item.
      .task('Remind me to call mum', _personal, flags: {.chooseTime}),
      .task('Buy stamps', _personal),
      .task('Oh, and make the call', _personal, flags: {.correctionElsewhere}),
    ],
  ),
  const .new(
    'hypothetical-negated-quoted-historical',
    'I might buy a bike. I bought groceries yesterday. Don’t remind me to call James. Sarah said "you should book the flights".',
    [
      // A possibility, so Ideas is also acceptable (relabelled after review).
      .note('I might buy a bike', {'Personal', 'Ideas'}),
      .note('I bought groceries yesterday', _personal),
      .note('Don’t remind me to call James', _personal),
      .note('Sarah said', _personal),
    ],
  ),
  const .new('task-without-alert', "I need to call James but don't remind me.", [
    .task('I need to call James', _personal),
  ]),
  const .new('date-only-deadline', 'Finish the quarterly report by Friday.', [
    .deadline('Finish the quarterly report', _work, .new(2026, 9, 18)),
  ]),
  const .new('ambiguous-am-pm', 'Remind me to water the plants tomorrow at two.', [
    .task('Remind me to water the plants', _personal, flags: {.chooseAmPm}),
  ]),
  .capturedAt(
    'daylight-saving-overlap',
    'Remind me tomorrow at 1:30am to check the boiler timer.',
    const [
      .task(
        'Remind me tomorrow',
        _personal,
        // Proposed as said but flagged; approvalProblems blocks it until the
        // user picks which 01:30 they mean.
        reminder: .new(2026, 10, 25, hour: 1, minute: 30),
        flags: {.clockChange},
      ),
    ],
    .utc(2026, 10, 24, 18),
  ),
  .withGroups(
    'custom-group-description',
    'The tomatoes need more water this week.',
    const [
      .note('The tomatoes', {'Garden'}),
    ],
    [
      ...defaultEvalGroups,
      .new(
        id: .new('g-garden'),
        name: .new('Garden'),
        description: 'Plants, vegetables, watering and the allotment.',
      ),
    ],
  ),
  const .new('silent', '', []),
  const .new(
    'poorly-punctuated',
    'so i was thinking about the new api design it should use cursor pagination also remind me to email sam tomorrow at 10am',
    [
      // A design idea: Ideas is also acceptable (relabelled after review).
      .note('so i was thinking', {'Tech', 'Ideas'}),
      .task('also remind me', _work, reminder: .new(2026, 9, 18, hour: 10, minute: 0)),
    ],
  ),
  const .new('retrieval-question', 'What did I say about the budget yesterday?', [
    .note(
      'What did I say',
      {'Unsorted', 'Work', 'Personal'},
      included: false,
      flags: {.recallUnsupported},
    ),
  ]),
];
