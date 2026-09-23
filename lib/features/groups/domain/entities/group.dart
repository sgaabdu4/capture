import 'package:capture/core/domain/values/notion_id.dart';
import 'package:capture/features/groups/domain/values/group_name.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';

/// A user-configured group. [id] is the Notion page id of the Groups entry
/// (stable across renames); library relations always use it.
@freezed
sealed class Group with _$Group {
  const Group._();

  const factory Group({
    required NotionId id,
    required GroupName name,
    String? description,
    @Default(false) bool archived,
  }) = _Group;

  static const unsortedName = 'Unsorted';

  bool get isUnsorted => sameName(unsortedName);

  bool sameName(String other) => name.value.trim().toLowerCase() == other.trim().toLowerCase();
}
