import 'dart:async';

import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/data/system/zone_offsets.dart';
import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/core/services/native_event.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:capture/features/capture/data/datasources/jev_remote_datasource.dart';
import 'package:capture/features/capture/domain/capture_limits.dart';
import 'package:capture/features/capture/domain/dates/date_resolver.dart';
import 'package:capture/features/capture/domain/entities/capture_failure.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/domain/entities/capture_stage.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/capture/domain/entities/proposal_item.dart';
import 'package:capture/features/capture/domain/entities/review_flag.dart';
import 'package:capture/features/capture/domain/proposal/edits.dart';
import 'package:capture/features/capture/domain/proposal/proposal_builder.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_flow_state.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_notice.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_phase.dart';
import 'package:capture/features/capture/presentation/notifiers/shell_destination.dart';
import 'package:capture/features/capture/repositories/capture_analysis_repository.dart';
import 'package:capture/features/capture/repositories/capture_repository.dart';
import 'package:capture/features/capture/repositories/capture_save_repository.dart';
import 'package:capture/features/groups/presentation/notifiers/groups_notifier.dart';
import 'package:capture/features/library/presentation/notifiers/library_notifier.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'capture_flow_notifier.g.dart';

/// The capture state machine. Every milestone is persisted before the next
/// step (see [CaptureStage]); approval is the only path to Notion and to
/// reminders. Native events (hotkey, pill, review card, menu) land here.
@Riverpod(keepAlive: true)
class CaptureFlowNotifier extends _$CaptureFlowNotifier {
  @override
  CaptureFlowState build() {
    final events = _ensureNative().events.listen(_onEvent);
    ref.onDispose(events.cancel);
    return .new(captures: _ensureCaptures().all());
  }

  INativePlatformService _ensureNative() => ref.read(nativePlatformServiceProvider);

  ICaptureRepository _ensureCaptures() => ref.read(captureRepositoryProvider);

  ICaptureSaveRepository _ensureSaver() => ref.read(captureSaveRepositoryProvider);

  void _onEvent(NativeEvent event) {
    switch (event) {
      case HotkeyPressed() || MenuCommand(action: .record):
        unawaited(toggle());
      case StopRequested():
        unawaited(stop());
      case LimitReached():
        unawaited(stop(notice: .limitReached));
      case RecordingFailed():
        unawaited(stop(notice: .recordingInterrupted));
      case ReviewCardAction(:final action):
        unawaited(onReviewAction(action));
      case MenuCommand(action: .open):
        unawaited(_ensureNative().showMainWindow());
      case MenuCommand(action: .settings):
        unawaited(_open(.settings));
      case MenuCommand(action: .upcoming):
        unawaited(_open(.upcoming));
      case MenuCommand(action: .recordings):
        unawaited(_open(.recordings));
    }
  }

  Future<void> _open(ShellDestination destination, {String? editId}) async {
    state = state.copyWith(
      destination: destination,
      editId: editId,
      destinationSerial: state.destinationSerial + 1,
    );
    await _ensureNative().showMainWindow();
  }

  void _put(CaptureRecord record) {
    final captures = _ensureCaptures()..put(record);
    state = state.copyWith(captures: captures.all());
  }

  void _reloadCaptures() => state = state.copyWith(captures: _ensureCaptures().all());

  void _enter(CapturePhase phase, {String? activeId}) =>
      state = state.copyWith(phase: phase, activeId: activeId ?? state.activeId);

  void _idle({CaptureNotice? notice, CaptureFailure? failure}) =>
      state = state.copyWith(phase: .idle, activeId: null, notice: notice, failure: failure);

  /// Drops captures cut off by a crash before they had any audio.
  void recoverInterrupted() {
    _ensureCaptures().recoverInterrupted(minimum: minCaptureDuration);
    _reloadCaptures();
  }

  /// Hotkey, menu and the Home mic button all land here.
  Future<void> toggle() async {
    if (state.phase == .recording) return stop();
    if (state.phase == .idle) return start();
    if (state case CaptureFlowState(phase: .review, activeId: final String id)) showReview(id);
  }

  Future<void> start() async {
    if (!ref.read(settingsProvider).ready) return _stopWith(.setupIncomplete);
    final micAllowed = await ref.read(settingsProvider.notifier).ensureMic();
    if (!ref.mounted) return;
    if (!micAllowed) return _stopWith(.micDenied);
    final draft = await _ensureCaptures().createDraft();
    if (!ref.mounted) return;
    _beginDraft(draft);
    try {
      await _ensureNative().startRecording(draft.audioPath, limit: maxCaptureDuration);
      if (!ref.mounted) return;
      _enter(.recording);
    } on PlatformException {
      if (!ref.mounted) return;
      await _discard(draft, .recordingNotStarted);
    }
  }

  /// Setup or permission is missing: say so in the main window.
  Future<void> _stopWith(CaptureNotice notice) async {
    _idle(notice: notice);
    await _ensureNative().showMainWindow();
  }

