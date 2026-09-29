import 'dart:async';

import 'package:capture/app/app_startup.dart';
import 'package:capture/core/data/reminders/reminder_datasource.dart';
import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/presentation/extensions/capture_labels.dart';
import 'package:capture/features/capture/presentation/extensions/menu_lines.dart';
import 'package:capture/features/capture/presentation/extensions/review_card_content.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_flow_notifier.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_flow_state.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_phase.dart';
import 'package:capture/features/groups/presentation/notifiers/groups_notifier.dart';
import 'package:capture/features/library/presentation/notifiers/library_notifier.dart';
import 'package:capture/features/settings/presentation/extensions/settings_labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Native effects and typed navigation share the shell router context and listener ordering.
class CaptureBootstrap extends ConsumerWidget {
  const CaptureBootstrap({required this.child, required this.destination, super.key});

  final Widget child;
  final GoRouteData? Function(CaptureFlowState state) destination;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    ref
      ..listen(appStartupProvider, (_, next) {
        if (next.hasValue) _menu(context, ref);
      })
      ..listen(captureFlowProvider.select((s) => s.phase), (_, phase) {
        _overlay(context, ref, phase);
      })
      ..listen(captureFlowProvider.select((s) => s.reviewing), (_, record) {
        if (record != null) _review(context, ref, record);
      })
      ..listen(captureFlowProvider.select((s) => s.autoSavedId), (_, id) {
        if (ref.read(captureFlowProvider).byId(id) case final CaptureRecord record) {
          _announceSaved(context, ref, record);
        }
      })
      ..listen(captureFlowProvider.select((s) => s.destinationSerial), (_, _) {
        if (destination(ref.read(captureFlowProvider)) case final GoRouteData route) {
          route.go(context);
        }
      })
      ..listen(groupsProvider.select((s) => s.failureSerial), (_, _) {
        if (ref.read(groupsProvider).failure case final failure?) {
          _snack(context, failure.label(l10n));
        }
      })
      ..listen(libraryProvider.select((s) => s.failureSerial), (_, _) {
        final library = ref.read(libraryProvider);
        if (library.cacheRefreshFailed) {
          _snack(context, l10n.libraryRefreshFailed);
        } else if (library.failure case final failure?) {
          _snack(context, failure.label(l10n));
        }
      })
      ..listen(libraryProvider.select((s) => s.upcoming.firstOrNull), (_, _) => _menu(context, ref))
      ..listen(captureFlowProvider.select((s) => s.captures.firstOrNull), (_, _) {
        _menu(context, ref);
      })
      ..watch(appStartupProvider.select((startup) => startup.hasValue));
    return child;
  }

  void _overlay(BuildContext context, WidgetRef ref, CapturePhase phase) {
    final native = ref.read(nativePlatformServiceProvider);
    final l10n = context.l10n;
    switch (phase) {
      case .idle:
        unawaited(native.hideOverlay());
      case .transcribing:
        unawaited(native.showWorking(l10n.overlayTranscribing));
      case .analysing:
        unawaited(native.showWorking(l10n.overlaySorting));
      case .saving:
        unawaited(native.showWorking(l10n.overlaySaving));
      case .recording || .review:
    }
  }

  void _review(BuildContext context, WidgetRef ref, CaptureRecord record) => unawaited(
    ref
        .read(nativePlatformServiceProvider)
        .showReview(record.reviewCard(context.l10n, ref.read(groupsProvider))),
  );

  void _announceSaved(BuildContext context, WidgetRef ref, CaptureRecord record) {
    final l10n = context.l10n;
    unawaited(
      ref
          .read(reminderDatasourceProvider)
          .show(
            id: record.id.value,
            title: l10n.statusSaved,
            body: record.includedItems.summary(l10n),
          ),
    );
  }

  void _snack(BuildContext context, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(.new(content: Text(message)));

  void _menu(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final today = ref.read(systemDatasourceProvider).nowUtc().toLocal();
    unawaited(
      ref
          .read(nativePlatformServiceProvider)
          .setMenuState(
            nextUp: ref.read(libraryProvider).upcoming.firstOrNull.nextUpLine(l10n, today),
            latest: ref.read(captureFlowProvider).captures.firstOrNull.latestLine(l10n),
            // Recording needs only the microphone; setup can come later.
            canRecord: true,
          ),
    );
  }
}
