import 'dart:async';

import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/features/groups/presentation/notifiers/groups_notifier.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/features/library/presentation/notifiers/library_notifier.dart';
import 'package:capture/features/library/presentation/screens/entry_dialog_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Opens the editor for a saved note or task from any list.
extension EntryEditing on WidgetRef {
  static const _dialogRoute = 'entry-dialog';

  Future<void> editEntry(LibraryEntry entry, {required String origin}) =>
      read(libraryProvider.notifier).body(entry, origin: origin);

  /// Only the originating visible screen presents a completed immutable snapshot.
  void listenForEntryEditing(BuildContext context, {required String origin}) {
    listen(
      libraryProvider.select(
        (s) => (serial: s.bodyLoadSerial, loading: s.bodyLoading, origin: s.bodyOrigin),
      ),
      (_, next) {
        if (next.loading || next.origin != origin || !context.mounted) return;
        if (!context.isCurrentModalRoute || Navigator.of(context, rootNavigator: true).canPop()) {
          return;
        }
        final prepared = read(libraryProvider);
        if (prepared.bodyEntry case final entry?) {
          unawaited(_showEntry(context, entry, prepared.bodyText, prepared.bodyLoadSerial));
        }
      },
    );
  }

  Future<void> _showEntry(
    BuildContext context,
    LibraryEntry entry,
    String? body,
    int serial,
  ) async {
    final library = read(libraryProvider.notifier);
    final groups = read(groupsProvider).active;
    final today = read(systemDatasourceProvider).nowUtc().toLocal();
    final edit = await showDialog<EntryEdit>(
      context: context,
      routeSettings: const .new(name: _dialogRoute),
      builder: (_) => EntryDialogScreen(entry: entry, groups: groups, today: today, body: body),
    );
    if (edit == null || !context.mounted || !context.isCurrentModalRoute) return;
    if (read(libraryProvider).bodyLoadSerial != serial) return;
    switch (edit.action) {
      case .save:
        await library.update(edit.entry, body: edit.body);
      case .delete:
        await library.delete(edit.entry);
    }
  }
}
