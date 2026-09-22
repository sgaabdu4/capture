import 'dart:async';

import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_flow_notifier.dart';
import 'package:capture/features/capture/presentation/notifiers/recording_meter_notifier.dart';
import 'package:capture/features/capture/presentation/screens/phone_review.dart';
import 'package:capture/features/capture/presentation/widgets/recording_pill.dart';
import 'package:capture/features/capture/presentation/widgets/working_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// On iPhone, what the Mac shows in its floating overlay: the recording
/// pill, the working pill, or the review card over its pill, just above the
/// bottom bar. Nothing while idle.
class PhoneOverlay extends ConsumerWidget {
  const PhoneOverlay({super.key});

  static const _padding = EdgeInsets.only(left: Spacing.md, right: Spacing.md, bottom: Spacing.md);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final phase = ref.watch(captureFlowProvider.select((s) => s.phase));
    final levels = ref.watch(recordingMeterProvider.select((m) => m.levels));
    final elapsed = ref.watch(recordingMeterProvider.select((m) => m.elapsed));
    final Widget? content = switch (phase) {
      .idle => null,
      .recording => RecordingPill(
        levels: levels,
        elapsed: elapsed,
        onStop: () => unawaited(ref.read(captureFlowProvider.notifier).stop()),
      ),
      .transcribing => WorkingPill(status: l10n.overlayTranscribing),
      .analysing => WorkingPill(status: l10n.overlaySorting),
      .saving => WorkingPill(status: l10n.overlaySaving),
      .review => const PhoneReview(),
    };
    if (content == null) return const SizedBox.shrink();
    return Padding(padding: _padding, child: content);
  }
}
