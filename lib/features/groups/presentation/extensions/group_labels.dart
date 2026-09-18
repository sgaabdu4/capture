import 'package:capture/features/groups/domain/entities/group_problem.dart';
import 'package:capture/features/groups/domain/group_rules.dart';
import 'package:capture/l10n/app_localizations.dart';

extension GroupProblemLabel on GroupProblem {
  String label(AppLocalizations l10n) => switch (this) {
    .nameMissing => l10n.groupNameMissing,
    .nameTooLong => l10n.groupNameTooLong(maxGroupNameLength),
    .descriptionMissing => l10n.groupDescriptionMissing,
    .duplicateName => l10n.groupDuplicateName,
  };
}
