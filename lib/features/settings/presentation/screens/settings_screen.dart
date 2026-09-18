import 'dart:async';

import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/paper_card.dart';
import 'package:capture/core/widgets/page_frame.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:capture/features/settings/presentation/screens/setup_steps_screen.dart';
import 'package:capture/features/settings/presentation/widgets/mic_section.dart';
import 'package:capture/features/settings/presentation/widgets/privacy_section.dart';
import 'package:capture/features/settings/presentation/widgets/shortcut_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Setup steps, shortcut, microphone and privacy.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final (:label, :registered, :problem) = ref.watch(
      settingsProvider.select(
        (s) =>
            (label: s.shortcut.label, registered: s.shortcutRegistered, problem: s.shortcutProblem),
      ),
    );
    final mic = ref.watch(settingsProvider.select((s) => s.mic));
    return PageFrame(
      title: l10n.navSettings,
      children: [
        const PaperCard(child: SetupStepsScreen()),
        const SizedBox(height: Spacing.lg),
        PaperCard(
          child: ShortcutSection(
            label: label,
            registered: registered,
            problem: problem,
            onShortcut: (shortcut) =>
                unawaited(ref.read(settingsProvider.notifier).setShortcut(shortcut)),
          ),
        ),
        const SizedBox(height: Spacing.lg),
        PaperCard(
          child: MicSection(
            granted: mic == .granted,
            detail: switch (mic) {
              .granted => l10n.micGranted,
              .denied => l10n.micDenied,
              .undetermined => l10n.micUndetermined,
            },
            onAllow: mic == .undetermined
                ? () => unawaited(ref.read(settingsProvider.notifier).ensureMic())
                : null,
          ),
        ),
        const SizedBox(height: Spacing.lg),
        const PaperCard(child: PrivacySection()),
      ],
    );
  }
}
