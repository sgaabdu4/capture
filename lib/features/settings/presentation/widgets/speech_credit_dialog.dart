import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:capture/core/widgets/paper_dialog.dart';
import 'package:material_ui/material_ui.dart';

/// Who made the speech model and under which licence.
class SpeechCreditDialog extends StatelessWidget {
  const SpeechCreditDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PaperDialog(
      title: l10n.speechCreditLink,
      scrollable: true,
      content: Text(l10n.modelAttribution, style: context.textTheme.bodyMedium),
      actions: [LinkButton(l10n.close, flush: true, onPressed: () => Navigator.of(context).pop())],
    );
  }
}
