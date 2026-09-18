import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/settings/domain/entities/modifier.dart';
import 'package:capture/features/settings/domain/entities/shortcut.dart';
import 'package:capture/features/settings/domain/entities/shortcut_problem.dart';
import 'package:capture/features/settings/presentation/extensions/settings_labels.dart';
import 'package:capture/features/settings/presentation/widgets/shortcut_actions.dart';
import 'package:capture/features/settings/presentation/widgets/step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shows the global shortcut and records a new one: a key with modifiers,
/// or modifiers alone pressed together and released. Nothing changes until
/// the recorded shortcut is saved.
class ShortcutSection extends StatefulWidget {
  const ShortcutSection({
    required this.label,
    required this.registered,
    required this.problem,
    required this.onShortcut,
    required this.onRecording,
    super.key,
  });

  /// Current shortcut, e.g. "⌃⌥".
  final String label;
  final bool registered;

  /// Why the last shortcut was refused, if it was.
  final ShortcutProblem? problem;
  final ValueChanged<Shortcut> onShortcut;

  /// True while keys are being recorded, so the current shortcut can pause.
  final ValueChanged<bool> onRecording;

  @override
  State<ShortcutSection> createState() => _ShortcutSectionState();
}

class _ShortcutSectionState extends State<ShortcutSection> {
  final _focus = FocusNode();
  bool _recording = false;

  /// Every modifier held since recording started.
  Set<Modifier> _held = {};
  Shortcut? _recorded;

  static final _modifierKeys = {
    LogicalKeyboardKey.controlLeft: Modifier.control,
    LogicalKeyboardKey.controlRight: Modifier.control,
    LogicalKeyboardKey.altLeft: Modifier.option,
    LogicalKeyboardKey.altRight: Modifier.option,
    LogicalKeyboardKey.shiftLeft: Modifier.shift,
    LogicalKeyboardKey.shiftRight: Modifier.shift,
    LogicalKeyboardKey.metaLeft: Modifier.command,
    LogicalKeyboardKey.metaRight: Modifier.command,
  };

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  void _setRecording(bool recording) {
    setState(() {
      _recording = recording;
      _held = {};
      if (recording) _recorded = null;
    });
    widget.onRecording(recording);
    if (recording) _focus.requestFocus();
  }

  void _start() => _setRecording(true);

  void _stop() => _setRecording(false);

  void _finish(Shortcut recorded) {
    _stop();
    setState(() => _recorded = recorded);
  }

  void _discard() => setState(() => _recorded = null);

  void _save() {
    if (_recorded case final Shortcut recorded) {
      _discard();
      widget.onShortcut(recorded);
    }
  }

  static Set<Modifier> _pressedModifiers() => {
    for (final key in HardwareKeyboard.instance.logicalKeysPressed) ?_modifierKeys[key],
  };

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (!_recording) return .ignored;
    final held = _pressedModifiers();
    switch (event) {
      case KeyDownEvent(logicalKey: .escape):
        _stop();
      case KeyDownEvent(:final logicalKey) when _modifierKeys.containsKey(logicalKey):
        _held = {..._held, ...held};
      case KeyDownEvent():
        _finish(.new(event.logicalKey.keyLabel.toUpperCase(), modifiers: held));
      case KeyUpEvent() when held.isEmpty && _held.isNotEmpty:
        _finish(.new(null, modifiers: _held));
      case _:
    }
    return .handled;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ShortcutSection(:label, :registered, :problem) = widget;
    final recorded = _recorded;
    final error = switch (recorded) {
      final Shortcut r => r.problem,
      null when !_recording => problem,
      null => null,
    };
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
            child: Column(
              crossAxisAlignment: .start,
              spacing: Spacing.sm,
              children: [
                ShortcutActions(
                  recording: _recording,
                  recorded: recorded,
                  current: label,
                  onRecord: _start,
                  onStop: _stop,
                  onSave: _save,
                  onDiscard: _discard,
                ),
                if (error case final ShortcutProblem refused)
                  Text(
                    refused.label(l10n),
                    style: context.textTheme.labelMedium?.copyWith(color: context.colors.error),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
