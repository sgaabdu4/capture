import 'dart:async';

import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/capture/presentation/extensions/when_pickers.dart';
import 'package:capture/features/capture/presentation/widgets/group_menu.dart';
import 'package:capture/features/capture/presentation/widgets/when_row.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/features/library/presentation/widgets/entry_dialog_actions.dart';
import 'package:flutter/material.dart';

/// An edited entry and its new body, or null when the body is unchanged.
typedef EntryEdit = ({LibraryEntry entry, String? body});

/// Edits one saved note or task: title, details, group and, for a task, its
/// date and reminder. Delete asks once more before calling [onDelete].
class EntryDialog extends StatefulWidget {
  const EntryDialog({
    required this.entry,
    required this.groups,
    required this.today,
    required this.body,
    required this.onSave,
    required this.onDelete,
    required this.onCancel,
    super.key,
  });

  final LibraryEntry entry;
  final List<Group> groups;

  /// Wall-clock now on this Mac.
  final DateTime today;

  /// The details on the Notion page; null when they could not be read.
  final Future<String?> body;
  final ValueChanged<EntryEdit> onSave;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  @override
  State<EntryDialog> createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {
  static const _bodyMinLines = 3;
  static const _bodyMaxLines = 8;

  final _title = TextEditingController();
  final _body = TextEditingController();
  late LibraryEntry _entry = widget.entry;

  /// The details as loaded; null while loading or when Notion failed.
  String? _loadedBody;
  bool _loading = true;
  bool _confirmDelete = false;
  bool _titleEmpty = false;

  @override
  void initState() {
    super.initState();
    _title.text = widget.entry.title ?? '';
    _titleEmpty = widget.entry.title == null;
    unawaited(_loadBody());
  }

  Future<void> _loadBody() async {
    final context = this.context;
    final body = await widget.body;
    if (!context.mounted) return;
    setState(() {
      _loading = false;
      _loadedBody = body;
      _body.text = body ?? '';
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  void _edit(LibraryEntry next) => setState(() => _entry = next);

  /// Moves the date to [date]; an existing reminder follows when [date] has
  /// a time.
  void _setWhen(DueDate date) => _edit(
    _entry.copyWith(due: date, reminder: _entry.reminder != null && date.hasTime ? date : null),
  );

  /// Reminds at the due date and time, or stops reminding.
  void _setReminder(bool on) {
    switch (_entry.due) {
      case final DueDate due when on && due.hasTime:
        _edit(_entry.copyWith(reminder: due));
      case _ when !on:
        _edit(_entry.copyWith(reminder: null));
      case _:
    }
  }

  Future<void> _pickDate() =>
      context.pickDay(_entry.due ?? _entry.reminder, widget.today, _setWhen);

  Future<void> _pickTime() async {
    if (_entry.due ?? _entry.reminder case final DueDate base) {
      await context.pickTime(base, _setWhen);
    }
  }

  void _save() {
    final body = _body.text.trim();
    widget.onSave((
      entry: _entry.copyWith(title: _title.text.trim()),
      body: _loadedBody != null && body != _loadedBody ? body : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final LibraryEntry(:kind, :groupId, :due, :reminder) = _entry;
    return AlertDialog(
      scrollable: true,
      insetPadding: context.compact ? const .all(Spacing.md) : null,
      title: Text(
        kind == .task ? l10n.editTask : l10n.editNote,
        style: context.textTheme.titleMedium,
      ),
      content: SizedBox(
        width: Sizes.dialogWidth,
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          spacing: Spacing.sm,
          children: [
            TextField(
              key: const ValueKey(AppWidgetKeys.entryTitleField),
              controller: _title,
              onChanged: (title) => setState(() => _titleEmpty = title.trim().isEmpty),
              decoration: .new(labelText: l10n.titleHint),
            ),
            TextField(
              key: const ValueKey(AppWidgetKeys.entryBodyField),
              controller: _body,
              enabled: _loadedBody != null,
              minLines: _bodyMinLines,
              maxLines: _bodyMaxLines,
              decoration: .new(
                labelText: l10n.detailsHint,
                helperText: switch ((loading: _loading, body: _loadedBody)) {
                  (loading: true, body: _) => l10n.entryBodyLoading,
                  (loading: false, body: null) => l10n.entryBodyUnavailable,
                  _ => null,
                },
              ),
            ),
            GroupMenu(
              groups: widget.groups,
              value: groupId,
              onChanged: (id) => _edit(_entry.copyWith(groupId: id)),
            ),
            if (kind == .task)
              WhenRow(
                due: due ?? reminder,
                hasReminder: reminder != null,
                today: widget.today,
                enabled: true,
                onPickDate: () => unawaited(_pickDate()),
                onPickTime: () => unawaited(_pickTime()),
                onClear: () => _edit(_entry.copyWith(due: null, reminder: null)),
                onReminder: _setReminder,
              ),
            EntryDialogActions(
              confirmingDelete: _confirmDelete,
              onAskDelete: () => setState(() => _confirmDelete = true),
              onDelete: widget.onDelete,
              onCancel: widget.onCancel,
              onSave: _titleEmpty || _loading ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}
