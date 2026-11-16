import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/domain/entities/notion_workspace.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/groups/domain/group_rules.dart';
import 'package:capture/features/groups/presentation/notifiers/groups_notifier.dart';
import 'package:capture/features/groups/repositories/groups_repository.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/sample_workspace.dart';

class _Repository extends SampleGroups {
  _Repository({this.failure});
  final NotionFailure? failure;
  final calls = <String>[];

  @override
  List<Group> cached() => [];

  @override
  Future<NotionResult<List<Group>>> refresh(NotionWorkspace ws) async {
    calls.add('refresh');
    return switch (failure) {
      final NotionFailure f => .err(f),
      null => .ok(sampleGroups),
    };
  }

  @override
  Future<NotionResult<Group>> create(NotionWorkspace ws, GroupDraft draft) async {
    calls.add('create');
    return switch (failure) {
      final NotionFailure f => .err(f),
      null => .ok(Group(id: .new('made'), name: .new(draft.name), description: draft.description)),
    };
  }

  @override
  Future<NotionResult<void>> update(Group group) async {
    calls.add('update');
    return switch (failure) {
      final NotionFailure f => .err(f),
      null => const .ok(null),
    };
  }
}

ProviderContainer _container(_Repository repository, {bool connected = true}) => .test(
  overrides: [
    groupsRepositoryProvider.overrideWithValue(repository),
    settingsProvider.overrideWithBuild(
      (ref, notifier) => notifier.build().copyWith(workspace: connected ? sampleWorkspace : null),
    ),
  ],
);

final _ideas = sampleGroups.first;

void main() {
  group('refresh', () {
    test('replaces the groups with those Notion returns', () async {
      final repository = _Repository();
      final container = _container(repository);

      await container.read(groupsProvider.notifier).refresh();

      final state = container.read(groupsProvider);
      expect(state.groups, equals(sampleGroups));
      expect(state.busy, isFalse);
    });

    test('a Notion failure is shown once and clears busy', () async {
      final container = _container(_Repository(failure: .network));

      await container.read(groupsProvider.notifier).refresh();

      final state = container.read(groupsProvider);
      expect(state.failure, equals(NotionFailure.network));
      expect(state.failureSerial, equals(1));
      expect(state.busy, isFalse);
    });

    test('before Notion is connected nothing is asked', () async {
      final repository = _Repository();
      final container = _container(repository, connected: false);

      await container.read(groupsProvider.notifier).refresh();

      expect(repository.calls, isEmpty);
    });
  });

  group('create', () {
    const draft = (name: 'Garden', description: 'Plants and tools.');

    test('adds the new group in name order', () async {
      final container = _container(_Repository());
      container.read(groupsProvider.notifier).reload();
      await container.read(groupsProvider.notifier).refresh();

      await container.read(groupsProvider.notifier).create(draft);

      final names = container.read(groupsProvider).groups.map((g) => g.name.value);
      expect(names, equals(['Garden', 'Home', 'Ideas', 'Learning', 'Work']));
    });

    test('a draft with no name is refused before asking Notion', () async {
      final repository = _Repository();
      final container = _container(repository);

      await container.read(groupsProvider.notifier).create((name: ' ', description: 'x'));

      expect(repository.calls, isEmpty);
    });

    test('a Notion failure is shown once', () async {
      final container = _container(_Repository(failure: .rateLimited));

      await container.read(groupsProvider.notifier).create(draft);

      final state = container.read(groupsProvider);
      expect(state.failure, equals(NotionFailure.rateLimited));
      expect(state.failureSerial, equals(1));
      expect(state.groups, isEmpty);
    });
  });

  group('update', () {
    test('replaces the group and keeps name order', () async {
      final container = _container(_Repository());
      final notifier = container.read(groupsProvider.notifier);
      await notifier.refresh();

      await notifier.update(_ideas.copyWith(name: .new('Zoo')));

      final names = container.read(groupsProvider).groups.map((g) => g.name.value);
      expect(names, equals(['Home', 'Learning', 'Work', 'Zoo']));
    });

    test('a group with no description is not sent', () async {
      final repository = _Repository();
      final container = _container(repository);

      await container.read(groupsProvider.notifier).update(Group(id: .new('x'), name: .new('X')));

      expect(repository.calls, isEmpty);
    });

    test('a name another group already has is refused', () async {
      final repository = _Repository();
      final container = _container(repository);
      final notifier = container.read(groupsProvider.notifier);
      await notifier.refresh();
      repository.calls.clear();

      await notifier.update(_ideas.copyWith(name: .new('home')));

      expect(repository.calls, isEmpty);
    });

    test('a Notion failure is shown once and keeps the old group', () async {
      final container = _container(_Repository(failure: .unavailable));

      await container.read(groupsProvider.notifier).update(_ideas);

      final state = container.read(groupsProvider);
      expect(state.failure, equals(NotionFailure.unavailable));
      expect(state.failureSerial, equals(1));
    });
  });
}
