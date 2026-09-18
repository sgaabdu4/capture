import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/line_button.dart';
import 'package:capture/features/settings/domain/entities/shortcut.dart';
import 'package:capture/features/settings/domain/entities/shortcut_problem.dart';
import 'package:capture/features/settings/presentation/extensions/settings_labels.dart';
import 'package:capture/features/settings/presentation/widgets/step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shows the global shortcut and records a new one from the next key press.
class ShortcutSection extends StatefulWidget {
  const ShortcutSection({
    required this.label,
    required this.registered,
    required this.problem,
    required this.onShortcut,
    super.key,
  });

  /// Current shortcut, e.g. "⌃⌥R".
  final String label;
  final bool registered;

  /// Why the last shortcut was refused, if it was.
  final ShortcutProblem? problem;
  final ValueChanged<Shortcut> onShortcut;

  @override
  State<ShortcutSection> createState() => _ShortcutSectionState();
}

class _ShortcutSectionState extends State<ShortcutSection> {
  final _focus = FocusNode();
  bool _listening = false;

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  void _listen() {
    setState(() => _listening = true);
    _focus.requestFocus();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (!_listening || event is! KeyDownEvent) return .ignored;
    final key = event.logicalKey.keyLabel.toUpperCase();
    if (!Shortcut.carbonKeyCodes.containsKey(key)) return .handled;
    final HardwareKeyboard(:isControlPressed, :isAltPressed, :isShiftPressed, :isMetaPressed) =
        HardwareKeyboard.instance;
    setState(() => _listening = false);
    widget.onShortcut(
      .new(
        key,
        modifiers: {
          if (isControlPressed) .control,
          if (isAltPressed) .option,
          if (isShiftPressed) .shift,
          if (isMetaPressed) .command,
        },
      ),
    );
    return .handled;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ShortcutSection(:label, :registered, :problem) = widget;
    return Focus(
      focusNode: _focus,
      onKeyEvent: _onKey,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          StepHeader(
            done: registered,
            title: l10n.shortcutTitle,
            detail: registered ? l10n.shortcutActive(label) : l10n.shortcutInactive(label),
          ),
          Padding(
            padding: StepHeader.bodyInset,
            child: Row(
              spacing: Spacing.sm,
              children: [
                LineButton(
                  _listening ? l10n.shortcutListening : l10n.shortcutChange,
                  key: const ValueKey(AppWidgetKeys.shortcutChangeButton),
                  onPressed: _listen,
                ),
                if (problem case final ShortcutProblem refused when !_listening)
                  Expanded(
                    child: Text(
                      refused.label(l10n),
                      style: context.textTheme.labelMedium?.copyWith(color: context.colors.error),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
