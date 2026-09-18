import 'source_span.dart';

enum ItemKind { note, task }

/// A user-configured group. [id] is the Notion page id of the Groups entry
/// (stable across renames); library relations always use it.
class Group {
  const Group({
    required this.id,
    required this.name,
    required this.description,
    this.archived = false,
  });

  factory Group.fromJson(Map<String, Object?> json) => Group(
    id: json['id']! as String,
    name: json['name']! as String,
    description: json['description']! as String,
    archived: json['archived'] as bool? ?? false,
  );

  final String id;
  final String name;
  final String description;
  final bool archived;

  bool get isUnsorted =>
      name.trim().toLowerCase() == unsortedName.toLowerCase();

  Group copyWith({String? name, String? description, bool? archived}) => Group(
    id: id,
    name: name ?? this.name,
    description: description ?? this.description,
    archived: archived ?? this.archived,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'archived': archived,
  };
}

const unsortedName = 'Unsorted';

/// Suggested, editable defaults created with the library.
const defaultGroups = [
  (
    name: 'Tech',
    description:
        'Learning and observations about programming, software, AI and '
        'technical tools. Excludes speculative new product proposals unless '
        'they are mainly technical learning.',
  ),
  (
    name: 'Personal',
    description:
        'Daily life, family, friends, household matters and personal '
        'reflections.',
  ),
  (
    name: 'Work',
    description:
        'Work-related administration, team discussions and professional '
        'commitments.',
  ),
  (
    name: 'Ideas',
    description:
        'Possible products, improvements and things to explore without '
        'necessarily committing to a task.',
  ),
  (
    name: unsortedName,
    description: 'None of the other groups fits, or the user needs to choose.',
  ),
];

/// Returns a validation message for a group edit, or null when valid.
String? validateGroup(
  String name,
  String description,
  Iterable<Group> existing, {
  String? editingId,
}) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return 'Add a name.';
  if (trimmed.length > 60) return 'Keep the name under 60 characters.';
  if (description.trim().isEmpty) return 'Add a short description.';
  final duplicate = existing.any(
    (g) =>
        g.id != editingId &&
        g.name.trim().toLowerCase() == trimmed.toLowerCase(),
  );
  return duplicate ? 'Another group already uses this name.' : null;
}

/// A calendar date with optional time-of-day, in the capture's time zone.
/// Precision is explicit: [hour]/[minute] are null for date-only deadlines.
class DueDate {
  const DueDate(this.year, this.month, this.day, {this.hour, this.minute});

  factory DueDate.fromJson(Map<String, Object?> json) => DueDate(
    json['year']! as int,
    json['month']! as int,
    json['day']! as int,
    hour: json['hour'] as int?,
    minute: json['minute'] as int?,
  );

  final int year;
  final int month;
  final int day;
  final int? hour;
  final int? minute;

  bool get hasTime => hour != null;

  DueDate withTime(int hour, int minute) =>
      DueDate(year, month, day, hour: hour, minute: minute);

  DueDate get dateOnly => DueDate(year, month, day);

  /// ISO date or local date-time without offset, e.g. `2026-09-19` or
  /// `2026-09-19T14:00:00`.
  String get iso {
    final date =
        '${year.toString().padLeft(4, '0')}-${_two(month)}-${_two(day)}';
    return hasTime ? '${date}T${_two(hour!)}:${_two(minute ?? 0)}:00' : date;
  }

  Map<String, Object?> toJson() => {
    'year': year,
    'month': month,
    'day': day,
    if (hour != null) 'hour': hour,
    if (minute != null) 'minute': minute,
  };

  @override
  bool operator ==(Object other) =>
      other is DueDate &&
      other.year == year &&
      other.month == month &&
      other.day == day &&
      other.hour == hour &&
      other.minute == minute;

  @override
  int get hashCode => Object.hash(year, month, day, hour, minute);

  @override
  String toString() => iso;
}

String _two(int v) => v.toString().padLeft(2, '0');

/// Template review reasons. The app never generates clarification prose.
enum ReviewFlag {
  checkSplit('Check this split'),
  checkGroup('Check the group'),
  checkTask('Check whether this is a task'),
  checkReminder('Check the reminder'),
  chooseTime('Choose a time'),
  chooseAmPm('Choose AM or PM'),
  chooseDate('Choose a date'),
  checkDate('Check which date applies'),
  timePassed('This time has already passed'),
  clockChange('Check the time (clock change)'),
  correctionElsewhere('Check which item this correction belongs to'),
  recallUnsupported("Recall isn't available in this version"),
  newPiece('Review this new piece'),
  classificationFailed("Couldn't classify automatically");

