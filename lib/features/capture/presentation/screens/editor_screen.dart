import 'dart:async';

import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/router/app_routes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/empty_note.dart';
import 'package:capture/core/widgets/page_frame.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/capture/domain/entities/proposal_item.dart';
import 'package:capture/features/capture/presentation/extensions/capture_labels.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_flow_notifier.dart';
import 'package:capture/features/capture/presentation/widgets/editor_bottom_bar.dart';
import 'package:capture/features/capture/presentation/widgets/proposal_item_editor.dart';
import 'package:capture/features/capture/presentation/widgets/transcript_panel.dart';
import 'package:capture/features/groups/presentation/notifiers/groups_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

/// Focused editor for one proposal. Edits are stored locally as you go;
/// nothing reaches Notion until "Save to Notion".
class EditorScreen extends ConsumerWidget {
  const EditorScreen({required this.captureId, super.key});

  final String captureId;

  static const _datePickerRoute = 'editor-date-picker';
  static const _timePickerRoute = 'editor-time-picker';
  static const _pickerPastYears = 1;
  static const _pickerFutureYears = 5;
  static const _defaultHour = 9;
  static const _defaultMinute = 0;

  Future<void> _pickDate(
    BuildContext context,
    WidgetRef ref,
    ProposalItem item,
    DateTime today,
  ) async {
    final base = item.due ?? item.reminder;
    final picked = await showDatePicker(
      context: context,
      routeSettings: const .new(name: _datePickerRoute),
      initialDate: switch (base) {
        DueDate(:final year, :final month, :final day) => .new(year, month, day),
        null => today,
      },
      firstDate: .new(today.year - _pickerPastYears),
      lastDate: .new(today.year + _pickerFutureYears),
    );
    if (picked == null || !context.mounted) return;
    final DateTime(:year, :month, :day) = picked;
    ref
        .read(captureFlowProvider.notifier)
        .setWhen(captureId, item, .new(year, month, day, hour: base?.hour, minute: base?.minute));
  }

  Future<void> _pickTime(BuildContext context, WidgetRef ref, ProposalItem item) async {
    final base = item.due ?? item.reminder;
    if (base == null) return;
    final picked = await showTimePicker(
      context: context,
      routeSettings: const .new(name: _timePickerRoute),
      initialTime: switch (base) {
        DueDate(hour: final int hour, minute: final int minute) => .new(hour: hour, minute: minute),
        DueDate(hour: final int hour) => .new(hour: hour, minute: _defaultMinute),
        DueDate() => const .new(hour: _defaultHour, minute: _defaultMinute),
      },
    );
    if (picked == null || !context.mounted) return;
    ref
        .read(captureFlowProvider.notifier)
        .setWhen(captureId, item, base.withTime(picked.hour, picked.minute));
  }

  void _dontSave(BuildContext context, WidgetRef ref) {
    ref.read(captureFlowProvider.notifier).dismiss(captureId);
    const RecordingsRoute().go(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(captureFlowProvider.select((s) => s.byId(captureId)?.stage), (previous, next) {
      if (previous != .saved && next == .saved) const RecordingsRoute().go(context);
    });
    final l10n = context.l10n;
    final record = ref.watch(captureFlowProvider.select((s) => s.byId(captureId)));
    if (record == null) {
      return PageFrame(title: l10n.reviewTitle, children: [EmptyNote(l10n.nothingToReview)]);
    }
    final phase = ref.watch(captureFlowProvider.select((s) => s.phase));
    final activeId = ref.watch(captureFlowProvider.select((s) => s.activeId));
    final groups = ref.watch(groupsProvider.select((s) => s.active));
    final CaptureRecord(:items, :includedItems, :stage, :failure, :transcript, :timeZone) = record;
    final today = tz.TZDateTime.from(
      ref.watch(systemDatasourceProvider.select((s) => s.nowUtc())),
      tz.getLocation(timeZone),
    );
    final editable = stage == .proposed;
    final problems = {for (final item in items) ...item.approvalProblems};
    final canSave =
        (editable || stage == .approved) &&
        includedItems.isNotEmpty &&
        problems.isEmpty &&
        (phase == .idle || phase == .review);
    final subtitle = [
      if (includedItems.isNotEmpty) includedItems.summary(l10n),
      ?failure?.label(l10n),
    ].join(l10n.detailSeparator);
    return Column(
      children: [
        Expanded(
          child: PageFrame(
            title: l10n.editorTitle,
            subtitle: subtitle.isEmpty ? null : subtitle,
            children: [
              for (final (index, item) in items.indexed)
                ProposalItemEditor(
                  key: ValueKey(item.id),
                  item: item,
                  groups: groups,
                  today: today,
                  editable: editable,
                  onChanged: (next) =>
                      ref.read(captureFlowProvider.notifier).editItem(captureId, next),
                  onPickDate: () => unawaited(_pickDate(context, ref, item, today)),
                  onPickTime: () => unawaited(_pickTime(context, ref, item)),
                  onClearWhen: () =>
                      ref.read(captureFlowProvider.notifier).clearWhen(captureId, item),
                  onReminder: (on) =>
                      ref.read(captureFlowProvider.notifier).setReminder(captureId, item, on: on),
                  onSplit: (at) =>
                      ref.read(captureFlowProvider.notifier).split(captureId, item, at),
                  onMergeNext: index + 1 < items.length
                      ? () => ref.read(captureFlowProvider.notifier).mergeWithNext(captureId, index)
                      : null,
                ),
              const SizedBox(height: Spacing.sm),
              TranscriptPanel(transcript: transcript),
            ],
          ),
        ),
        EditorBottomBar(
          stage: stage,
          problems: problems,
          failure: failure,
          saving: phase == .saving && activeId == captureId,
          onDontSave: () => _dontSave(context, ref),
          onSave: canSave
              ? () => unawaited(ref.read(captureFlowProvider.notifier).approve(captureId))
              : null,
        ),
      ],
    );
  }
}
