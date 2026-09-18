import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;

import '../domain/capture.dart';
import '../domain/dates/date_resolver.dart';
import '../domain/dates/format.dart';
import '../domain/models.dart';
import '../domain/proposal/edits.dart';
import '../domain/proposal/proposal_builder.dart';
import '../services/capture_analyzer.dart';
import '../services/jev_client.dart';
import '../services/native_bridge.dart';
import '../services/notion_saver.dart';
import '../services/secrets.dart';
import 'env.dart';
import 'settings_controller.dart';

enum Phase { idle, recording, transcribing, analysing, review, saving }

const maxCaptureSeconds = 300.0;
const _minCaptureSeconds = 0.6;

/// The capture state machine. Every milestone is persisted before the next
/// step (see [CaptureStage]); approval is the only path to Notion and to
/// reminders.
class CaptureFlow extends ChangeNotifier {
  CaptureFlow(this._env, this._settings);
  final AppEnv _env;
  final SettingsController _settings;

  Phase phase = Phase.idle;
  String? activeId;

  /// One-line status for the main window (errors included).
  String? notice;

  /// Set when the user asks to edit a proposal in the main window.
  final editRequests = StreamController<String>.broadcast();

  List<CaptureRecord> get captures => _env.store.captures();
  CaptureRecord? get active =>
      activeId == null ? null : _env.store.capture(activeId!);

  void _set(Phase p, {String? notice}) {
    phase = p;
    this.notice = notice;
    notifyListeners();
  }

  void _put(CaptureRecord r) {
    _env.store.putCapture(r);
    notifyListeners();
  }

  /// Hotkey, menu and home button all land here.
  Future<void> toggle() async {
    switch (phase) {
      case Phase.recording:
        await stop();
      case Phase.idle:
        await start();
      case Phase.review:
        await showReview(activeId!);
      case Phase.transcribing || Phase.analysing || Phase.saving:
        break;
    }
  }

  Future<void> start() async {
    if (!_settings.ready) {
      _set(Phase.idle, notice: 'Finish setup before your first capture.');
      await _env.native.showMainWindow();
      return;
    }
    if (!await _settings.ensureMic()) {
      _set(
        Phase.idle,
        notice:
            'Capture needs microphone access. Allow it in System Settings → '
            'Privacy & Security → Microphone.',
      );
      await _env.native.showMainWindow();
      return;
    }
    final id = _env.newId();
    await Directory(_env.capturesDir).create(recursive: true);
    final record = CaptureRecord(
      id: id,
      capturedAtUtc: _env.now().toUtc(),
      timeZone: await _env.timeZone(),
      audioPath: '${_env.capturesDir}/$id.pcm',
    );
    _put(record);
    activeId = id;
    try {
      await _env.native.startRecording(
        record.audioPath,
        maxSeconds: maxCaptureSeconds,
      );
      _set(Phase.recording);
    } on Exception {
      _env.store.deleteCapture(id);
      activeId = null;
      _set(Phase.idle, notice: "Couldn't start recording.");
    }
  }

  Future<void> stop({String? reason}) async {
    if (phase != Phase.recording) return;
    final result = await _env.native.stopRecording();
    final record = active;
    if (result == null || record == null) {
      await _env.native.hideOverlay();
      _set(Phase.idle, notice: reason);
      return;
    }
    if (result.seconds < _minCaptureSeconds) {
      await _discardFiles(record);
      _env.store.deleteCapture(record.id);
      await _env.native.hideOverlay();
      activeId = null;
      _set(Phase.idle, notice: 'That was too short to keep.');
      return;
    }
    _put(record.copyWith(durationSeconds: result.seconds));
    if (reason != null) notice = reason;
    await process(record.id);
  }

  /// Runs the pipeline from wherever [id] stopped. Safe to call again after
  /// a failure or a relaunch.
  Future<void> process(String id) async {
    activeId = id;
    var r = _env.store.capture(id)!;
    try {
      if (r.stage == CaptureStage.recorded) r = await _transcribe(r);
      if (r.stage == CaptureStage.transcribed) r = await _analyse(r);
    } on Object catch (e) {
      _put(r.copyWith(error: () => _describe(e)));
      await _env.native.hideOverlay();
      activeId = null;
      _set(Phase.idle, notice: _describe(e));
      return;
    }
    if (r.stage == CaptureStage.proposed) await showReview(id);
    if (r.stage == CaptureStage.approved) await approve(id);
  }

