import 'dart:async';

import 'package:flutter/foundation.dart';

import '../domain/capture.dart';
import '../domain/dates/format.dart';
import '../domain/models.dart';
import '../services/native_bridge.dart';
import 'capture_flow.dart';
import 'env.dart';
import 'library_controller.dart';
import 'settings_controller.dart';

enum Section { home, groups, recordings, todo, upcoming, settings, editor }

/// Top-level wiring: owns the controllers, routes native events and keeps
/// the menu-bar popover's text truthful.
class AppModel {
  AppModel(this.env)
    : settings = SettingsController(env),
      section = ValueNotifier(Section.home),
      editing = ValueNotifier(null) {
    flow = CaptureFlow(env, settings);
    library = LibraryController(env, settings);
  }

  final AppEnv env;
  final SettingsController settings;
  late final CaptureFlow flow;
  late final LibraryController library;

  /// Main-window navigation.
  final ValueNotifier<Section> section;

  /// Capture id open in the proposal editor.
  final ValueNotifier<String?> editing;

  final _subs = <StreamSubscription<Object?>>[];

  Future<void> start() async {
    await env.native.installMenu();
    await settings.load();
    flow.recoverInterrupted();
    _subs
      ..add(env.native.events.listen(_onEvent))
      ..add(flow.editRequests.stream.listen(openEditor))
      ..add(flow.savedController.stream.listen((_) => library.refresh()));
    flow.addListener(_syncMenu);
    library.addListener(_syncMenu);
    settings.addListener(_syncMenu);
    _syncMenu();
    if (settings.notionConnected) unawaited(library.refresh());
  }

  void _onEvent(NativeEvent event) {
    if (event is MenuAction) {
      unawaited(_onMenu(event.action));
    } else {
      flow.onNativeEvent(event);
    }
  }

  Future<void> _onMenu(String action) async {
    switch (action) {
      case 'record':
        await flow.toggle();
        return;
      case 'settings':
        section.value = Section.settings;
      case 'upcoming':
        section.value = Section.upcoming;
      case 'recordings':
        section.value = Section.recordings;
      default:
        break;
    }
    await env.native.showMainWindow();
  }

  void openEditor(String captureId) {
    editing.value = captureId;
    section.value = Section.editor;
  }

  void _syncMenu() {
    final next = library.upcoming.firstOrNull;
    final latest = flow.captures.firstOrNull;
    final now = env.now();
    unawaited(
      env.native.setMenuState(
        nextUp: next == null
            ? 'Nothing scheduled'
            : '${next.title} · ${formatDue((next.reminder ?? next.due)!, now)}',
        latest: latest == null ? 'No captures yet' : latestLine(latest),
        canRecord: settings.ready,
      ),
    );
  }

  void dispose() {
    for (final s in _subs) {
      unawaited(s.cancel());
    }
    flow.dispose();
    library.dispose();
    settings.dispose();
  }
}

/// "1 task · 2 notes", or the capture's state when nothing was saved.
String latestLine(CaptureRecord r) => switch (r.stage) {
  CaptureStage.saved => proposalSummary(r.includedItems),
  CaptureStage.proposed => 'Waiting for review',
  CaptureStage.approved => 'Save incomplete',
  CaptureStage.dismissed => 'Not saved',
  CaptureStage.recorded || CaptureStage.transcribed =>
    r.error == null ? 'Processing' : 'Needs attention',
};
