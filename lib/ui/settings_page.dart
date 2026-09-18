import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/app_model.dart';
import '../domain/shortcut.dart';
import 'setup_panel.dart';
import 'theme.dart';
import 'widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({required this.model, super.key});
  final AppModel model;

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Settings',
    children: [
      PaperCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ModelStep(model: model),
            const Divider(height: 40),
            TypesafeStep(model: model),
            const Divider(height: 40),
            NotionStep(model: model),
          ],
        ),
      ),
      const SizedBox(height: 20),
      PaperCard(child: _ShortcutSection(model: model)),
      const SizedBox(height: 20),
      PaperCard(child: _MicSection(model: model)),
      const SizedBox(height: 20),
      const PaperCard(child: _Privacy()),
    ],
  );
}

class _ShortcutSection extends StatefulWidget {
  const _ShortcutSection({required this.model});
  final AppModel model;

  @override
  State<_ShortcutSection> createState() => _ShortcutSectionState();
}

class _ShortcutSectionState extends State<_ShortcutSection> {
  final _focus = FocusNode();
  var _listening = false;
  String? _error;

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (!_listening || event is! KeyDownEvent) return KeyEventResult.ignored;
    final label = event.logicalKey.keyLabel.toUpperCase();
    if (!carbonKeyCodes.containsKey(label)) return KeyEventResult.handled;
    final keys = HardwareKeyboard.instance;
    final shortcut = Shortcut(
      label,
      modifiers: {
        if (keys.isControlPressed) Modifier.control,
        if (keys.isAltPressed) Modifier.option,
        if (keys.isShiftPressed) Modifier.shift,
        if (keys.isMetaPressed) Modifier.command,
      },
    );
    setState(() => _listening = false);
    widget.model.settings.setShortcut(shortcut).then((error) {
      if (mounted) setState(() => _error = error);
    });
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.model.settings,
    builder: (context, _) {
      final s = widget.model.settings;
      return Focus(
        focusNode: _focus,
        onKeyEvent: _onKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepHeader(
              done: s.shortcutRegistered,
              title: 'Shortcut',
              detail: s.shortcutRegistered
                  ? 'Press ${s.shortcut.label} in any app to start and stop a capture.'
                  : '${s.shortcut.label} is taken by another app. Choose another.',
            ),
            Padding(
              padding: const EdgeInsets.only(left: 38, top: 12),
              child: Row(
                children: [
                  LineButton(
                    _listening ? 'Press the new shortcut…' : 'Change shortcut',
                    onPressed: () {
                      setState(() {
                        _listening = true;
                        _error = null;
                      });
                      _focus.requestFocus();
                    },
                  ),
                  const SizedBox(width: 12),
                  if (_error != null)
                    Expanded(
                      child: Text(
                        _error!,
                        style: Styles.label.copyWith(color: Palette.error),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _MicSection extends StatelessWidget {
  const _MicSection({required this.model});
  final AppModel model;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model.settings,
    builder: (context, _) {
      final status = model.settings.micPermission;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            done: status == 'granted',
            title: 'Microphone',
            detail: switch (status) {
              'granted' =>
                'Allowed. The microphone is on only while the pill shows.',
              'denied' => 'Blocked. Allow Capture in System Settings → Privacy & Security → Microphone.',
              _ => 'macOS will ask the first time you record.',
            },
          ),
          if (status == 'undetermined')
            Padding(
              padding: const EdgeInsets.only(left: 38, top: 12),
              child: LineButton(
                'Allow microphone',
                onPressed: model.settings.ensureMic,
              ),
            ),
        ],
      );
    },
  );
}

class _Privacy extends StatelessWidget {
  const _Privacy();

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Underlined('Privacy'),
      SizedBox(height: 12),
      Text(
        'Audio is recorded and transcribed on this Mac. Only the transcript '
        'text and your group descriptions go to TypeSafe (Jev) for sorting. '
        'Nothing reaches Notion until you approve it. Keys live in the macOS '
        'Keychain. No analytics, no logs of your words.',
        style: Styles.body,
      ),
    ],
  );
}
