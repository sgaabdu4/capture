import '../models.dart';
import '../source_span.dart';
import '../text/candidate_splitter.dart';
import '../text/titles.dart';

/// User edits. Every function returns new items; source links are always
/// preserved and fields the user touched are recorded in `edited`.

ProposalItem setTitle(ProposalItem item, String title) =>
    item.copyWith(title: title, edited: {...item.edited, 'title'});

ProposalItem setBody(ProposalItem item, String body) =>
    item.copyWith(body: body, edited: {...item.edited, 'body'});

ProposalItem setGroup(ProposalItem item, String groupId) => item.copyWith(
  groupId: groupId,
  edited: {...item.edited, 'group'},
  flags: item.flags.difference({ReviewFlag.checkGroup, ReviewFlag.newPiece}),
);

ProposalItem setKind(ProposalItem item, ItemKind kind) => item.copyWith(
  kind: kind,
  edited: {...item.edited, 'kind'},
  due: kind == ItemKind.note ? () => null : null,
  reminder: kind == ItemKind.note ? () => null : null,
  flags: item.flags.difference({
    ReviewFlag.checkTask,
    ReviewFlag.newPiece,
    if (kind == ItemKind.note) ..._dateFlags,
  }),
);

const _dateFlags = {
  ReviewFlag.chooseTime,
  ReviewFlag.chooseAmPm,
  ReviewFlag.chooseDate,
  ReviewFlag.checkDate,
  ReviewFlag.timePassed,
  ReviewFlag.clockChange,
  ReviewFlag.checkReminder,
};

/// Sets or clears the due date. [flags] are the resolver's checks for the
/// new value (e.g. time passed / clock change).
ProposalItem setDue(
  ProposalItem item,
  DueDate? due, {
  Set<ReviewFlag> flags = const {},
}) => item.copyWith(
  due: () => due,
  edited: {...item.edited, 'due'},
  flags: item.flags
      .difference({
        ReviewFlag.chooseDate,
        ReviewFlag.checkDate,
        ReviewFlag.chooseAmPm,
        ReviewFlag.chooseTime,
        ReviewFlag.timePassed,
        ReviewFlag.clockChange,
      })
      .union(flags),
);

/// Sets or removes the reminder; a reminder implies a task.
ProposalItem setReminder(
  ProposalItem item,
  DueDate? reminder, {
  Set<ReviewFlag> flags = const {},
}) => item.copyWith(
  kind: reminder == null ? item.kind : ItemKind.task,
  reminder: () => reminder,
  due: reminder == null ? null : () => item.due ?? reminder,
  edited: {...item.edited, 'reminder'},
  flags: item.flags.difference(_dateFlags).union(flags),
);

ProposalItem setIncluded(ProposalItem item, bool included) =>
    item.copyWith(included: included, edited: {...item.edited, 'included'});

/// Splits [item] at transcript offset [at] (which must fall strictly inside
/// one of its source spans, on whitespace/word start). Both pieces keep
/// their source links, reset body/title to their own source text and are
/// flagged for group/type review. Returns null for an invalid split point.
(ProposalItem, ProposalItem)? splitItem(
  ProposalItem item,
  String transcript,
  int at,
  String newId,
) {
  final index = item.sources.indexWhere((s) => at > s.start && at < s.end);
  if (index < 0) return null;
  final span = item.sources[index];
  final leftEnd = trimEnd(transcript, span.start, at);
  final rightStart = firstNonSpace(transcript, at);
  if (leftEnd <= span.start || rightStart >= span.end) return null;
  final left = [
    ...item.sources.take(index),
    SourceSpan.of(transcript, span.start, leftEnd),
  ];
  final right = [
    SourceSpan.of(transcript, rightStart, span.end),
    ...item.sources.skip(index + 1),
  ];
  ProposalItem piece(String id, List<SourceSpan> sources) {
    final excerpt = sources.map((s) => s.excerpt).join(' ');
    return ProposalItem(
      id: id,
      sources: sources,
      kind: item.kind,
      groupId: item.groupId,
      title: proposedTitle(excerpt),
      body: proposedBody(excerpt),
      due: item.due,
      reminder: item.reminder,
      flags: {
        ...item.flags.difference({ReviewFlag.checkSplit}),
        ReviewFlag.newPiece,
      },
    );
  }

  return (piece(item.id, left), piece(newId, right));
}

/// Merges [second] into [first]. The first item's choices (and any user
/// edits) are kept; differing group/type is flagged instead of silently
/// picking one.
ProposalItem mergeItems(ProposalItem first, ProposalItem second) {
  final sources = [...first.sources, ...second.sources]
    ..sort((a, b) => a.start.compareTo(b.start));
  final excerpt = sources.map((s) => s.excerpt).join(' ');
  final bodyEdited =
      first.edited.contains('body') || second.edited.contains('body');
  final conflicting =
      first.groupId != second.groupId || first.kind != second.kind;
  return first.copyWith(
    sources: sources,
    body: bodyEdited ? '${first.body}\n${second.body}' : proposedBody(excerpt),
    title: first.edited.contains('title')
        ? first.title
        : proposedTitle(excerpt),
    due: () => first.due ?? second.due,
    reminder: () => first.reminder ?? second.reminder,
    flags: {
      ...first.flags,
      ...second.flags,
      if (conflicting) ReviewFlag.newPiece,
    }.difference({ReviewFlag.checkSplit}),
  );
}

/// Blocking problems that must be fixed before approval (template text).
List<String> approvalProblems(List<ProposalItem> items) => [
  for (final i in items.where((i) => i.included)) ...[
    if (i.groupId == null) '${i.title}: choose a group',
    if (i.title.trim().isEmpty) 'Add a title',
    if (i.flags.contains(ReviewFlag.chooseAmPm)) '${i.title}: choose AM or PM',
    if (i.flags.contains(ReviewFlag.clockChange) && i.reminder != null)
      '${i.title}: check the time (clock change)',
  ],
];
