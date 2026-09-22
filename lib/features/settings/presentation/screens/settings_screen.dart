import 'dart:async';

import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/router/app_routes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/paper_card.dart';
import 'package:capture/core/widgets/page_frame.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_flow_notifier.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:capture/features/settings/presentation/screens/setup_steps_screen.dart';
import 'package:capture/features/settings/presentation/widgets/auto_save_section.dart';
import 'package:capture/features/settings/presentation/widgets/mic_section.dart';
import 'package:capture/features/settings/presentation/widgets/privacy_section.dart';
import 'package:capture/features/settings/presentation/widgets/quick_access_section.dart';
import 'package:capture/features/settings/presentation/widgets/reset_dialog.dart';
import 'package:capture/features/settings/presentation/widgets/reset_section.dart';
import 'package:capture/features/settings/presentation/widgets/shortcut_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Setup steps, shortcut (quick access on iPhone), microphone, auto-save,
/// privacy and reset.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _resetDialogRoute = 'reset-dialog';

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      routeSettings: const .new(name: _resetDialogRoute),
      builder: (dialogContext) => ResetDialog(
        onCancel: () => Navigator.of(dialogContext).pop(false),
        onReset: () => Navigator.of(dialogContext).pop(true),
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(captureFlowProvider.notifier).startOver();
    if (!context.mounted) return;
    const HomeRoute().go(context);
  }

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
    final phone = ref.watch(systemDatasourceProvider.select((s) => s.isPhone));
    final autoSave = ref.watch(settingsProvider.select((s) => s.autoSave));
    final capturing = ref.watch(captureFlowProvider.select((s) => s.busyWith));
    return PageFrame(
      title: l10n.navSettings,
      children: [
        const PaperCard(child: SetupStepsScreen()),
        const SizedBox(height: Spacing.lg),
        PaperCard(
          child: phone
              ? const QuickAccessSection()
              : ShortcutSection(
                  label: label,
                  registered: registered,
                  problem: problem,
                  onShortcut: (shortcut) =>
                      unawaited(ref.read(settingsProvider.notifier).setShortcut(shortcut)),
                  onRecording: (recording) => unawaited(
                    ref.read(settingsProvider.notifier).pauseShortcut(paused: recording),
                  ),
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
        PaperCard(
          child: AutoSaveSection(
            on: autoSave,
            onChanged: (on) => ref.read(settingsProvider.notifier).setAutoSave(on: on),
          ),
        ),
        const SizedBox(height: Spacing.lg),
        const PaperCard(child: PrivacySection()),
        const SizedBox(height: Spacing.lg),
        PaperCard(
          child: ResetSection(
            onReset: capturing ? null : () => unawaited(_confirmReset(context, ref)),
          ),
        ),
      ],
    );
  }
}
