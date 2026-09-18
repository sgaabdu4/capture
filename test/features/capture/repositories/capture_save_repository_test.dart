import 'package:capture/core/data/reminders/reminder_datasource.dart';
import 'package:capture/features/capture/data/datasources/audio_files_local_datasource.dart';
import 'package:capture/features/capture/data/datasources/capture_local_datasource.dart';
import 'package:capture/features/capture/data/datasources/notion_capture_remote_datasource.dart';
import 'package:capture/features/capture/data/models/capture_record_model.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
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
}

/// A saved capture with one task whose reminder is after [FakeSystem.now].
final _record = CaptureRecord(
  id: 'c1',
  capturedAtUtc: FakeSystem.now,
  timeZone: FakeSystem.zone,
  audioPath: 'c1.m4a',
  stage: .saved,
  items: const [
    .new(
      id: 'item-1',
      sources: [],
      kind: .task,
      groupId: 'g',
      title: 'Call the dentist',
      body: '',
      reminder: .new(2026, 9, 19, hour: 9, minute: 0),
    ),
  ],
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

void main() {
  setUpAll(() {
    tzdata.initializeTimeZones();
    registerFallbackValue(CaptureRecordModel.fromEntity(_record));
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
