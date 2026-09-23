import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/groups/domain/group_rules.dart';
import 'package:capture/features/groups/repositories/groups_repository.dart';
import 'package:capture/features/library/domain/entities/library_entry.dart';
import 'package:capture/features/library/repositories/library_repository.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_state.dart';

import 'test_fakes.dart';

/// A fully set-up, synthetic workspace: keys saved, Notion connected, model
/// downloaded, with a few groups, saved entries and captures.
final sampleWorkspace = NotionWorkspace(
  parentPageId: .new('parent'),
  areaPageId: .new('area'),
  groups: .new('groups'),
  captures: .new('captures'),
  library: .new('library'),
  maxUpload: .fromBytes(5242880),
);

/// Settings with everything in place; nothing is read from the Mac.
class ReadySettings extends SettingsNotifier {
  @override
  SettingsState build() => super.build().copyWith(
    workspace: sampleWorkspace,
    hasNotionToken: true,
    hasTypesafeKey: true,
    modelReady: true,
    loaded: true,
    shortcutRegistered: true,
    mic: .granted,
  );

  @override
  Future<void> load() async {}
}

final sampleGroups = [
  Group(
    id: .new('ideas'),
    name: .new('Ideas'),
    description: 'Possible products, improvements and things to explore.',
  ),
  Group(
    id: .new('home'),
    name: .new('Home'),
    description: 'Household jobs, family and personal errands.',
  ),
  Group(
    id: .new('learning'),
    name: .new('Learning'),
    description: 'Things read, watched or worth studying.',
  ),
  Group(
    id: .new('work'),
    name: .new('Work'),
    description: 'Meetings, follow-ups and professional commitments.',
  ),
];

/// [sampleGroups], unchanged by Notion.
class SampleGroups implements IGroupsRepository {
  @override
  List<Group> cached() => sampleGroups;

  @override
  Future<NotionResult<List<Group>>> refresh(NotionWorkspace ws) async => .ok(sampleGroups);

  @override
  Future<NotionResult<List<Group>>> seedIfEmpty(NotionWorkspace ws) async => .ok(sampleGroups);

  @override
  Future<NotionResult<Group>> create(NotionWorkspace ws, GroupDraft draft) async =>
      .ok(.new(id: .new('new'), name: .new(draft.name), description: draft.description));

  @override
  Future<NotionResult<void>> update(Group group) async => const .ok(null);
}

/// Title of the first saved task.
const sampleTaskTitle = 'Water the tomato seedlings';

final sampleEntries = [
  LibraryEntry(
    pageId: .new('1'),
    itemId: .new('1'),
    title: sampleTaskTitle,
    kind: .task,
    groupId: .new('home'),
    due: const .new(2026, 9, 17, hour: 20, minute: 0),
  ),
  LibraryEntry(
    pageId: .new('2'),
    itemId: .new('2'),
    title: 'Book the car in for its MOT',
    kind: .task,
    groupId: .new('home'),
    due: const .new(2026, 9, 18, hour: 9, minute: 0),
    reminder: const .new(2026, 9, 18, hour: 9, minute: 0),
  ),
  LibraryEntry(
    pageId: .new('3'),
    itemId: .new('3'),
    title: 'Send Priya the sprint notes and the list of open questions from Thursday',
    kind: .task,
    groupId: .new('work'),
    due: const .new(2026, 9, 18, hour: 14, minute: 0),
  ),
  LibraryEntry(
    pageId: .new('4'),
    itemId: .new('4'),
    title: 'Read the chapter on Rust lifetimes',
    kind: .task,
    groupId: .new('learning'),
  ),
  LibraryEntry(
    pageId: .new('5'),
    itemId: .new('5'),
    title: 'A tiny app that sorts spoken notes',
    kind: .note,
    groupId: .new('ideas'),
  ),
  LibraryEntry(
    pageId: .new('6'),
    itemId: .new('6'),
    title: 'Tomatoes along the south fence next year',
    kind: .note,
    groupId: .new('ideas'),
  ),
];

/// [sampleEntries]; edits and deletes succeed without changing them.
class SampleLibrary implements ILibraryRepository {
  @override
  List<LibraryEntry> cached() => sampleEntries;

  @override
  Future<NotionResult<List<LibraryEntry>>> refresh(NotionWorkspace ws) async => .ok(sampleEntries);

  @override
  Future<NotionResult<LibraryEntry>> setDone(LibraryEntry entry, {required bool done}) async =>
      .ok(entry.copyWith(done: done));

  @override
  Future<NotionResult<String>> body(LibraryEntry entry) async =>
      const .ok('Water the tomato seedlings before it gets dark.');

  @override
  Future<NotionResult<LibraryEntry>> update(LibraryEntry entry, {String? body}) async => .ok(entry);

  @override
  Future<NotionResult<void>> delete(LibraryEntry entry) async => const .ok(null);
}

const _transcript =
    'Remind me tomorrow at 9 am to book the car in for its MOT. Also, an idea for the garden: tomatoes along the south fence next year.';

/// A capture saved twenty minutes before [FakeSystem.now].
final sampleSavedCapture = CaptureRecord(
  id: .new('saved'),
  capturedAtUtc: FakeSystem.now.subtract(const .new(minutes: 20)),
  timeZone: .new(FakeSystem.zone),
  audioPath: .new('saved.m4a'),
  duration: const .new(seconds: 14),
  stage: .saved,
  progress: const .new(markedSaved: true, audioAttached: true, remindersScheduled: {'2'}),
  transcript: _transcript,
  items: [
    .new(
      id: .new('2'),
      sources: [.new(0, 58, .new('Remind me tomorrow at 9 am to book the car in for its MOT.'))],
      kind: .task,
      groupId: .new('home'),
      title: 'Book the car in for its MOT',
      body: '',
      due: const .new(2026, 9, 18, hour: 9, minute: 0),
      reminder: const .new(2026, 9, 18, hour: 9, minute: 0),
    ),
    .new(
      id: .new('6'),
      sources: [
        .new(65, 130, .new('an idea for the garden: tomatoes along the south fence next year.')),
      ],
      kind: .note,
      groupId: .new('ideas'),
      title: 'Tomatoes along the south fence next year',
      body: 'An idea for the garden: tomatoes along the south fence next year.',
    ),
  ],
);

/// The same speech, waiting for review.
final sampleProposedCapture = sampleSavedCapture.copyWith(
  id: .new('proposed'),
  stage: .proposed,
  progress: const .new(),
);
