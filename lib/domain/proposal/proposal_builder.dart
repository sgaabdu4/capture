import 'package:timezone/timezone.dart' as tz;

import '../dates/date_resolver.dart';
import '../jev/classification_pass.dart';
import '../jev/thresholds.dart';
import '../models.dart';
import '../text/assembly.dart';
import '../text/titles.dart';

/// Builds the application-owned proposal from thoughts + Jev decisions.
/// Titles and bodies are copied from source text; dates are computed by code.
List<ProposalItem> buildProposal({
  required List<Thought> thoughts,
  required Map<String, ThoughtDecision> decisions,
  required ClassificationPlan plan,
  required List<Group> groups,
  required DateTime capturedAtUtc,
  required tz.Location location,
  required String Function() newId,
}) => [
  for (final t in thoughts)
    _item(t, decisions[t.id]!, plan, groups, capturedAtUtc, location, newId()),
];

ProposalItem _item(
  Thought thought,
  ThoughtDecision d,
  ClassificationPlan plan,
  List<Group> groups,
  DateTime capturedAtUtc,
  tz.Location location,
  String id,
) {
  final flags = <ReviewFlag>{
    if (thought.uncertainStart) ReviewFlag.checkSplit,
    if (d.groupConfidence < minGroupConfidence) ReviewFlag.checkGroup,
    if (taskBand.uncertain(d.task)) ReviewFlag.checkTask,
    if (correctionBand.yes(d.correction)) ReviewFlag.correctionElsewhere,
  };
  final recall = retrievalBand.yes(d.recall);
  if (recall) flags.add(ReviewFlag.recallUnsupported);
  final wantsAlert = alertBand.yes(d.alert) && !recall;
  final isTask = (taskBand.yes(d.task) || wantsAlert) && !recall;
  if (isTask && alertBand.uncertain(d.alert)) {
    flags.add(ReviewFlag.checkReminder);
  }

  final groupId = _groupId(plan, d.groupOption, groups);
  final unsorted = d.groupOption.toLowerCase() == unsortedName.toLowerCase();
  if (groupId == null || unsorted) flags.add(ReviewFlag.checkGroup);

  final dates = isTask
      ? _dates(d, capturedAtUtc, location, wantsAlert, flags)
      : (due: null, reminder: null);
  final found = plan.candidates[thought.id];
  return ProposalItem(
    id: id,
    sources: [thought.span],
    kind: isTask ? ItemKind.task : ItemKind.note,
    groupId: groupId,
    title: proposedTitle(
      thought.span.excerpt,
      remove: [
        if (isTask && found != null)
          for (final c in [...found.days, ...found.times])
            (
              c.span.start - thought.span.start,
              c.span.end - thought.span.start,
            ),
      ],
    ),
    body: proposedBody(thought.span.excerpt),
    due: dates.due,
    reminder: dates.reminder,
    flags: flags,
    included: !recall,
  );
}

String? _groupId(ClassificationPlan plan, String option, List<Group> groups) =>
    plan.groupOptions[option] ??
    groups.where((g) => g.isUnsorted && !g.archived).firstOrNull?.id;

({DueDate? due, DueDate? reminder}) _dates(
  ThoughtDecision d,
  DateTime capturedAtUtc,
  tz.Location location,
  bool wantsAlert,
  Set<ReviewFlag> flags,
) {
  final resolved = resolveDate(
    capturedAtUtc: capturedAtUtc,
    location: location,
    day: d.day,
    time: d.time,
  );
  final lowConfidence =
      (d.day != null && d.dayConfidence < minDateConfidence) ||
      (d.time != null && d.timeConfidence < minDateConfidence);
  if (lowConfidence) flags.add(ReviewFlag.checkDate);
  flags.addAll(resolved.flags);
  final date = resolved.date;
  if (!wantsAlert) return (due: date, reminder: null);
  if (date == null || !date.hasTime) {
    if (resolved.ambiguousHour == null) flags.add(ReviewFlag.chooseTime);
    return (due: date, reminder: null);
  }
  return (due: date, reminder: date);
}

/// Fallback proposal when classification is unavailable (service failure or
/// invalid key): one editable Unsorted note holding the whole transcript.
ProposalItem manualProposal(Thought whole, List<Group> groups, String id) =>
    ProposalItem(
      id: id,
      sources: [whole.span],
      kind: ItemKind.note,
      groupId: groups.where((g) => g.isUnsorted && !g.archived).firstOrNull?.id,
      title: proposedTitle(whole.span.excerpt),
      body: proposedBody(whole.span.excerpt),
      flags: const {ReviewFlag.classificationFailed},
    );
