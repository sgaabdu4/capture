import 'package:capture/core/extensions/date_format.dart';
import 'package:capture/core/services/models/review_card_payload.dart';
import 'package:capture/core/services/models/review_card_row.dart';
import 'package:capture/features/capture/domain/entities/approval_problem.dart';
import 'package:capture/features/capture/domain/entities/capture_failure.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/capture/domain/entities/proposal_item.dart';
import 'package:capture/features/capture/presentation/extensions/capture_labels.dart';
import 'package:capture/features/groups/presentation/notifiers/groups_state.dart';
import 'package:capture/l10n/app_localizations.dart';
import 'package:timezone/timezone.dart' as tz;

/// SF Symbols shown on the native review card.
const _noteSymbol = 'doc.text';
const _datedSymbol = 'calendar';
const _taskSymbol = 'checkmark.square';

extension ReviewCardContent on CaptureRecord {
  /// The localized review card for this proposal.
  ReviewCardPayload reviewCard(AppLocalizations l10n, GroupsState groups) {
    final included = includedItems;
    final problem = included.expand((i) => i.approvalProblems).firstOrNull;
    final today = tz.TZDateTime.from(capturedAtUtc, tz.getLocation(timeZone.value));
    return .new(
      countLine: included.isEmpty ? l10n.reviewNothing : included.summary(l10n),
      rows: [for (final item in included) _row(item, l10n, groups, today)],
      canApprove: included.isNotEmpty && problem == null,
      blockedReason: switch ((failure: failure, problem: problem)) {
        (failure: final CaptureFailure f, problem: _) => f.label(l10n),
        (failure: null, problem: final ApprovalProblem p) => l10n.reviewNeedsLook(p.label(l10n)),
        (failure: null, problem: null) => null,
      },
    );
  }

  ReviewCardRow _row(ProposalItem item, AppLocalizations l10n, GroupsState groups, DateTime today) {
    final ProposalItem(:id, :kind, :title, :groupId, :flags, :reminder, :due) = item;
    final when = reminder ?? due;
    final detail = [
      kind.label(l10n),
      ?groups.byId(groupId)?.name.value,
      ?when?.label(l10n, today),
      ?flags.firstOrNull?.label(l10n),
    ].join(l10n.detailSeparator);
    final icon = switch ((kind: kind, when: when)) {
      (kind: .note, when: _) => _noteSymbol,
      (kind: .task, when: DueDate()) => _datedSymbol,
      (kind: .task, when: null) => _taskSymbol,
    };
    return .new(id: id.value, icon: icon, title: title ?? '', detail: detail);
  }
}
