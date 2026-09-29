import 'package:capture/core/crash/crash.dart';
import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/groups/domain/group_rules.dart';
import 'package:capture/features/groups/presentation/notifiers/groups_state.dart';
import 'package:capture/features/groups/repositories/groups_repository.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'groups_notifier.g.dart';

/// Archive groups instead of deleting them so existing library relations stay valid.
@Riverpod(keepAlive: true)
class GroupsNotifier extends _$GroupsNotifier {
  @override
  GroupsState build() => .new(groups: ref.read(groupsRepositoryProvider).cached());

  IGroupsRepository _ensureRepository() => ref.read(groupsRepositoryProvider);

  /// Re-reads the local cache (after Notion setup seeded it).
  void reload() => state = state.copyWith(groups: _ensureRepository().cached());

  void _markBusy() => state = state.copyWith(busy: true);

  Future<void> refresh() async {
    try {
      final ws = ref.read(settingsProvider).workspace;
      if (ws == null || state.busy) return;
      _markBusy();
      final result = await _ensureRepository().refresh(ws);
      if (!ref.mounted) return;
      state = switch (result) {
        Ok(:final value) => state.copyWith(busy: false, groups: value),
        Err(:final failure) => _failed(failure),
      };
    } catch (error, stackTrace) {
      _crashed(error, stackTrace);
    }
  }

  /// [draft] is validated by the dialog with [groupProblem] first.
  Future<void> create(GroupDraft draft) async {
    try {
      final ws = ref.read(settingsProvider).workspace;
      if (ws == null || state.busy || groupProblem(draft, state.groups) != null) return;
      _markBusy();
      final result = await _ensureRepository().create(ws, draft);
      if (!ref.mounted) return;
      state = switch (result) {
        Ok(:final value) => state.copyWith(busy: false, groups: _sorted([...state.groups, value])),
        Err(:final failure) => _failed(failure),
      };
    } catch (error, stackTrace) {
      _crashed(error, stackTrace);
    }
  }

  Future<void> update(Group group) async {
    try {
      final Group(:id, :name, :description) = group;
      if (description == null) return;
      final GroupDraft draft = (name: name.value, description: description);
      if (state.busy || groupProblem(draft, state.groups, editingId: id) != null) return;
      _markBusy();
      final result = await _ensureRepository().update(group);
      if (!ref.mounted) return;
      state = switch (result) {
        Ok() => state.copyWith(
          busy: false,
          groups: _sorted([for (final g in state.groups) g.id == group.id ? group : g]),
        ),
        Err(:final failure) => _failed(failure),
      };
    } catch (error, stackTrace) {
      _crashed(error, stackTrace);
    }
  }

  void _crashed(Object error, StackTrace stackTrace) {
    Crash.error(error, stackTrace);
    if (!ref.mounted) return;
    state = state.copyWith(busy: false);
  }

  GroupsState _failed(NotionFailure failure) =>
      state.copyWith(busy: false, failure: failure, failureSerial: state.failureSerial + 1);

  static List<Group> _sorted(Iterable<Group> groups) =>
      groups.toList()
        ..sort((a, b) => a.name.value.toLowerCase().compareTo(b.name.value.toLowerCase()));
}