  void _beginDraft(CaptureRecord draft) => state = state.copyWith(
    activeId: draft.id,
    captures: _ensureCaptures().all(),
    notice: null,
    failure: null,
  );

  Future<void> _discard(CaptureRecord record, CaptureNotice notice) async {
    await _ensureCaptures().delete(record);
    if (!ref.mounted) return;
    _reloadCaptures();
    _idle(notice: notice);
  }

  Future<void> stop({CaptureNotice? notice}) async {
    if (state.phase != .recording) return;
    final result = await _ensureNative().stopRecording();
    if (!ref.mounted) return;
    switch ((result: result, record: state.active)) {
      case (result: final RecordingResult result, record: final CaptureRecord record):
        if (result.duration < minCaptureDuration) return _discard(record, .tooShort);
        _put(record.copyWith(duration: result.duration));
        _keepNotice(notice);
        await process(record.id);
      case _:
        _idle(notice: notice);
    }
  }

  void _keepNotice(CaptureNotice? notice) => state = state.copyWith(notice: notice);

  /// Runs the pipeline from wherever [id] stopped. Safe to call again after
  /// a failure or a relaunch.
  Future<void> process(String id) async {
    final record = _ensureCaptures().get(id);
    if (record == null) return;
    _enter(state.phase, activeId: id);
    final transcribed = record.stage == .recorded ? await _transcribe(record) : record;
    if (!ref.mounted || transcribed == null) return;
    final proposed = transcribed.stage == .transcribed ? await _analyse(transcribed) : transcribed;
    if (!ref.mounted) return;
    if (proposed.stage == .proposed) showReview(id);
    if (proposed.stage == .approved) await approve(id);
  }

  /// Null when transcription failed (the failure is recorded).
  Future<CaptureRecord?> _transcribe(CaptureRecord record) async {
    _enter(.transcribing);
    final result = await _ensureCaptures().transcribe(record);
    if (!ref.mounted) return null;
    switch (result) {
      case Ok(:final value):
        _reloadCaptures();
        return value;
      case Err(:final failure):
        _put(record.copyWith(failure: failure));
        _idle(failure: failure);
        return null;
    }
  }

  /// Jev failure never loses the capture: it becomes one editable note.
  Future<CaptureRecord> _analyse(CaptureRecord record) async {
    final CaptureRecord(:transcript, :capturedAtUtc, :timeZone, :copyWith) = record;
    final text = transcript ?? '';
    final groups = ref.read(groupsProvider).active;
    if (text.trim().isEmpty) {
      final empty = copyWith(stage: .proposed, items: const []);
      _put(empty);
      return empty;
    }
    _enter(.analysing);
    final result = await ref
        .read(captureAnalysisRepositoryProvider)
        .analyze(
          transcript: text,
          groups: groups,
          moment: .new(capturedAtUtc: capturedAtUtc, offsetAt: zoneOffsets(timeZone)),
        );
    if (!ref.mounted) return record;
    final next = switch (result) {
      Ok(:final value) => copyWith(stage: .proposed, items: value.items, failure: null),
      Err(:final failure) => copyWith(
        stage: .proposed,
        items: [
          manualProposal(wholeTranscript(text), groups, ref.read(systemDatasourceProvider).newId()),
        ],
        failure: _jevFailure(failure),
      ),
    };
    _put(next);
    return next;
  }

  static CaptureFailure _jevFailure(JevFailure f) => switch (f) {
    .invalidKey => .jevKey,
    .rateLimited || .unavailable || .network => .jevUnavailable,
    .invalidResponse => .jevResponse,
  };

  /// Puts [id] on the review card.
  void showReview(String id) {
    if (state.byId(id) case final CaptureRecord r) {
      state = state.copyWith(phase: .review, activeId: id, notice: null, failure: r.failure);
    }
  }

  Future<void> onReviewAction(ReviewAction action) async {
    if (state case CaptureFlowState(phase: .review, activeId: final String id)) {
      switch (action) {
        case .yes:
          await approve(id);
        case .no:
          dismiss(id);
        case .edit:
          _idle();
          await _open(.editor, editId: id);
        case .later:
          _idle(notice: .reviewLater);
      }
    }
  }

  /// Brings a dismissed capture back for review.
  void reopen(String id) {
    if (_ensureCaptures().get(id) case final CaptureRecord r when r.stage == .dismissed) {
      _put(r.copyWith(stage: .proposed));
    }
  }

  void dismiss(String id) {
    if (_ensureCaptures().get(id) case final CaptureRecord r) {
      _put(r.copyWith(stage: .dismissed, failure: null));
      _idle(notice: .dismissed);
    }
  }

  /// The execution boundary: only an explicit approval reaches Notion.
  Future<void> approve(String id) async {
    final settings = ref.read(settingsProvider);
    final record = _ensureCaptures().get(id);
    if (record == null || state.phase == .saving) return;
    final ws = settings.workspace;
    if (ws == null || !settings.hasNotionToken) {
      _keepNotice(.notionNotConnected);
      return;
    }
    final approved = _approved(record);
    if (approved == null) return;
    await _save(approved, ws, fromCard: state.phase == .review);
  }

