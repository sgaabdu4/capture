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

enum EntryEditAction { save, delete }

/// A dismissed editor's intent; null body leaves the page details unchanged.
typedef EntryEdit = ({EntryEditAction action, LibraryEntry entry, String? body});

class EntryDialogScreen extends StatefulWidget {
  const EntryDialogScreen({
    required this.entry,
    required this.groups,
    required this.today,
    required this.body,
    super.key,
  });

  final LibraryEntry entry;
  final List<Group> groups;

  /// Wall-clock now on this Mac.
  final DateTime today;

  /// The details on the Notion page; null when they could not be read.
  final String? body;

  @override
  State<EntryDialogScreen> createState() => _EntryDialogScreenState();
}

class _EntryDialogScreenState extends State<EntryDialogScreen> {
  static const _bodyMinLines = 3;
  static const _bodyMaxLines = 8;

  final _title = TextEditingController();
  final _body = TextEditingController();
  late LibraryEntry _entry = widget.entry;

  bool _confirmDelete = false;
  bool _titleEmpty = false;

  @override
  void initState() {
    super.initState();
    final title = widget.entry.title;
    if (title == null) {
      _title.clear();
    } else {
      _title.text = title;
    }
    _titleEmpty = title == null;
    final body = widget.body;
    if (body == null) {
      _body.clear();
    } else {
      _body.text = body;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  void _edit(LibraryEntry next) => setState(() => _entry = next);

  /// An existing reminder follows the changed date only when the new date has a time.
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
    Navigator.of(context).pop<EntryEdit>((
      action: .save,
      entry: _entry.copyWith(title: _title.text.trim()),
      body: widget.body != null && body != widget.body ? body : null,
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
              enabled: widget.body != null,
              minLines: _bodyMinLines,
              maxLines: _bodyMaxLines,
              decoration: .new(
                labelText: l10n.detailsHint,
                helperText: widget.body == null ? l10n.entryBodyUnavailable : null,
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
              onDelete: () =>
                  Navigator.of(context)
                      .pop<EntryEdit>((action: .delete, entry: widget.entry, body: null)),
              onCancel: () => Navigator.of(context).pop(),
              onSave: _titleEmpty ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}
