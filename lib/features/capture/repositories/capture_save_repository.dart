import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/reminders/reminder_datasource.dart';
import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/data/system/zone_offsets.dart';
import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/capture/data/datasources/audio_files_local_datasource.dart';
import 'package:capture/features/capture/data/datasources/capture_local_datasource.dart';
import 'package:capture/features/capture/data/datasources/notion_capture_remote_datasource.dart';
import 'package:capture/features/capture/domain/dates/date_resolver.dart';
import 'package:capture/features/capture/domain/entities/capture_failure.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/domain/entities/proposal_item.dart';
import 'package:capture/features/capture/domain/entities/save_progress.dart';
import 'package:capture/features/capture/repositories/capture_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;

part 'capture_save_repository.g.dart';

/// Reminders that could be scheduled and whether macOS refused any.
typedef ReminderOutcome = ({CaptureRecord record, bool notificationsOff});

/// Saves an approved capture to Notion one confirmed step at a time:
/// capture page → library items → audio → mark Saved. Each step's result is
/// stored locally before the next begins, so a retry skips confirmed steps
/// and never creates anything twice.
abstract interface class ICaptureSaveRepository {
  Future<CaptureOutcome> save(CaptureRecord record, NotionWorkspace ws);

  /// Schedules notifications for saved tasks with a future reminder.
  Future<ReminderOutcome> scheduleReminders(CaptureRecord record);
}

class CaptureSaveRepository implements ICaptureSaveRepository {
  CaptureSaveRepository({
    required this._remote,
    required CaptureStorage storage,
    required this._reminders,
    required this._system,
  }) : _local = storage.records,
       _files = storage.audio;

  final INotionCaptureRemoteDatasource _remote;
  final ICaptureLocalDatasource _local;
  final IAudioFilesLocalDatasource _files;
  final IReminderDatasource _reminders;
  final ISystemDatasource _system;

  CaptureRecord _persist(CaptureRecord record, SaveProgress progress) {
    final next = record.copyWith(progress: progress);
    _local.put(.fromEntity(next));
    return next;
  }

  @override
  Future<CaptureOutcome> save(CaptureRecord record, NotionWorkspace ws) async {
    final String pageId;
    final CaptureRecord withPage;
    switch (await _capturePage(record, ws)) {
      case Ok(:final value):
        pageId = value;
        withPage = _persist(record, record.progress.copyWith(capturePageId: value));
      case Err(:final failure):
        return .err(failure);
    }
    final CaptureRecord withItems;
    switch (await _itemPages(withPage, ws, pageId)) {
      case Ok(:final value):
        withItems = value;
      case Err(:final failure):
        return .err(failure);
    }
    final CaptureRecord withAudio;
    switch (await _audio(withItems, ws, pageId)) {
      case Ok(:final value):
        withAudio = _persist(withItems, value);
      case Err(:final failure):
        return .err(failure);
    }
    if (withAudio.progress.markedSaved) return .ok(withAudio);
    if (await _remote.markSaved(pageId) case Err(:final failure)) {
      return .err(_captureFailure(failure));
    }
    return .ok(_persist(withAudio, withAudio.progress.copyWith(markedSaved: true)));
  }

  Future<Result<String, CaptureFailure>> _capturePage(CaptureRecord r, NotionWorkspace ws) async {
    if (r.progress.capturePageId case final String id) return .ok(id);
    return _mapped(switch (await _remote.findCapturePage(ws, r.id.value)) {
      Ok(value: final String id) => .ok(id),
      Ok() => await _remote.createCapturePage(ws, r),
      Err(:final failure) => .err(failure),
    });
  }

  /// Creates the next missing item page, stores it, then continues with the
  /// rest, so a failure keeps every page already confirmed.
  Future<CaptureOutcome> _itemPages(CaptureRecord r, NotionWorkspace ws, String pageId) async {
    final itemPages = r.progress.itemPages;
    final item = r.includedItems.where((i) => !itemPages.containsKey(i.id.value)).firstOrNull;
    if (item == null) return .ok(r);
    return switch (await _itemPage(r, ws, item, pageId)) {
      Ok(:final value) => await _itemPages(
        _persist(r, r.progress.copyWith(itemPages: {...itemPages, item.id.value: value})),
        ws,
        pageId,
      ),
      Err(:final failure) => .err(failure),
    };
  }

