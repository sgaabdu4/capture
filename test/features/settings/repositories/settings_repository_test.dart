import 'package:capture/core/data/notion/models/notion_workspace_model.dart';
import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/notion/notion_workspace_local_datasource.dart';
import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/capture/data/datasources/jev_remote_datasource.dart';
import 'package:capture/features/groups/repositories/groups_repository.dart';
import 'package:capture/features/settings/data/datasources/notion_workspace_remote_datasource.dart';
import 'package:capture/features/settings/data/datasources/shortcut_local_datasource.dart';
import 'package:capture/features/settings/data/datasources/speech_model_datasource.dart';
import 'package:capture/features/settings/repositories/settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/test_fakes.dart';

class _MockJev extends Mock implements IJevRemoteDatasource {}

class _MockNotion extends Mock implements INotionWorkspaceRemoteDatasource {}

class _MockGroups extends Mock implements IGroupsRepository {}

class _MockShortcuts extends Mock implements IShortcutLocalDatasource {}

class _MockSpeechModel extends Mock implements ISpeechModelDatasource {}

/// The cached workspace, in memory.
class _Cache implements INotionWorkspaceLocalDatasource {
  NotionWorkspaceModel? value;

  @override
  NotionWorkspaceModel? read() => value;

  @override
  void write(NotionWorkspaceModel? workspace) => value = workspace;
}

const _model = NotionWorkspaceModel(
  parentPageId: 'parent',
  areaPageId: 'area',
  groups: 'groups',
  captures: 'captures',
  library: 'library',
  maxUploadBytes: 1,
);

/// Groups that seed without complaint.
_MockGroups _seededGroups() {
  final groups = _MockGroups();
  when(() => groups.seedIfEmpty(any())).thenAnswer((_) async => const .ok([]));
  return groups;
}

/// The repository over [secrets] and [cache], with Jev and Notion answering
/// through the returned mocks.
final class _Fixture {
  final secrets = FakeSecrets();
  final cache = _Cache();
  final jev = _MockJev();
  final notion = _MockNotion();
  final groups = _seededGroups();

  late final repository = SettingsRepository(
    secrets: secrets,
    jev: jev,
    notion: (remote: notion, cache: cache, groups: groups),
    device: (shortcuts: _MockShortcuts(), speechModel: _MockSpeechModel()),
  );

  void notionAnswers(NotionResult<NotionWorkspaceModel> answer) => when(
    () => notion.connect(
      token: any(named: 'token'),
      parentPageId: any(named: 'parentPageId'),
      known: any(named: 'known'),
    ),
  ).thenAnswer((_) async => answer);
}

void main() {
  setUpAll(() => registerFallbackValue(_model.toEntity()));

  test('a TypeSafe key Jev refuses is not stored in the Keychain', () async {
    final f = _Fixture();
    when(() => f.jev.validateKey(any())).thenAnswer((_) async => const .err(.invalidKey));

    await f.repository.saveTypesafeKey('bad-key');

    expect(await f.secrets.read(.typesafeKey), isNull);
  });

  test('a Notion token whose page is not shared is neither stored nor connected', () async {
    final f = _Fixture()..notionAnswers(const .err(.notShared));

    final result = await f.repository.connectNotion(parentPageId: 'parent', token: 'token');

    expect(result, isA<Err<NotionWorkspace, NotionFailure>>());
    expect(await f.secrets.read(.notionToken), isNull);
    expect(f.cache.value, isNull);
  });

  test('a Notion token is stored in the Keychain once the setup under its page works', () async {
    final f = _Fixture()..notionAnswers(const .ok(_model));

    await f.repository.connectNotion(parentPageId: 'parent', token: 'token');

    expect(await f.secrets.read(.notionToken), equals('token'));
    expect(f.cache.value, equals(_model));
  });
}
