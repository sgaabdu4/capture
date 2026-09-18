import 'package:flutter/material.dart';

import '../app/app_model.dart';
import '../services/model_store.dart';
import 'theme.dart';
import 'widgets.dart';

/// Combined first-run setup on Home until everything a capture needs is in
/// place. Each step is also available in Settings.
class SetupPanel extends StatelessWidget {
  const SetupPanel({required this.model, super.key});
  final AppModel model;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 760),
    child: PaperCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Underlined('Before your first capture'),
          const SizedBox(height: 6),
          const Text(
            'Three things, once. Keys stay in your Mac’s Keychain.',
            style: Styles.label,
          ),
          const SizedBox(height: 20),
          ModelStep(model: model),
          const Divider(height: 40),
          TypesafeStep(model: model),
          const Divider(height: 40),
          NotionStep(model: model),
        ],
      ),
    ),
  );
}

class StepHeader extends StatelessWidget {
  const StepHeader({
    required this.done,
    required this.title,
    super.key,
    this.detail,
  });
  final bool done;
  final String title;
  final String? detail;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(
        done ? Icons.check_circle : Icons.radio_button_unchecked,
        color: done ? Palette.ok : Palette.faint,
        size: 24,
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Styles.body.copyWith(fontSize: 21)),
            if (detail != null) Text(detail!, style: Styles.label),
          ],
        ),
      ),
    ],
  );
}

class ModelStep extends StatelessWidget {
  const ModelStep({required this.model, super.key});
  final AppModel model;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model.settings,
    builder: (context, _) {
      final s = model.settings;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            done: s.modelReady,
            title: 'Speech model',
            detail: s.modelReady
                ? 'Parakeet is on this Mac. Recordings are transcribed locally.'
                : 'Download Parakeet (${parakeetTotalBytes ~/ 1000000} MB) '
                      'to transcribe on this Mac.',
          ),
          Padding(
            padding: const EdgeInsets.only(left: 38, top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (s.modelProgress != null) ...[
                  LinearProgressIndicator(
                    value: s.modelProgress,
                    minHeight: 6,
                    color: Palette.ink,
                    backgroundColor: Palette.selected,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  const SizedBox(height: 8),
                  Text(s.modelStatus ?? '', style: Styles.label),
                ] else if (!s.modelReady)
                  InkButton(
                    s.modelError == null ? 'Download' : 'Retry download',
                    onPressed: s.downloadModel,
                  ),
                if (s.modelError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    s.modelError!,
                    style: Styles.label.copyWith(color: Palette.error),
                  ),
                ],
                const SizedBox(height: 10),
                const Text(modelAttribution, style: Styles.small),
              ],
            ),
          ),
        ],
      );
    },
  );
}

class TypesafeStep extends StatefulWidget {
  const TypesafeStep({required this.model, super.key});
  final AppModel model;

  @override
  State<TypesafeStep> createState() => _TypesafeStepState();
}

class _TypesafeStepState extends State<TypesafeStep> {
  final _key = TextEditingController();
  String? _error;
  var _busy = false;

  @override
  void dispose() {
    _key.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    final error = await widget.model.settings.saveTypesafeKey(_key.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = error;
      if (error == null) _key.clear();
    });
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.model.settings,
    builder: (context, _) {
      final has = widget.model.settings.hasTypesafeKey;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            done: has,
            title: 'TypeSafe API key',
            detail: has
                ? 'Saved in Keychain. Only transcript text is sent to Jev to sort it.'
                : 'Jev sorts the transcript into notes and tasks. Get a key at '
                      'console.typesafe.ai.',
          ),
          Padding(
            padding: const EdgeInsets.only(left: 38, top: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _key,
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      hintText: has
                          ? 'Paste a new key to replace it'
                          : 'Paste your key',
                      errorText: _error,
                    ),
                    onSubmitted: (_) => _save(),
                  ),
                ),
                const SizedBox(width: 12),
                InkButton(
                  has ? 'Replace' : 'Save',
                  onPressed: _save,
                  busy: _busy,
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

class NotionStep extends StatefulWidget {
  const NotionStep({required this.model, super.key});
  final AppModel model;

  @override
  State<NotionStep> createState() => _NotionStepState();
}

class _NotionStepState extends State<NotionStep> {
  final _token = TextEditingController();
  final _page = TextEditingController();
  String? _error;
  var _busy = false;

  @override
  void dispose() {
    _token.dispose();
    _page.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    setState(() => _busy = true);
    final error = await widget.model.settings.connectNotion(
      _token.text,
      _page.text,
    );
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = error;
      if (error == null) _token.clear();
    });
    if (error == null) await widget.model.library.refresh();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.model.settings,
    builder: (context, _) {
      final s = widget.model.settings;
      final ws = s.workspace;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            done: s.notionConnected,
            title: 'Notion',
            detail: s.notionConnected
                ? 'Connected to ${ws!.workspaceName.isEmpty ? 'your workspace' : ws.workspaceName}. '
                      'Captures, Library and Groups live in the “Capture” page '
                      'inside the page you chose.'
                : 'Create an internal connection in Notion (Settings → '
                      'Connections → Develop or manage connections), share one page '
                      'with it (••• → Connections → Add connection), then paste '
                      'its token and the page link.',
          ),
          Padding(
            padding: const EdgeInsets.only(left: 38, top: 12),
            child: Column(
              children: [
                TextField(
                  controller: _token,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    hintText: s.hasNotionToken
                        ? 'Paste a new token to replace it'
                        : 'Internal connection token (ntn_…)',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _page,
                        decoration: InputDecoration(
                          hintText: 'Link to the Notion page Capture may use',
                          errorText: _error,
                          errorMaxLines: 3,
                        ),
                        onSubmitted: (_) => _connect(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkButton(
                      s.notionConnected ? 'Reconnect' : 'Connect',
                      onPressed: _connect,
                      busy: _busy,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
