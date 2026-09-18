import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:capture/core/widgets/atoms/underlined.dart';
import 'package:flutter/material.dart';

/// Underlined card title with an optional "View all ›" link.
class HomeCardHeader extends StatelessWidget {
  const HomeCardHeader({required this.title, super.key, this.onViewAll});

  final String title;

  /// Null hides the link.
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: Align(alignment: AlignmentDirectional.centerStart, child: Underlined(title)),
        ),
        if (onViewAll case final VoidCallback open)
          LinkButton(l10n.viewAll, onPressed: open, icon: Icons.chevron_right),
      ],
    );
  }
}
