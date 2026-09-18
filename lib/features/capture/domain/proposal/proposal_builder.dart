import 'package:capture/features/capture/domain/dates/date_resolver.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/capture/domain/entities/proposal_item.dart';
import 'package:capture/features/capture/domain/entities/review_flag.dart';
import 'package:capture/features/capture/domain/jev/classification_pass.dart';
import 'package:capture/features/capture/domain/jev/thresholds.dart';
import 'package:capture/features/capture/domain/text/thought.dart';
import 'package:capture/features/capture/domain/text/titles.dart';
import 'package:capture/features/groups/domain/entities/group.dart';

/// Due date, reminder and the review flags their resolution raised.
typedef _Dates = ({DueDate? due, DueDate? reminder, Set<ReviewFlag> flags});

const _Dates _noDates = (due: null, reminder: null, flags: {});

/// Builds the application-owned proposal from Jev decisions (one per
/// thought, in order). Titles and bodies are copied from source text; dates
/// are computed by code.
List<ProposalItem> buildProposal({
  required List<ThoughtDecision> decisions,
  required ClassificationPlan plan,
  required CaptureMoment moment,
  required String Function() newId,
}) => [for (final d in decisions) _item(d, plan, moment, newId())];

ProposalItem _item(ThoughtDecision d, ClassificationPlan plan, CaptureMoment moment, String id) {
  final ThoughtDecision(:thought, :groupOption, :groupConfidence, :task, :alert, :recall) = d;
  final Thought(:span, :uncertainStart, :lateCorrection) = thought;
  final asksRecall = retrievalBand.yes(recall);
  final wantsAlert = alertBand.yes(alert) && !asksRecall;
  final isTask = (taskBand.yes(task) || wantsAlert) && !asksRecall;
  final judged = <ReviewFlag>{
    if (uncertainStart) ReviewFlag.checkSplit,
    if (groupConfidence < minGroupConfidence) ReviewFlag.checkGroup,
    if (taskBand.uncertain(task)) ReviewFlag.checkTask,
    if (lateCorrection) ReviewFlag.correctionElsewhere,
    if (asksRecall) ReviewFlag.recallUnsupported,
    if (isTask && alertBand.uncertain(alert)) ReviewFlag.checkReminder,
  };
  final groupId = _groupId(plan, groupOption);
  final unsorted = groupOption.toLowerCase() == Group.unsortedName.toLowerCase();
  final dates = isTask ? _dates(d, moment, wantsAlert: wantsAlert) : _noDates;
  return .new(
    id: id,
    sources: [span],
    kind: isTask ? .task : .note,
    groupId: groupId,
    title: proposedTitle(span.excerpt, remove: isTask ? _datePhrases(plan, thought) : const []),
    body: proposedBody(span.excerpt),
    due: dates.due,
    reminder: dates.reminder,
    flags: {...judged, if (groupId == null || unsorted) ReviewFlag.checkGroup, ...dates.flags},
    included: !asksRecall,
  );
}

/// Date/time phrases of [thought], relative to its excerpt, left out of a
/// task's title.
List<ExcerptRange> _datePhrases(ClassificationPlan plan, Thought thought) {
  final found = plan.candidates[thought.id];
  if (found == null) return const [];
  final start = thought.span.start;
  return [
    for (final c in [...found.days, ...found.times])
      (start: c.span.start - start, end: c.span.end - start),
  ];
}

String? _groupId(ClassificationPlan plan, String option) => switch (plan.groupOptions[option]) {
  final String id => id,
  null => plan.unsortedGroupId,
};

_Dates _dates(ThoughtDecision d, CaptureMoment moment, {required bool wantsAlert}) {
  final ThoughtDecision(:day, :time, :dayConfidence, :timeConfidence) = d;
  final ResolvedDate(:date, :flags, :ambiguousHour) = resolveDate(moment, day: day, time: time);
  final lowConfidence =
      (day != null && dayConfidence < minDateConfidence) ||
      (time != null && timeConfidence < minDateConfidence);
  final timed = date != null && date.hasTime;
  return (
    due: date,
    reminder: wantsAlert && timed ? date : null,
    flags: {
      if (lowConfidence) ReviewFlag.checkDate,
      ...flags,
      if (wantsAlert && !timed && ambiguousHour == null) ReviewFlag.chooseTime,
    },
  );
}

/// Fallback proposal when classification is unavailable (service failure or
/// invalid key): one editable Unsorted note holding the whole transcript.
ProposalItem manualProposal(Thought whole, List<Group> groups, String id) => .new(
  id: id,
  sources: [whole.span],
  kind: .note,
  groupId: groups.where((g) => g.isUnsorted && !g.archived).firstOrNull?.id,
  title: proposedTitle(whole.span.excerpt),
  body: proposedBody(whole.span.excerpt),
  flags: const {.classificationFailed},
);