  /// Marks a proposal approved (persisted before any Notion call), or
  /// returns an already-approved capture; null when approval is blocked.
  CaptureRecord? _approved(CaptureRecord r) {
    if (r.stage == .approved) return r;
    final blocked = r.items.any((i) => i.approvalProblems.isNotEmpty);
    if (r.stage != .proposed || r.includedItems.isEmpty || blocked) return null;
    final next = r.copyWith(stage: .approved, failure: null);
    _put(next);
    return next;
  }

  Future<void> _save(CaptureRecord record, NotionWorkspace ws, {required bool fromCard}) async {
    final id = record.id;
    _enterSaving(id);
    final saved = await _ensureSaver().save(record, ws);
    if (!ref.mounted) return;
    switch (saved) {
      case Ok(:final value):
        await _finish(value);
      case Err(:final failure):
        _put((_ensureCaptures().get(id) ?? record).copyWith(failure: failure));
        _afterSaveFailure(id, failure, fromCard: fromCard);
    }
  }

  /// A card save failure reopens the card; otherwise the shell shows it.
  void _afterSaveFailure(String id, CaptureFailure failure, {required bool fromCard}) =>
      fromCard ? showReview(id) : _idle(failure: failure);

  void _enterSaving(String id) =>
      state = state.copyWith(phase: .saving, activeId: id, failure: null);

  /// Reminders are scheduled only after every Notion step is confirmed.
  Future<void> _finish(CaptureRecord record) async {
    final reminders = await _ensureSaver().scheduleReminders(record);
    if (!ref.mounted) return;
    _put(reminders.record.copyWith(stage: .saved, failure: null));
    _idle(notice: reminders.notificationsOff ? .savedNotificationsOff : .saved);
    unawaited(ref.read(libraryProvider.notifier).refresh());
  }

  /// Removes audio and draft from this Mac. An approved capture mid-save is
  /// kept so the retry cannot duplicate.
  Future<void> delete(String id) async {
    final captures = _ensureCaptures();
    final r = captures.get(id);
    if (r == null || r.stage == .approved || state.activeId == id) return;
    await captures.delete(r);
    if (!ref.mounted) return;
    _reloadCaptures();
  }

  /// Applies an editor change to a proposal still waiting for review.
  void editItem(String captureId, ProposalItem item) {
    if (_editable(captureId) case final CaptureRecord r) {
      _put(r.copyWith(items: [for (final i in r.items) i.id == item.id ? item : i]));
    }
  }

  CaptureRecord? _editable(String id) => switch (_ensureCaptures().get(id)) {
    final CaptureRecord r when r.stage == .proposed => r,
    _ => null,
  };

  /// Sets the date (and time) of [item]; an existing reminder follows it.
  void setWhen(String captureId, ProposalItem item, DueDate date) {
    if (_editable(captureId) case final CaptureRecord r) {
      final checks = _checks(r, date);
      final dated = item.withDue(date, checks: checks);
      final follows = item.reminder != null && date.hasTime;
      editItem(captureId, follows ? dated.withReminder(date, checks: checks) : dated);
    }
  }

  /// Turns the reminder on (at the due date and time) or off.
  void setReminder(String captureId, ProposalItem item, {required bool on}) {
    if (_editable(captureId) case final CaptureRecord r) {
      final next = switch (item.due) {
        final DueDate due when on && due.hasTime => item.withReminder(due, checks: _checks(r, due)),
        _ when !on => item.withReminder(null),
        _ => null,
      };
      if (next case final ProposalItem changed) editItem(captureId, changed);
    }
  }

  void clearWhen(String captureId, ProposalItem item) =>
      editItem(captureId, item.withDue(null).withReminder(null));

  Set<ReviewFlag> _checks(CaptureRecord r, DueDate date) =>
      checkInstant(date, zoneOffsets(r.timeZone), ref.read(systemDatasourceProvider).nowUtc());

  /// Splits [item] before transcript offset [at].
  void split(String captureId, ProposalItem item, int at) {
    if (_editable(captureId) case CaptureRecord(:final transcript, :final items, :final copyWith)) {
      final newId = ref.read(systemDatasourceProvider).newId();
      if (splitItem(item, transcript ?? '', at, newId) case (:final left, :final right)) {
        _put(
          copyWith(
            items: [
              for (final i in items) ...(i.id == item.id ? [left, right] : [i]),
            ],
          ),
        );
      }
    }
  }

  /// Merges the item at [index] with the one after it.
  void mergeWithNext(String captureId, int index) {
    if (_editable(captureId) case final CaptureRecord r when index + 1 < r.items.length) {
      final merged = mergeItems(r.items[index], r.items[index + 1]);
      _put(
        r.copyWith(
          items: [
            for (final (i, item) in r.items.indexed)
              if (i != index + 1) i == index ? merged : item,
          ],
        ),
      );
    }
  }
}
