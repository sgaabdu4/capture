import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:material_ui/material_ui.dart';

/// Paper-styled modal dialog with a handwritten title.
class PaperDialog extends StatelessWidget {
  const PaperDialog({
    required this.title,
    required this.content,
    super.key,
    this.actions = const [],
    this.scrollable = false,
    this.insetPadding,
    this.width = Sizes.dialogWidth,
  });

  final String title;
  final Widget content;
  final List<Widget> actions;
  final bool scrollable;
  final EdgeInsets? insetPadding;

  /// The widest the content may be.
  final double width;

  @override
  Widget build(BuildContext context) => AlertDialog(
    scrollable: scrollable,
    insetPadding: insetPadding,
    title: Text(title, style: context.textTheme.titleMedium),
    content: ConstrainedBox(
      constraints: .new(maxWidth: width),
      child: content,
    ),
    actions: actions.isEmpty ? null : actions,
  );
}
