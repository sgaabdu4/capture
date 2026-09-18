import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';

/// A user-configured group. [id] is the Notion page id of the Groups entry
/// (stable across renames); library relations always use it.
@freezed
sealed class Group with _$Group {
  const Group._();

  const factory Group({
    required String id,
    required String name,
    required String description,
    @Default(false) bool archived,
  }) = _Group;

  static const unsortedName = 'Unsorted';

  bool get isUnsorted => sameName(unsortedName);

  bool sameName(String other) => name.trim().toLowerCase() == other.trim().toLowerCase();
}