  Future<Result<String, CaptureFailure>> _itemPage(
    CaptureRecord r,
    NotionWorkspace ws,
    ProposalItem item,
    String pageId,
  ) async => _mapped(switch (await _remote.findItemPage(ws, item.id.value)) {
    Ok(value: final String id) => .ok(id),
    Ok() => await _remote.createItemPage(ws, r, item, capturePageId: pageId),
    Err(:final failure) => .err(failure),
  });

  Future<Result<SaveProgress, CaptureFailure>> _audio(
    CaptureRecord r,
    NotionWorkspace ws,
    String pageId,
  ) async {
    final CaptureRecord(m4aPath: path, :progress, :id) = r;
    if (progress.audioAttached || path == null) return .ok(progress);
    final attached = await _remote.hasRecording(pageId);
    if (attached case Err(:final failure)) return .err(_captureFailure(failure));
    if (attached case Ok(value: true)) return .ok(progress.copyWith(audioAttached: true));
    if (_files.sizeOf(path) == 0) return const .err(.audioMissing);
    if (_files.sizeOf(path) > ws.maxUpload.inBytes) {
      return const .err(.audioTooLarge);
    }
    final bytes = await _files.read(path);
    return switch (await _remote.attachRecording(pageId, bytes, name: 'capture-${id.value}.m4a')) {
      Ok(:final value) => .ok(progress.copyWith(audioUploadId: value, audioAttached: true)),
      Err(:final failure) => .err(_captureFailure(failure)),
    };
  }

  Result<String, CaptureFailure> _mapped(NotionResult<String> result) => switch (result) {
    Ok(:final value) => .ok(value),
    Err(:final failure) => .err(_captureFailure(failure)),
  };

  static CaptureFailure _captureFailure(NotionFailure f) => switch (f) {
    .invalidToken => .notionAuth,
    .notShared || .missingCapability => .notionAccess,
    .blockLimit => .notionBlockLimit,
    .rateLimited || .unavailable || .network => .notionUnavailable,
    .invalidRequest => .notionRejected,
  };

  @override
  Future<ReminderOutcome> scheduleReminders(CaptureRecord record) async {
    final CaptureRecord(:id, :timeZone, :includedItems, :progress, :copyWith) = record;
    final offsets = zoneOffsets(timeZone.value);
    final location = tz.getLocation(timeZone.value);
    final now = _system.nowUtc();
    final due = [
      for (final item in includedItems)
        if (item case ProposalItem(isTask: true, reminder: final reminder?))
          if (!progress.remindersScheduled.contains(item.id.value))
            if (reminderInstant(reminder, offsets) case final at? when at.isAfter(now))
              (item: item, at: tz.TZDateTime.from(at, location)),
    ];
    final scheduled = {...progress.remindersScheduled};
    bool refused = false;
    for (final (:item, :at) in due) {
      final accepted = await _reminders.schedule(
        itemId: item.id.value,
        title: item.title ?? '',
        at: at,
      );
      refused = refused || !accepted;
      // A capture deleted while the prompt was open stays deleted.
      if (accepted && _local.get(id.value) != null) {
        scheduled.add(item.id.value);
        _persist(record, progress.copyWith(remindersScheduled: {...scheduled}));
      }
    }
    return (
      record: copyWith(progress: progress.copyWith(remindersScheduled: scheduled)),
      notificationsOff: refused,
    );
  }
}

@Riverpod(keepAlive: true)
ICaptureSaveRepository captureSaveRepository(Ref ref) => CaptureSaveRepository(
  remote: ref.read(notionCaptureRemoteDatasourceProvider),
  storage: (
    records: ref.read(captureLocalDatasourceProvider),
    audio: ref.read(audioFilesLocalDatasourceProvider),
  ),
  reminders: ref.read(reminderDatasourceProvider),
  system: ref.read(systemDatasourceProvider),
);
