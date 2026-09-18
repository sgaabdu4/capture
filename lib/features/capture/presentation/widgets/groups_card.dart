import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/empty_note.dart';
import 'package:capture/core/widgets/atoms/icon_badge.dart';
import 'package:capture/core/widgets/atoms/tap_surface.dart';
import 'package:capture/features/capture/presentation/widgets/home_card.dart';
import 'package:flutter/material.dart';

/// A few active groups; each row opens Groups.
class GroupsCard extends StatelessWidget {
  const GroupsCard({required this.names, required this.onOpen, super.key});

  final List<String> names;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ink = context.colors.onSurface;
    return HomeCard(
      title: l10n.cardGroups,
      children: [
        if (names.isEmpty) EmptyNote(l10n.emptyGroups),
        for (final (index, name) in names.indexed) ...[
          if (index > 0) const Divider(height: Sizes.hairline),
          TapSurface(
            onTap: onOpen,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
              child: Row(
                spacing: Spacing.md,
                children: [
                  const IconBadge(Icons.folder_open_outlined),
                  Expanded(child: Text(name, style: context.textTheme.bodyMedium)),
                  Icon(Icons.chevron_right, color: ink),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
