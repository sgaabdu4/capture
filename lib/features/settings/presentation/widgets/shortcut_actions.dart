import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/core/widgets/atoms/line_button.dart';
import 'package:capture/features/settings/domain/entities/shortcut.dart';
import 'package:capture/features/settings/presentation/widgets/shortcut_keys.dart';
import 'package:flutter/material.dart';

/// Recording → a prompt and Cancel; recorded → the keys, Save and Cancel;
/// otherwise the current keys and Record.
class ShortcutActions extends StatelessWidget {
  const ShortcutActions({
    required this.recording,
    required this.recorded,
    required this.current,
    required this.onRecord,
    required this.onStop,
    required this.onSave,
    required this.onDiscard,
    super.key,
  });

  final bool recording;
  final Shortcut? recorded;

  /// Label of the shortcut in use, e.g. "⌃⌥".
  final String current;
  final VoidCallback onRecord;
  final VoidCallback onStop;
  final VoidCallback onSave;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      spacing: Spacing.sm,
      children: switch (recorded) {
        _ when recording => [
          Text(l10n.shortcutListening, style: context.textTheme.bodyMedium),
          LineButton(l10n.cancel, onPressed: onStop),
        ],
        final Shortcut r => [
          ShortcutKeys(r.label),
          InkButton(
            l10n.shortcutSave,
            key: const ValueKey(AppWidgetKeys.shortcutSaveButton),
            onPressed: r.problem == null ? onSave : null,
          ),
          LineButton(l10n.cancel, onPressed: onDiscard),
        ],
        null => [
          ShortcutKeys(current),
          LineButton(
            l10n.shortcutRecord,
            key: const ValueKey(AppWidgetKeys.shortcutChangeButton),
            onPressed: onRecord,
          ),
        ],
      },
    );
  }
}
