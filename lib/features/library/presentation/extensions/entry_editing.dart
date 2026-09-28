import 'dart:async';

import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/features/groups/presentation/notifiers/groups_notifier.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/features/library/presentation/notifiers/library_notifier.dart';
import 'package:capture/features/library/presentation/screens/entry_dialog_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Opens the editor for a saved note or task from any list.
extension EntryEditing on WidgetRef {
  static const _dialogRoute = 'entry-dialog';

  Future<void> editEntry(BuildContext context, LibraryEntry entry) {
    final library = read(libraryProvider.notifier);
    return showDialog<void>(
      context: context,
      routeSettings: const .new(name: _dialogRoute),
      builder: (dialogContext) => EntryDialogScreen(
        entry: entry,
        groups: read(groupsProvider).active,
        today: read(systemDatasourceProvider).nowUtc().toLocal(),
        body: library.body(entry),
        onSave: (edit) => _close(dialogContext, library.update(edit.entry, body: edit.body)),
        onDelete: () => _close(dialogContext, library.delete(entry)),
        onCancel: () => Navigator.of(dialogContext).pop(),
      ),
    );
  }

  /// Close while the Notion change runs; failures surface through the library notice.
  void _close(BuildContext dialogContext, Future<void> change) {
    Navigator.of(dialogContext).pop();
    unawaited(change);
  }
}
