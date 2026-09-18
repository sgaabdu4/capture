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
const sampleWorkspace = NotionWorkspace(
  parentPageId: 'parent',
  areaPageId: 'area',
  groups: 'groups',
  captures: 'captures',
  library: 'library',
  maxUploadBytes: 5242880,
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

const sampleGroups = [
  Group(
    id: 'ideas',
    name: 'Ideas',
    description: 'Possible products, improvements and things to explore.',
  ),
  Group(id: 'home', name: 'Home', description: 'Household jobs, family and personal errands.'),
  Group(id: 'learning', name: 'Learning', description: 'Things read, watched or worth studying.'),
  Group(
    id: 'work',
    name: 'Work',
    description: 'Meetings, follow-ups and professional commitments.',
  ),
];

/// [sampleGroups], unchanged by Notion.
class SampleGroups implements IGroupsRepository {
  @override
  List<Group> cached() => sampleGroups;

  @override
  Future<NotionResult<List<Group>>> refresh(NotionWorkspace ws) async => const .ok(sampleGroups);

  @override
  Future<NotionResult<List<Group>>> seedIfEmpty(NotionWorkspace ws) async =>
      const .ok(sampleGroups);

  @override
  Future<NotionResult<Group>> create(NotionWorkspace ws, GroupDraft draft) async =>
      .ok(.new(id: 'new', name: draft.name, description: draft.description));

  @override
  Future<NotionResult<void>> update(Group group) async => const .ok(null);
}

/// Title of the first saved task.
const sampleTaskTitle = 'Water the tomato seedlings';

const sampleEntries = [
  LibraryEntry(
    pageId: '1',
    itemId: '1',
    title: sampleTaskTitle,
    kind: .task,
    groupId: 'home',
    due: .new(2026, 9, 17, hour: 20, minute: 0),
  ),
  LibraryEntry(
    pageId: '2',
    itemId: '2',
    title: 'Book the car in for its MOT',
    kind: .task,
    groupId: 'home',
    due: .new(2026, 9, 18, hour: 9, minute: 0),
    reminder: .new(2026, 9, 18, hour: 9, minute: 0),
  ),
  LibraryEntry(
    pageId: '3',
    itemId: '3',
    title: 'Send Priya the sprint notes and the list of open questions from Thursday',
    kind: .task,
    groupId: 'work',
    due: .new(2026, 9, 18, hour: 14, minute: 0),
  ),
  LibraryEntry(
    pageId: '4',
    itemId: '4',
    title: 'Read the chapter on Rust lifetimes',
    kind: .task,
    groupId: 'learning',
  ),
  LibraryEntry(
    pageId: '5',
    itemId: '5',
    title: 'A tiny app that sorts spoken notes',
    kind: .note,
    groupId: 'ideas',
  ),
  LibraryEntry(
    pageId: '6',
    itemId: '6',
    title: 'Tomatoes along the south fence next year',
    kind: .note,
    groupId: 'ideas',
  ),
];

/// [sampleEntries]; edits and deletes succeed without changing them.
class SampleLibrary implements ILibraryRepository {
  @override
  List<LibraryEntry> cached() => sampleEntries;

  @override
  Future<NotionResult<List<LibraryEntry>>> refresh(NotionWorkspace ws) async =>
      const .ok(sampleEntries);

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
  id: 'saved',
  capturedAtUtc: FakeSystem.now.subtract(const .new(minutes: 20)),
  timeZone: FakeSystem.zone,
  audioPath: 'saved.m4a',
  duration: const .new(seconds: 14),
  stage: .saved,
  progress: const .new(markedSaved: true, audioAttached: true, remindersScheduled: {'2'}),
  transcript: _transcript,
  items: const [
    .new(
      id: '2',
      sources: [.new(0, 58, 'Remind me tomorrow at 9 am to book the car in for its MOT.')],
      kind: .task,
      groupId: 'home',
      title: 'Book the car in for its MOT',
      body: '',
      due: .new(2026, 9, 18, hour: 9, minute: 0),
      reminder: .new(2026, 9, 18, hour: 9, minute: 0),
    ),
    .new(
      id: '6',
      sources: [.new(65, 130, 'an idea for the garden: tomatoes along the south fence next year.')],
      kind: .note,
      groupId: 'ideas',
      title: 'Tomatoes along the south fence next year',
      body: 'An idea for the garden: tomatoes along the south fence next year.',
    ),
  ],
);

/// The same speech, waiting for review.
final sampleProposedCapture = sampleSavedCapture.copyWith(
  id: 'proposed',
  stage: .proposed,
  progress: const .new(),
);
