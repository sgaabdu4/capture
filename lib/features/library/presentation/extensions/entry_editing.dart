import 'dart:async';

import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/features/library/presentation/notifiers/library_notifier.dart';
import 'package:capture/features/library/presentation/notifiers/library_state.dart';
import 'package:capture/features/library/presentation/screens/entry_dialog_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Opens the editor for a saved note or task from any list.
extension EntryEditing on WidgetRef {
  static const _dialogRoute = 'entry-dialog';

  /// Only the originating visible screen presents a completed snapshot; true while it loads.
  bool watchEntryEditing(BuildContext context, {required String origin}) {
    listen(
      libraryProvider.select(
        (s) => (serial: s.bodyLoadSerial, loading: s.bodyLoading, origin: s.bodyOrigin),
      ),
      (_, next) {
        if (next.loading || next.origin != origin || !context.mounted) return;
        if (!context.isCurrentModalRoute || Navigator.of(context, rootNavigator: true).canPop()) {
          return;
        }
        final LibraryState(:bodyEntry, :bodyText, :bodyLoadSerial) = read(libraryProvider);
        if (bodyEntry case final entry?) {
          unawaited(_showEntry(context, entry, bodyText, bodyLoadSerial));
        }
      },
    );
    return watch(libraryProvider.select((s) => s.bodyOrigin == origin && s.bodyLoading));
  }

  Future<void> _showEntry(
    BuildContext context,
    LibraryEntry entry,
    String? body,
    int serial,
  ) async {
    final library = read(libraryProvider.notifier);
    final edit = await showDialog<EntryEdit>(
      context: context,
      routeSettings: const .new(name: _dialogRoute),
      builder: (_) => EntryDialogScreen(entry: entry, body: body),
    );
    if (!context.mounted) return;
    if (edit == null || !context.isCurrentModalRoute) return;
    if (read(libraryProvider).bodyLoadSerial != serial) return;
    switch (edit.action) {
      case .save:
        await library.update(edit.entry, body: edit.body);
      case .delete:
        await library.delete(edit.entry);
    }
  }
}
