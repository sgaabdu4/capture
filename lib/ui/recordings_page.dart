import 'package:capture/app/app_model.dart';
import 'package:capture/app/capture_flow.dart';
import 'package:capture/features/capture/domain/entities/capture.dart';
import 'package:capture/core/extensions/date_format.dart';
import 'package:capture/ui/theme.dart';
import 'package:capture/ui/widgets.dart';
import 'package:flutter/material.dart';

/// Every capture with its true state and the one action that moves it on.
class RecordingsPage extends StatelessWidget {
  const RecordingsPage({required this.model, super.key});
  final AppModel model;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model.flow,
    builder: (context, _) {
      final captures = model.flow.captures;
      return PageFrame(
        title: 'Recordings',
        subtitle: 'Kept on this Mac. Saved captures are also in Notion.',
        children: [
          if (captures.isEmpty) const EmptyNote('No captures yet.'),
          for (final r in captures) _CaptureCard(model: model, record: r),
        ],
      );
    },
  );
}

class _CaptureCard extends StatelessWidget {
  const _CaptureCard({required this.model, required this.record});
  final AppModel model;
  final CaptureRecord record;

  (String, Color) get _status => switch (record.stage) {
    CaptureStage.saved => ('Saved to Notion', Palette.ok),
    CaptureStage.proposed => ('Waiting for your review', Palette.warn),
    CaptureStage.approved => ('Save incomplete', Palette.error),
    CaptureStage.dismissed => ('Not saved', Palette.faint),
    CaptureStage.recorded =>
      record.error == null
          ? ('Not transcribed yet', Palette.warn)
          : ('Transcription failed', Palette.error),
    CaptureStage.transcribed =>
      record.error == null ? ('Not sorted yet', Palette.warn) : ('Sorting failed', Palette.error),
  };

  bool get _busy => model.flow.activeId == record.id && model.flow.phase != Phase.idle;

  @override
  Widget build(BuildContext context) {
    final (status, color) = _status;
    final now = model.env.now();
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: PaperCard(
        padding: const EdgeInsets.fromLTRB(24, 18, 20, 18),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            shape: const Border(),
            title: Row(
              children: [
                StatusDot(color),
                const SizedBox(width: 12),
                Text(status, style: Styles.body),
                const SizedBox(width: 12),
                Text(
                  '${formatAgo(record.capturedAtUtc.toLocal(), now)} · '
                  '${formatDuration(record.durationSeconds)}',
                  style: Styles.label,
                ),
              ],
            ),
            subtitle: Text(
              record.error ?? (record.stage == CaptureStage.saved ? latestLine(record) : ''),
              style: Styles.label.copyWith(
                color: record.error == null ? Palette.muted : Palette.error,
              ),
            ),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: _actions(context)),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                record.transcript?.isNotEmpty ?? false ? record.transcript! : 'No transcript yet.',
                style: Styles.body.copyWith(color: Palette.muted),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _actions(BuildContext context) {
    if (_busy) {
      return const [
        SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
      ];
    }
    final flow = model.flow;
    final idle = flow.phase == Phase.idle;
    return [
      switch (record.stage) {
        CaptureStage.recorded || CaptureStage.transcribed => LinkButton(
          'Retry',
          onPressed: idle ? () => flow.process(record.id) : null,
        ),
        CaptureStage.proposed => LinkButton('Review', onPressed: () => model.openEditor(record.id)),
        CaptureStage.approved => LinkButton(
          'Retry save',
          onPressed: idle ? () => flow.approve(record.id) : null,
        ),
        CaptureStage.dismissed => LinkButton('Review again', onPressed: () => _reopen()),
        CaptureStage.saved => const SizedBox.shrink(),
      },
      if (record.stage != CaptureStage.approved)
        IconButton(
          tooltip: 'Delete from this Mac',
          icon: const Icon(Icons.delete_outline, size: 20),
          onPressed: () => _confirmDelete(context),
        ),
    ];
  }

  void _reopen() {
    model.flow.reopen(record.id);
    model.openEditor(record.id);
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this recording?', style: Styles.cardTitle),
        content: Text(
          record.stage == CaptureStage.saved
              ? 'The audio and transcript are removed from this Mac. The copy in Notion stays.'
              : 'The audio and transcript are removed from this Mac. This can’t be undone.',
          style: Styles.body,
        ),
        actions: [
          LinkButton('Cancel', onPressed: () => Navigator.of(context).pop(false)),
          InkButton('Delete', onPressed: () => Navigator.of(context).pop(true)),
        ],
      ),
    );
    if (ok ?? false) await model.flow.deleteCapture(record.id);
  }
}
