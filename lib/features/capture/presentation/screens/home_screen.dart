import 'dart:async';

import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/router/app_routes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/underlined.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/presentation/extensions/capture_labels.dart';
import 'package:capture/features/capture/presentation/extensions/menu_lines.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_flow_notifier.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_phase.dart';
import 'package:capture/features/capture/presentation/notifiers/due_today_entries_provider.dart';
import 'package:capture/features/capture/presentation/widgets/home_cards.dart';
import 'package:capture/features/capture/presentation/widgets/recent_card.dart';
import 'package:capture/features/capture/presentation/widgets/recorder.dart';
import 'package:capture/features/groups/presentation/notifiers/groups_notifier.dart';
import 'package:capture/features/library/presentation/notifiers/library_notifier.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:capture/features/settings/presentation/screens/setup_steps_screen.dart';
import 'package:capture/features/settings/presentation/widgets/setup_panel.dart';
import 'package:capture/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wordmark, the mic, and either first-run setup or the Today, Recent and
/// Groups cards.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _recentLimit = 2;
  static const _groupsLimit = 3;
  static const _padding = EdgeInsets.fromLTRB(Spacing.xl, Spacing.xxxl, Spacing.xl, Spacing.xl);
  static const _compactPadding = EdgeInsets.fromLTRB(
    Spacing.md,
    Spacing.xxxl,
    Spacing.md,
    Spacing.lg,
  );

  static String _phaseLabel(AppLocalizations l10n, CapturePhase phase) => switch (phase) {
    .idle => l10n.recordTap,
    .recording => l10n.recordStopTap,
    .transcribing => l10n.recordTranscribing,
    .analysing => l10n.recordSorting,
    .review => l10n.recordWaitingReview,
    .saving => l10n.recordSaving,
  };

  static RecentItem _recent(AppLocalizations l10n, CaptureRecord r, DateTime now) {
    final saved = r.stage == .saved;
    final line = r.latestLine(l10n);
    return (
      title: saved ? l10n.recentSaved(line) : line,
      ago: r.capturedAtUtc.toLocal().agoLabel(l10n, now),
      saved: saved,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BuildContext(:l10n, :textTheme, :compact) = context;
    final ready = ref.watch(settingsProvider.select((s) => s.ready));
    final shortcut = ref.watch(settingsProvider.select((s) => s.shortcut.label));
    final (:phase, :notice, :failure) = ref.watch(
      captureFlowProvider.select((s) => (phase: s.phase, notice: s.notice, failure: s.failure)),
    );
    final now = ref.watch(systemDatasourceProvider.select((system) => system.nowUtc())).toLocal();
    final today = ref.watch(dueTodayEntriesProvider);
    final recent = ref.watch(captureFlowProvider.select((s) => s.captures)).take(_recentLimit);
    final groups = ref.watch(groupsProvider.select((s) => s.active)).take(_groupsLimit);
    final canToggle = phase == .idle || phase == .recording;
    final padding = compact ? _compactPadding : _padding;
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: padding,
        child: ConstrainedBox(
          constraints: .new(minHeight: constraints.maxHeight - padding.vertical),
          child: Column(
            children: [
              Underlined(l10n.appTitle, style: textTheme.displayLarge),
              const SizedBox(height: Spacing.md),
              Text(l10n.tagline, style: textTheme.titleLarge),
              const SizedBox(height: Spacing.xxl),
              Recorder(
                recording: phase == .recording,
                phaseLabel: _phaseLabel(l10n, phase),
                shortcutLabel: ref.read(systemDatasourceProvider).isPhone ? null : shortcut,
                message: failure?.label(l10n) ?? notice?.label(l10n),
                onPressed: canToggle
                    ? () => unawaited(ref.read(captureFlowProvider.notifier).toggle())
                    : null,
              ),
              const SizedBox(height: Spacing.xxl),
              if (!ready) const SetupPanel(steps: SetupStepsScreen()),
              if (ready)
                HomeCards(
                  today: .new(
                    items: [
                      for (final (:entry, :due) in today)
                        (title: entry.title ?? '', due: due.label(l10n, now), done: entry.done),
                    ],
                    onDoneChanged: (index, {required done}) => unawaited(
                      ref.read(libraryProvider.notifier).setDone(today[index].entry, done: done),
                    ),
                    onViewAll: () => const TodoRoute().go(context),
                  ),
                  recent: .new(
                    items: [for (final r in recent) _recent(l10n, r, now)],
                    onOpen: () => const RecordingsRoute().go(context),
                    onViewAll: () => const RecordingsRoute().go(context),
                  ),
                  groups: .new(
                    names: [for (final g in groups) g.name.value],
                    onOpen: () => const GroupsRoute().go(context),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
