import 'package:capture/core/domain/values/notion_id.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/groups/domain/entities/group_problem.dart';

typedef GroupDraft = ({String name, String description});

/// Suggested, editable defaults created with the library.
const List<GroupDraft> defaultGroups = [
  (
    name: 'Tech',
    description: 'Learning and observations about programming, software, AI and technical tools. Excludes speculative new product proposals unless they are mainly technical learning.',
  ),
  (
    name: 'Personal',
    description: 'Daily life, family, friends, household matters and personal reflections.',
  ),
  (
    name: 'Work',
    description: 'Work-related administration, team discussions and professional commitments.',
  ),
  (
    name: 'Ideas',
    description: 'Possible products, improvements and things to explore without necessarily committing to a task.',
  ),
  (
    name: Group.unsortedName,
    description: 'None of the other groups fits, or the user needs to choose.',
  ),
];

/// Longest group name Notion titles and the review card show comfortably.
const maxGroupNameLength = 60;

/// Why a group edit is invalid, or null when it can be saved.
GroupProblem? groupProblem(GroupDraft draft, Iterable<Group> existing, {NotionId? editingId}) {
  final name = draft.name.trim();
  if (name.isEmpty) return .nameMissing;
  if (name.length > maxGroupNameLength) return .nameTooLong;
  if (draft.description.trim().isEmpty) return .descriptionMissing;
  final duplicate = existing.any((g) => g.id != editingId && g.sameName(name));
  return duplicate ? .duplicateName : null;
}