  Future<CaptureRecord> _transcribe(CaptureRecord r) async {
    _set(Phase.transcribing);
    await _env.native.showWorking('Transcribing on this Mac…');
    final transcript = await _env.speech.transcribe(r.audioPath);
    final m4a = await _encode(r);
    final next = r.copyWith(
      stage: CaptureStage.transcribed,
      transcript: transcript,
      m4aPath: m4a,
      error: () => null,
    );
    _put(next);
    return next;
  }

  Future<String?> _encode(CaptureRecord r) async {
    final out = '${_env.capturesDir}/${r.id}.m4a';
    try {
      await _env.native.encodeM4a(r.audioPath, out);
      return out;
    } on Exception {
      return null; // Saved without audio; the transcript still goes.
    }
  }

  Future<CaptureRecord> _analyse(CaptureRecord r) async {
    final transcript = r.transcript ?? '';
    if (transcript.trim().isEmpty) {
      final next = r.copyWith(stage: CaptureStage.proposed, items: const []);
      _put(next);
      return next;
    }
    _set(Phase.analysing);
    await _env.native.showWorking('Sorting your thoughts…');
    final groups = _settings.activeGroups;
    final location = tz.getLocation(r.timeZone);
    List<ProposalItem> items;
    String? error;
    final key = await _env.secrets.read(Secret.typesafeKey);
    final jev = _env.jev(key ?? '');
    try {
      final analysis = await CaptureAnalyzer(jev).analyze(
        transcript: transcript,
        groups: groups,
        capturedAtUtc: r.capturedAtUtc,
        location: location,
        newId: _env.newId,
      );
      items = analysis.items;
    } on JevException catch (e) {
      error = '${e.userMessage} Your capture is kept as one note to edit.';
      items = [
        manualProposal(wholeTranscript(transcript), groups, _env.newId()),
      ];
    } finally {
      jev.close();
    }
    final next = r.copyWith(
      stage: CaptureStage.proposed,
      items: items,
      error: () => error,
    );
    _put(next);
    return next;
  }

  Future<void> showReview(String id) async {
    final r = _env.store.capture(id);
    if (r == null) return;
    activeId = id;
    _set(Phase.review, notice: r.error);
    final problems = approvalProblems(r.items);
    final included = r.includedItems;
    await _env.native.showReview(
      countLine: included.isEmpty
          ? "I didn't catch anything to save."
          : proposalSummary(included),
      rows: [for (final i in included) _row(r, i)],
      canApprove: included.isNotEmpty && problems.isEmpty,
      blockedReason:
          r.error ??
          (problems.isEmpty ? null : 'Needs a look: ${problems.first}'),
    );
  }

  ReviewCardRow _row(CaptureRecord r, ProposalItem item) {
    final today = tz.TZDateTime.from(
      r.capturedAtUtc,
      tz.getLocation(r.timeZone),
    );
    final group = _settings.groups
        .where((g) => g.id == item.groupId)
        .firstOrNull;
    final when = item.reminder ?? item.due;
    final detail = [
      if (item.kind == ItemKind.note) 'Note' else 'Task',
      ?group?.name,
      if (when != null) formatDue(when, today),
      if (item.flags.isNotEmpty) item.flags.first.label,
    ].join(' · ');
    final icon = item.kind == ItemKind.note
        ? 'doc.text'
        : when != null
        ? 'calendar'
        : 'checkmark.square';
    return ReviewCardRow(item.id, icon, item.title, detail);
  }

  Future<void> onReviewAction(String action) async {
    final id = activeId;
    if (id == null || phase != Phase.review) return;
    switch (action) {
      case 'yes':
        await approve(id);
      case 'no':
        await dismiss(id);
      case 'edit':
        await _env.native.hideOverlay();
        _set(Phase.idle);
        editRequests.add(id);
        await _env.native.showMainWindow();
      default:
        await _env.native.hideOverlay();
        activeId = null;
        _set(Phase.idle, notice: 'Waiting for your review in Recordings.');
    }
  }

  /// Brings a dismissed capture back for review.
  void reopen(String id) {
    final r = _env.store.capture(id);
    if (r == null || r.stage != CaptureStage.dismissed) return;
    _put(r.copyWith(stage: CaptureStage.proposed));
  }

  /// Replaces a proposal after edits in the main window.
  void updateItems(String id, List<ProposalItem> items) {
    final r = _env.store.capture(id);
    if (r == null || r.stage != CaptureStage.proposed) return;
    _put(r.copyWith(items: items));
  }

