import 'package:capture/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

/// The whole transcript, collapsed until asked for.
class TranscriptPanel extends StatelessWidget {
  const TranscriptPanel({required this.transcript, super.key});

  final String? transcript;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      shape: const Border(),
      collapsedShape: const Border(),
      title: Text(l10n.fullTranscript, style: textTheme.labelMedium),
      expandedAlignment: Alignment.centerLeft,
      children: [
        Text(switch (transcript) {
          final String t when t.isNotEmpty => t,
          _ => l10n.noWordsHeard,
        }, style: textTheme.bodyMedium),
      ],
    );
  }
}
