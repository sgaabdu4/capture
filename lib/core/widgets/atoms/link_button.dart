import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:material_ui/material_ui.dart';

/// Quiet text button (e.g. "View all ›").
class LinkButton extends StatelessWidget {
  const LinkButton(
    this.label, {
    required this.onPressed,
    super.key,
    this.icon,
    this.flush = false,
    this.destructive = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  /// Drops the side padding so the text lines up with the content above it.
  final bool flush;

  /// Colours the label with the error role, so a delete reads differently from a cancel beside it.
  final bool destructive;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      minimumSize: const .square(Sizes.tapTarget),
      tapTargetSize: .padded,
      visualDensity: .standard,
      padding: flush ? const .symmetric(vertical: Spacing.xxs) : null,
      alignment: flush ? AlignmentDirectional.centerStart : null,
    ),
    child: Row(
      mainAxisSize: .min,
      children: [
        Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: destructive ? context.colors.error : context.colors.onSurface,
          ),
        ),
        if (icon case final IconData i) ...[
          const SizedBox(width: Spacing.xxs),
          Icon(i, size: IconSizes.s16),
        ],
      ],
    ),
  );
}
