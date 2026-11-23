import 'dart:async';

import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:capture/core/widgets/atoms/underlined.dart';
import 'package:capture/features/settings/presentation/widgets/speech_credit_dialog.dart';
import 'package:material_ui/material_ui.dart';

/// What stays on this Mac and what leaves it.
class PrivacySection extends StatelessWidget {
  const PrivacySection({super.key});

  static const _creditRoute = 'speech-credit-dialog';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .start,
      spacing: Spacing.sm,
      children: [
        Underlined(l10n.privacyTitle),
        Text(l10n.privacyBody, style: context.textTheme.bodyMedium),
        LinkButton(
          l10n.speechCreditLink,
          key: const ValueKey(AppWidgetKeys.speechCreditButton),
          flush: true,
          onPressed: () => unawaited(
            showDialog<void>(
              context: context,
              routeSettings: const .new(name: _creditRoute),
              builder: (_) => const SpeechCreditDialog(),
            ),
          ),
        ),
      ],
    );
  }
}
