import 'dart:async';

import 'package:capture/app/app_startup.dart';
import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/router/app_routes.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/presentation/extensions/menu_lines.dart';
import 'package:capture/features/capture/presentation/extensions/review_card_content.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_flow_notifier.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_flow_state.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_phase.dart';
import 'package:capture/features/groups/presentation/notifiers/groups_notifier.dart';
import 'package:capture/features/library/presentation/notifiers/library_notifier.dart';
import 'package:capture/features/settings/presentation/extensions/settings_labels.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Root side effects that need localizations and the router: the native
/// overlay, review card and menu, navigation requested by the capture flow,
/// and snackbars for background Notion failures.
class CaptureBootstrap extends ConsumerWidget {
  const CaptureBootstrap({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..listen(appStartupProvider, (_, next) {
        if (next.hasValue) _menu(context, ref);
      })
      ..listen(captureFlowProvider.select((s) => s.phase), (_, phase) {
        unawaited(_overlay(context, ref, phase));
      })
      ..listen(captureFlowProvider.select((s) => s.reviewing), (_, record) {
        if (record != null) unawaited(_review(context, ref, record));
      })
      ..listen(captureFlowProvider.select((s) => s.destinationSerial), (_, _) {
        _destination(ref.read(captureFlowProvider))?.go(context);
      })
      ..listen(groupsProvider.select((s) => s.failureSerial), (_, _) {
        if (ref.read(groupsProvider).failure case final failure?) {
          _snack(context, failure.label(context.l10n));
        }
      })
      ..listen(libraryProvider.select((s) => s.failureSerial), (_, _) {
        if (ref.read(libraryProvider).failure case final failure?) {
          _snack(context, failure.label(context.l10n));
        }
      })
      ..listen(libraryProvider.select((s) => s.upcoming.firstOrNull), (_, _) => _menu(context, ref))
      ..listen(captureFlowProvider.select((s) => s.captures.firstOrNull), (_, _) {
        _menu(context, ref);
      })
      ..listen(settingsProvider.select((s) => s.ready), (_, _) => _menu(context, ref))
      ..watch(appStartupProvider);
    return child;
  }

  Future<void> _overlay(BuildContext context, WidgetRef ref, CapturePhase phase) {
    final native = ref.read(nativePlatformServiceProvider);
    final l10n = context.l10n;
    return switch (phase) {
      .idle => native.hideOverlay(),
      .transcribing => native.showWorking(l10n.overlayTranscribing),
      .analysing => native.showWorking(l10n.overlaySorting),
      .saving => native.showWorking(l10n.overlaySaving),
      .recording || .review => .value(),
    };
  }

  Future<void> _review(BuildContext context, WidgetRef ref, CaptureRecord record) => ref
      .read(nativePlatformServiceProvider)
      .showReview(record.reviewCard(context.l10n, ref.read(groupsProvider)));

  GoRouteData? _destination(CaptureFlowState state) => switch (state) {
    CaptureFlowState(destination: .settings) => const SettingsRoute(),
    CaptureFlowState(destination: .upcoming) => const UpcomingRoute(),
    CaptureFlowState(destination: .recordings) => const RecordingsRoute(),
    CaptureFlowState(destination: .editor, editId: final String id) => EditorRoute(id: id),
    CaptureFlowState() => null,
  };

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
            canRecord: ref.read(settingsProvider).ready,
          ),
    );
  }
}
