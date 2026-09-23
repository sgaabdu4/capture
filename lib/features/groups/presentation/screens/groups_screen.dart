import 'dart:async';

import 'package:capture/core/domain/values/required_text.dart';
import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/empty_note.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:capture/core/widgets/page_frame.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/groups/domain/group_rules.dart';
import 'package:capture/features/groups/domain/values/group_name.dart';
import 'package:capture/features/groups/presentation/notifiers/groups_notifier.dart';
import 'package:capture/features/groups/presentation/widgets/group_dialog.dart';
import 'package:capture/features/groups/presentation/widgets/group_list.dart';
import 'package:capture/features/library/presentation/extensions/entry_editing.dart';
import 'package:capture/features/library/presentation/notifiers/library_notifier.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Groups editor. Names and descriptions steer Jev's filing, so each group
/// explains what belongs in it. Groups are archived, never deleted, so
/// existing library relations stay valid.
class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({super.key});

  static const _dialogRoute = 'group-dialog';

  /// New group when [group] is null, else edits it.
  Future<void> _edit(BuildContext context, WidgetRef ref, Group? group) async {
    final groups = ref.read(groupsProvider).groups;
    final draft = await showDialog<GroupDraft>(
      context: context,
      routeSettings: const .new(name: _dialogRoute),
      builder: (dialogContext) => GroupDialog(
        groups: groups,
        editing: group,
        onSave: (draft) => Navigator.of(dialogContext).pop(draft),
        onCancel: () => Navigator.of(dialogContext).pop(),
      ),
    );
    if (draft == null || !context.mounted) return;
    final (:name, :description) = draft;
    switch (group) {
      case final Group g:
        await ref
            .read(groupsProvider.notifier)
            .update(g.copyWith(name: GroupName(name), description: optionalText(description)));
      case null:
        await ref.read(groupsProvider.notifier).create(draft);
    }
  }

  Future<void> _setArchived(WidgetRef ref, Group group, {required bool archived}) =>
      ref.read(groupsProvider.notifier).update(group.copyWith(archived: archived));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final connected = ref.watch(settingsProvider.select((s) => s.notionConnected));
    if (!connected) {
      return PageFrame(title: l10n.navGroups, children: [EmptyNote(l10n.groupsNeedNotion)]);
    }
    final active = ref.watch(groupsProvider.select((s) => s.active));
    final archived = ref.watch(groupsProvider.select((s) => s.archived));
    final busy = ref.watch(groupsProvider.select((s) => s.busy));
    final entries = ref.watch(libraryProvider.select((s) => s.entries));
    return PageFrame(
      title: l10n.navGroups,
      subtitle: l10n.groupsSubtitle,
      actions: [
        LinkButton(
          l10n.refresh,
          onPressed: busy ? null : () => unawaited(ref.read(groupsProvider.notifier).refresh()),
        ),
        const SizedBox(width: Spacing.xs),
        InkButton(
          l10n.addGroup,
          key: const ValueKey(AppWidgetKeys.addGroupButton),
          onPressed: busy ? null : () => unawaited(_edit(context, ref, null)),
        ),
      ],
      children: [
        GroupList(
          activeGroups: active,
          archivedGroups: archived,
          entries: entries,
          busy: busy,
          onEdit: (group) => unawaited(_edit(context, ref, group)),
          onOpenEntry: (entry) => unawaited(ref.editEntry(context, entry)),
          onArchive: (group) => unawaited(_setArchived(ref, group, archived: true)),
          onRestore: (group) => unawaited(_setArchived(ref, group, archived: false)),
        ),
      ],
    );
  }
}
