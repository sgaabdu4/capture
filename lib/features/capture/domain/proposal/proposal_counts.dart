import 'package:capture/features/capture/domain/entities/proposal_item.dart';

/// What the review card counts, e.g. `2 notes · 1 task · 1 reminder`.
typedef ProposalCounts = ({int notes, int tasks, int reminders});

ProposalCounts countProposal(Iterable<ProposalItem> items) {
  final included = items.where((i) => i.included).toList();
  final tasks = included.where((i) => i.isTask).toList();
  return (
    notes: included.length - tasks.length,
    tasks: tasks.length,
    reminders: tasks.where((i) => i.reminder != null).length,
  );
}
