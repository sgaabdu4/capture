import 'package:capture/core/domain/values/notion_id.dart';
import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/widgets/atoms/paper_dropdown.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:material_ui/material_ui.dart';

/// Picks the group of one proposal item; read-only when [onChanged] is null.
class GroupMenu extends StatelessWidget {
  const GroupMenu({required this.groups, required this.value, required this.onChanged, super.key});

  final List<Group> groups;

  /// Selected group id; null while the user must choose.
  final NotionId? value;
  final ValueChanged<NotionId>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      width: Sizes.groupMenuWidth,
      child: PaperDropdown<NotionId>(
        value: groups.any((g) => g.id == value) ? value : null,
        hint: l10n.groupHint,
        items: [for (final Group(:id, :name) in groups) (value: id, label: name.value)],
        onChanged: onChanged,
      ),
    );
  }
}
