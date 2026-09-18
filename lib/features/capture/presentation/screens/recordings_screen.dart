import 'dart:async';

import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/router/app_routes.dart';
import 'package:capture/core/widgets/atoms/empty_note.dart';
import 'package:capture/core/widgets/page_frame.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_flow_notifier.dart';
import 'package:capture/features/capture/presentation/widgets/capture_card.dart';
import 'package:capture/features/capture/presentation/widgets/delete_capture_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Every capture, newest first, with its true state and the one action that
/// moves it on.
class RecordingsScreen extends ConsumerWidget {
  const RecordingsScreen({super.key});

  static const _deleteDialogRoute = 'delete-capture-dialog';

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, CaptureRecord record) async {
    final saved = record.stage == .saved;
    final confirmed = await showDialog<bool>(
      context: context,
      routeSettings: const .new(name: _deleteDialogRoute),
      builder: (dialogContext) => DeleteCaptureDialog(
        saved: saved,
        onCancel: () => Navigator.of(dialogContext).pop(false),
        onDelete: () => Navigator.of(dialogContext).pop(true),
      ),
    );
    if (confirmed != true || !context.mounted) return;
    _delete(ref, record.id);
  }

  void _delete(WidgetRef ref, String id) =>
      unawaited(ref.read(captureFlowProvider.notifier).delete(id));

  void _reviewAgain(BuildContext context, WidgetRef ref, String id) {
    ref.read(captureFlowProvider.notifier).reopen(id);
    EditorRoute(id: id).go(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final captures = ref.watch(captureFlowProvider.select((s) => s.captures));
    final phase = ref.watch(captureFlowProvider.select((s) => s.phase));
    final activeId = ref.watch(captureFlowProvider.select((s) => s.activeId));
    final nowUtc = ref.watch(systemDatasourceProvider.select((s) => s.nowUtc()));
    return PageFrame(
      title: l10n.navRecordings,
      subtitle: l10n.recordingsSubtitle,
      children: [
        if (captures.isEmpty) EmptyNote(l10n.emptyCaptures),
        for (final record in captures)
          CaptureCard(
            key: ValueKey(record.id),
            record: record,
            nowUtc: nowUtc,
            busy: activeId == record.id && phase != .idle,
            idle: phase == .idle,
            onRetry: () => unawaited(ref.read(captureFlowProvider.notifier).process(record.id)),
            onReview: () => EditorRoute(id: record.id).go(context),
            onRetrySave: () => unawaited(ref.read(captureFlowProvider.notifier).approve(record.id)),
            onReviewAgain: () => _reviewAgain(context, ref, record.id),
            onDelete: () => unawaited(_confirmDelete(context, ref, record)),
          ),
      ],
    );
  }
}
