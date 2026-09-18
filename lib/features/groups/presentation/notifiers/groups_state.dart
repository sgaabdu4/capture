import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'groups_state.freezed.dart';

@freezed
sealed class GroupsState with _$GroupsState {
  const GroupsState._();

  const factory GroupsState({
    /// Sorted by name; archived groups included.
    required List<Group> groups,
    @Default(false) bool busy,
    NotionFailure? failure,

    /// Bumped with each failure so the screen shows it once.
    @Default(0) int failureSerial,
  }) = _GroupsState;

  List<Group> get active => [
    for (final g in groups)
      if (!g.archived) g,
  ];

  List<Group> get archived => [
    for (final g in groups)
      if (g.archived) g,
  ];

  Group? byId(String? id) => groups.where((g) => g.id == id).firstOrNull;
}