  Future<void> dismiss(String id) async {
    final r = _env.store.capture(id);
    if (r == null) return;
    _put(r.copyWith(stage: CaptureStage.dismissed, error: () => null));
    await _env.native.hideOverlay();
    activeId = null;
    _set(
      Phase.idle,
      notice: 'Not saved. It stays in Recordings until you delete it.',
    );
  }

  /// The execution boundary: only an explicit approval reaches Notion.
  Future<void> approve(String id) async {
    var r = _env.store.capture(id);
    if (r == null) return;
    if (!_settings.notionConnected) {
      _set(phase, notice: 'Connect Notion in Settings to save.');
      return;
    }
    if (r.stage == CaptureStage.proposed) {
      if (r.includedItems.isEmpty || approvalProblems(r.items).isNotEmpty) {
        return;
      }
      r = r.copyWith(stage: CaptureStage.approved, error: () => null);
      _put(r);
    }
    if (r.stage != CaptureStage.approved) return;
    activeId = id;
    _set(Phase.saving);
    await _env.native.showWorking('Saving to Notion…');
    try {
      r = await _settings.withNotion(
        (client) => NotionSaver(
          client,
          _settings.workspace!,
        ).save(r!, persist: (next, _) async => _put(next)),
      );
    } on SaveFailure catch (e) {
      _put(r!.copyWith(error: () => "Couldn't save: ${e.message}"));
      await showReview(id);
      return;
    }
    r = await _scheduleReminders(r);
    _put(r.copyWith(stage: CaptureStage.saved, error: () => null));
    await _env.native.hideOverlay();
    activeId = null;
    _set(Phase.idle, notice: 'Saved to Notion.');
    savedController.add(id);
  }

  /// Fires after a capture is fully saved (library refresh listens).
  final savedController = StreamController<String>.broadcast();

  Future<CaptureRecord> _scheduleReminders(CaptureRecord r) async {
    final location = tz.getLocation(r.timeZone);
    var progress = r.progress;
    for (final item in r.includedItems) {
      final reminder = item.kind == ItemKind.task ? item.reminder : null;
      if (reminder == null || progress.remindersScheduled.contains(item.id)) {
        continue;
      }
      final at = reminderInstant(reminder, location);
      if (at == null || !at.isAfter(_env.now().toUtc())) continue;
      final ok = await _env.reminders.schedule(
        itemId: item.id,
        title: item.title,
        at: tz.TZDateTime.from(at, location),
      );
      if (ok) {
        progress = progress.copyWith(
          remindersScheduled: {...progress.remindersScheduled, item.id},
        );
        _put(r.copyWith(progress: progress));
      } else {
        notice = 'Saved, but macOS notifications are off for Capture.';
      }
    }
    return r.copyWith(progress: progress);
  }

  Future<void> deleteCapture(String id) async {
    final r = _env.store.capture(id);
    if (r == null || r.stage == CaptureStage.approved) return;
    await _discardFiles(r);
    _env.store.deleteCapture(id);
    notifyListeners();
  }

  Future<void> _discardFiles(CaptureRecord r) async {
    for (final path in [r.audioPath, ?r.m4aPath]) {
      final f = File(path);
      if (f.existsSync()) await f.delete();
    }
  }

  /// After a crash mid-recording the PCM file is intact but the duration
  /// was never stored; recover it from the file size.
  void recoverInterrupted() {
    for (final r in captures) {
      if (r.stage != CaptureStage.recorded || r.durationSeconds > 0) continue;
      final f = File(r.audioPath);
      final seconds = f.existsSync() ? f.lengthSync() / 32000 : 0.0;
      if (seconds < _minCaptureSeconds) {
        _env.store.deleteCapture(r.id);
      } else {
        _env.store.putCapture(r.copyWith(durationSeconds: seconds));
      }
    }
    notifyListeners();
  }

  void onNativeEvent(NativeEvent event) {
    switch (event) {
      case HotkeyPressed():
        unawaited(toggle());
      case StopRequested():
        unawaited(stop());
      case LimitReached():
        unawaited(stop(reason: 'Stopped at the 5-minute limit.'));
      case RecordingFailed(:final message):
        unawaited(stop(reason: message));
      case ReviewAction(:final action):
        unawaited(onReviewAction(action));
      case MenuAction():
        break;
    }
  }

  String _describe(Object e) => switch (e) {
    FileSystemException() => "The recording couldn't be read.",
    _ => 'Transcription failed. Your recording is kept; try again.',
  };

  @override
  void dispose() {
    unawaited(editRequests.close());
    unawaited(savedController.close());
    super.dispose();
  }
}
