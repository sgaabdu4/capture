import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/radii.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/features/settings/domain/values/speech_model_event.dart';
import 'package:capture/features/settings/presentation/extensions/settings_labels.dart';
import 'package:capture/features/settings/presentation/widgets/step_header.dart';
import 'package:flutter/material.dart';

/// Download, progress, failure and ready states of the local speech model.
class ModelStep extends StatelessWidget {
  const ModelStep({
    required this.ready,
    required this.download,
    required this.totalBytes,
    required this.onDownload,
    super.key,
  });

  final bool ready;

  /// Latest download event; null before a download starts.
  final SpeechModelEvent? download;

  /// Size of the whole model, for the "Download (N MB)" line.
  final int totalBytes;
  final VoidCallback onDownload;

  static const _bytesPerMegabyte = 1000000;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final event = download;
    final status = switch (event) {
      SpeechModelProgress(total: 0) => (value: 0.0, text: l10n.modelStarting),
      SpeechModelProgress(:final received, :final total) => (
        value: received / total,
        text: l10n.modelProgress(received ~/ _bytesPerMegabyte, total ~/ _bytesPerMegabyte),
      ),
      SpeechModelVerifying(:final file) => (value: null, text: l10n.modelVerifying(file)),
      _ => null,
    };
    final failure = switch (event) {
      SpeechModelFailed(:final reason) => reason.label(l10n),
      _ => null,
    };
    return Column(
      crossAxisAlignment: .start,
      children: [
        StepHeader(
          done: ready,
          title: l10n.modelTitle,
          detail: ready ? l10n.modelReady : l10n.modelNeeded(totalBytes ~/ _bytesPerMegabyte),
        ),
        Padding(
          padding: StepHeader.bodyInset,
          child: Column(
            crossAxisAlignment: .start,
            spacing: Spacing.xs,
            children: [
              if (status case (:final value, :final text)) ...[
                LinearProgressIndicator(value: value, borderRadius: Radii.rounded4),
                Text(text, style: textTheme.labelMedium),
              ],
              if (status == null && !ready)
                InkButton(
                  failure == null ? l10n.modelDownload : l10n.modelRetry,
                  key: const ValueKey(AppWidgetKeys.modelDownloadButton),
                  onPressed: onDownload,
                ),
              if (failure case final String message)
                Text(message, style: textTheme.labelMedium?.copyWith(color: context.colors.error)),
              Text(l10n.modelAttribution, style: textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
