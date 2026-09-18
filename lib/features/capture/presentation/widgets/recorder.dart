import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/capture/presentation/widgets/mic_button.dart';
import 'package:flutter/material.dart';

/// Mic button, what it will do, the shortcut hint and the latest flow line.
class Recorder extends StatelessWidget {
  const Recorder({
    required this.recording,
    required this.phaseLabel,
    required this.shortcutLabel,
    required this.onPressed,
    super.key,
    this.message,
  });

  final bool recording;
  final String phaseLabel;
  final String shortcutLabel;

  /// Null disables the mic.
  final VoidCallback? onPressed;

  /// Notice or failure from the last capture step.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    return Column(
      children: [
        MicButton(recording: recording, onPressed: onPressed),
        const SizedBox(height: Spacing.lg),
        Text(phaseLabel, style: textTheme.bodyLarge),
        const SizedBox(height: Spacing.xxs),
        Text(l10n.recordShortcutHint(shortcutLabel), style: textTheme.labelMedium),
        if (message case final String line) ...[
          const SizedBox(height: Spacing.sm),
          Text(line, style: textTheme.labelMedium, textAlign: .center),
        ],
      ],
    );
  }
}
