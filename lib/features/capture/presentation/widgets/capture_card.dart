import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/capture_colors.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/paper_card.dart';
import 'package:capture/core/widgets/atoms/status_dot.dart';
import 'package:capture/features/capture/domain/entities/capture_failure.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/presentation/extensions/capture_labels.dart';
import 'package:capture/features/capture/presentation/extensions/capture_status.dart';
import 'package:capture/features/capture/presentation/widgets/capture_actions.dart';
import 'package:flutter/material.dart';

/// One capture on the Recordings page: its true state, and the transcript
/// when expanded.
class CaptureCard extends StatelessWidget {
  const CaptureCard({
    required this.record,
    required this.nowUtc,
    required this.busy,
    required this.idle,
    required this.onRetry,
    required this.onReview,
    required this.onRetrySave,
    required this.onReviewAgain,
    required this.onDelete,
    super.key,
  });

  final CaptureRecord record;
  final DateTime nowUtc;

  /// The pipeline is working on this capture right now.
  final bool busy;

  /// The pipeline is free to start another step.
  final bool idle;
  final VoidCallback onRetry;
  final VoidCallback onReview;
  final VoidCallback onRetrySave;
  final VoidCallback onReviewAgain;
  final VoidCallback onDelete;

  Color _dotColor(BuildContext context) {
    final CaptureColors(:ok, :warn, :faint) = context.paper;
    return switch (record.status) {
      .saved => ok,
      .waitingReview || .notTranscribed || .notSorted => warn,
      .saveIncomplete || .transcriptionFailed || .needsAttention => context.colors.error,
      .notSaved => faint,
    };
  }

  @override
  Widget build(BuildContext context) {
    final BuildContext(:l10n, :textTheme, :colors) = context;
    final CaptureRecord(:capturedAtUtc, :duration, :failure, :transcript, :stage) = record;
    final meta = [
      capturedAtUtc.agoLabel(l10n, nowUtc),
      if (duration > Duration.zero) duration.clockLabel,
    ].join(l10n.detailSeparator);
    final note = switch (record) {
      CaptureRecord(failure: final CaptureFailure f) => f.label(l10n),
      CaptureRecord(stage: .saved, :final includedItems) => includedItems.summary(l10n),
      CaptureRecord() => null,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: PaperCard(
        padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.md, Spacing.md, Spacing.md),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          shape: const Border(),
          collapsedShape: const Border(),
          title: Row(
            spacing: Spacing.sm,
            children: [
              StatusDot(_dotColor(context)),
              Text(record.status.label(l10n), style: textTheme.bodyMedium),
              Text(meta, style: textTheme.labelMedium),
            ],
          ),
          subtitle: switch (note) {
            final String text => Text(
              text,
              style: textTheme.labelMedium?.copyWith(
                color: failure == null ? colors.onSurfaceVariant : colors.error,
              ),
            ),
            null => null,
          },
          trailing: CaptureActions(
            stage: stage,
            busy: busy,
            idle: idle,
            onRetry: onRetry,
            onReview: onReview,
            onRetrySave: onRetrySave,
            onReviewAgain: onReviewAgain,
            onDelete: onDelete,
          ),
          expandedCrossAxisAlignment: .start,
          childrenPadding: const EdgeInsets.only(bottom: Spacing.xs),
          children: [
            Text(switch (transcript) {
              final String t when t.isNotEmpty => t,
              _ => l10n.noTranscript,
            }, style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
