import 'package:capture/core/data/reminders/reminder_datasource.dart';
import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/capture/data/datasources/audio_files_local_datasource.dart';
import 'package:capture/features/capture/data/datasources/capture_local_datasource.dart';
import 'package:capture/features/capture/data/datasources/notion_capture_remote_datasource.dart';
import 'package:capture/features/capture/data/models/capture_record_model.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/domain/entities/proposal_item.dart';
import 'package:capture/features/capture/repositories/capture_save_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../../helpers/test_fakes.dart';

class _MockRemote extends Mock implements INotionCaptureRemoteDatasource {}

class _MockLocal extends Mock implements ICaptureLocalDatasource {}

class _MockAudio extends Mock implements IAudioFilesLocalDatasource {}

/// Notifications allowed: every reminder is accepted.
class _AllowedReminders implements IReminderDatasource {
  @override
  Future<bool> schedule({
    required String itemId,
    required String title,
    required tz.TZDateTime at,
  }) async => true;

  @override
  Future<void> cancel(String itemId) async {}

  @override
  Future<void> cancelAll() async {}
  @override
  Future<void> show({required String id, required String title, required String body}) async {}
}

/// A task whose reminder is after [FakeSystem.now].
final _dentist = ProposalItem(
  id: .new('item-1'),
  sources: [],
  kind: .task,
  groupId: .new('g'),
  title: 'Call the dentist',
  body: '',
  reminder: const .new(2026, 9, 19, hour: 9, minute: 0),
);

/// A task with no reminder.
final _tomatoes = ProposalItem(
  id: .new('item-2'),
  sources: [],
  kind: .task,
  groupId: .new('g'),
  title: 'Plant tomatoes',
  body: '',
);

/// A saved capture with [_dentist].
final _record = CaptureRecord(
  id: .new('c1'),
  capturedAtUtc: FakeSystem.now,
  timeZone: .new(FakeSystem.zone),
  audioPath: .new('c1.m4a'),
  stage: .saved,
  items: [_dentist],
);

/// Schedules [_record]'s reminder; [stored] is whether the local store
/// still holds it once the permission prompt is answered. Returns what was
/// written to the store.
Future<List<CaptureRecordModel>> _schedule({required bool stored}) async {
  final local = _MockLocal();
  final writes = <CaptureRecordModel>[];
  when(() => local.get('c1')).thenReturn(stored ? .fromEntity(_record) : null);
  when(
    () => local.put(any()),
  ).thenAnswer((call) => writes.addAll(call.positionalArguments.whereType<CaptureRecordModel>()));
  await CaptureSaveRepository(
    remote: _MockRemote(),
    storage: (records: local, audio: _MockAudio()),
    reminders: _AllowedReminders(),
    system: FakeSystem(),
  ).scheduleReminders(_record);
  return writes;
}

final _workspace = NotionWorkspace(
  parentPageId: .new('parent'),
  areaPageId: .new('area'),
  groups: .new('groups'),
  captures: .new('captures'),
  library: .new('library'),
  maxUpload: .fromBytes(1),
);

/// [_record] approved with a second item and no audio to upload.
final _approved = _record.copyWith(stage: .approved, items: [_dentist, _tomatoes]);

/// Notion with nothing saved yet, where creating [failingItem]'s page fails
/// once and then works. Every page Notion is asked to make goes into
/// [created].
_MockRemote _notion({required String failingItem, required List<String> created}) {
  final remote = _MockRemote();
  bool failed = false;
  when(() => remote.findCapturePage(any(), any())).thenAnswer((_) async => const .ok(null));
  when(() => remote.findItemPage(any(), any())).thenAnswer((_) async => const .ok(null));
  when(() => remote.createCapturePage(any(), any())).thenAnswer((_) async {
    created.add('capture');
    return const .ok('capture-page');
  });
  when(() => remote.createItemPage(any(), any(), any(), capturePageId: any(named: 'capturePageId')))
      .thenAnswer((call) async {
        final id = switch (call.positionalArguments) {
          [_, _, ProposalItem(:final id)] => id.value,
          _ => fail('createItemPage without an item'),
        };
        created.add(id);
        if (id == failingItem && !failed) {
          failed = true;
          return const .err(.unavailable);
        }
        return .ok('page-$id');
      });
  when(() => remote.markSaved(any())).thenAnswer((_) async => const .ok(null));
  return remote;
}

void main() {
  setUpAll(() {
    tzdata.initializeTimeZones();
    registerFallbackValue(CaptureRecordModel.fromEntity(_record));
    registerFallbackValue(_workspace);
    registerFallbackValue(_record);
    registerFallbackValue(_dentist);
  });

  test('a save that fails at an item page resumes on retry and creates nothing twice', () async {
    final created = <String>[];
    final local = _MockLocal();
    final writes = <CaptureRecordModel>[];
    when(
      () => local.put(any()),
    ).thenAnswer((call) => writes.addAll(call.positionalArguments.whereType<CaptureRecordModel>()));
    final repository = CaptureSaveRepository(
      remote: _notion(failingItem: 'item-2', created: created),
      storage: (records: local, audio: _MockAudio()),
      reminders: _AllowedReminders(),
      system: FakeSystem(),
    );

    final first = await repository.save(_approved, _workspace);
    expect(first, isA<Err<CaptureRecord, Object>>());
    final kept = writes.last.toEntity();

    final progress = switch (await repository.save(kept, _workspace)) {
      Ok(:final value) => value.progress,
      Err(:final failure) => fail('Retry failed: $failure'),
    };
    expect(created, equals(['capture', 'item-1', 'item-2', 'item-2']));
    expect(progress.itemPages, equals({'item-1': 'page-item-1', 'item-2': 'page-item-2'}));
    expect(progress.markedSaved, isTrue);
  });

  test('a scheduled reminder is recorded on the stored capture', () async {
    final writes = await _schedule(stored: true);
    expect(
      [for (final w in writes) w.toEntity().progress.remindersScheduled],
      equals([
        {'item-1'},
      ]),
    );
  });

  test('a capture deleted while the reminder prompt was open is not written back', () async {
    expect(await _schedule(stored: false), isEmpty);
  });
}
