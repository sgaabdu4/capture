import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/widgets/atoms/line_button.dart';
import 'package:capture/features/settings/presentation/widgets/step_header.dart';
import 'package:flutter/material.dart';

/// Microphone permission, with a button while macOS hasn't asked yet.
class MicSection extends StatelessWidget {
  const MicSection({required this.granted, required this.detail, super.key, this.onAllow});

  final bool granted;

  /// What the current permission means.
  final String detail;

  /// Shown as "Allow microphone" while macOS hasn't asked; null hides it.
  final VoidCallback? onAllow;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .start,
      children: [
        StepHeader(done: granted, title: l10n.micTitle, detail: detail),
        if (onAllow case final VoidCallback allow)
          Padding(
            padding: StepHeader.bodyInset,
            child: LineButton(
              l10n.micAllow,
              key: const ValueKey(AppWidgetKeys.micAllowButton),
              onPressed: allow,
            ),
          ),
      ],
    );
  }
}