  const ReviewFlag(this.label);
  final String label;
}

/// One proposed note or task. Built by code from Jev decisions and source
/// text; the user's edits always take precedence over suggestions.
class ProposalItem {
  const ProposalItem({
    required this.id,
    required this.sources,
    required this.kind,
    required this.groupId,
    required this.title,
    required this.body,
    this.due,
    this.reminder,
    this.flags = const {},
    this.edited = const {},
    this.included = true,
  });

  factory ProposalItem.fromJson(Map<String, Object?> json) => ProposalItem(
    id: json['id']! as String,
    sources: [
      for (final s in json['sources']! as List<Object?>)
        SourceSpan.fromJson(s! as Map<String, Object?>),
    ],
    kind: ItemKind.values.byName(json['kind']! as String),
    groupId: json['groupId'] as String?,
    title: json['title']! as String,
    body: json['body']! as String,
    due: json['due'] == null
        ? null
        : DueDate.fromJson(json['due']! as Map<String, Object?>),
    reminder: json['reminder'] == null
        ? null
        : DueDate.fromJson(json['reminder']! as Map<String, Object?>),
    flags: {
      for (final f in json['flags'] as List<Object?>? ?? const [])
        ReviewFlag.values.byName(f! as String),
    },
    edited: {
      for (final f in json['edited'] as List<Object?>? ?? const [])
        f! as String,
    },
    included: json['included'] as bool? ?? true,
  );

  /// Stable item id generated by code before any request.
  final String id;

  /// Supporting source passages (offsets + exact excerpts), in order.
  final List<SourceSpan> sources;
  final ItemKind kind;

  /// Notion page id of the group; null only while the user must choose.
  final String? groupId;
  final String title;

  /// Editable body; starts as a copy of the source text.
  final String body;
  final DueDate? due;

  /// Local wall-clock reminder time in the capture time zone.
  final DueDate? reminder;
  final Set<ReviewFlag> flags;

  /// Fields the user changed ('title', 'body', 'group', 'kind', 'due',
  /// 'reminder'). Model suggestions never overwrite these.
  final Set<String> edited;

  /// False when the user removed the item (or recall-only questions).
  final bool included;

  String get sourceText => sources.map((s) => s.excerpt).join(' ');

  ProposalItem copyWith({
    List<SourceSpan>? sources,
    ItemKind? kind,
    String? groupId,
    String? title,
    String? body,
    DueDate? Function()? due,
    DueDate? Function()? reminder,
    Set<ReviewFlag>? flags,
    Set<String>? edited,
    bool? included,
  }) => ProposalItem(
    id: id,
    sources: sources ?? this.sources,
    kind: kind ?? this.kind,
    groupId: groupId ?? this.groupId,
    title: title ?? this.title,
    body: body ?? this.body,
    due: due == null ? this.due : due(),
    reminder: reminder == null ? this.reminder : reminder(),
    flags: flags ?? this.flags,
    edited: edited ?? this.edited,
    included: included ?? this.included,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'sources': [for (final s in sources) s.toJson()],
    'kind': kind.name,
    'groupId': groupId,
    'title': title,
    'body': body,
    'due': due?.toJson(),
    'reminder': reminder?.toJson(),
    'flags': [for (final f in flags) f.name],
    'edited': edited.toList(),
    'included': included,
  };
}

/// Deterministic count shown on the review card, e.g. `2 notes · 1 task ·
/// 1 reminder`.
String proposalSummary(Iterable<ProposalItem> items) {
  final included = items.where((i) => i.included).toList();
  final notes = included.where((i) => i.kind == ItemKind.note).length;
  final tasks = included.where((i) => i.kind == ItemKind.task).length;
  final reminders = included
      .where((i) => i.kind == ItemKind.task && i.reminder != null)
      .length;
  String part(int n, String word) => '$n $word${n == 1 ? '' : 's'}';
  return [
    if (notes > 0) part(notes, 'note'),
    if (tasks > 0) part(tasks, 'task'),
    if (reminders > 0) part(reminders, 'reminder'),
  ].join(' · ');
}
