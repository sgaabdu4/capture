import 'dart:async';

import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/features/settings/presentation/widgets/step_header.dart';
import 'package:flutter/material.dart';

/// Saves the TypeSafe API key. The field is obscured and cleared once the
/// key is stored; its text is never shown or logged.
class TypesafeStep extends StatefulWidget {
  const TypesafeStep({
    required this.hasKey,
    required this.saving,
    required this.error,
    required this.onSave,
    super.key,
  });

  final bool hasKey;
  final bool saving;

  /// Why the last save failed, if it did.
  final String? error;

  /// Completes with true once the key is stored.
  final Future<bool> Function(String key) onSave;

  @override
  State<TypesafeStep> createState() => _TypesafeStepState();
}

class _TypesafeStepState extends State<TypesafeStep> {
  final _key = TextEditingController();
  bool _missing = false;

  @override
  void dispose() {
    _key.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final context = this.context;
    final empty = _key.text.trim().isEmpty;
    setState(() => _missing = empty);
    if (empty) return;
    final saved = await widget.onSave(_key.text);
    if (!context.mounted) return;
    if (saved) _key.clear();
  }

  void _onSave() => unawaited(_save());

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final has = widget.hasKey;
    return Column(
      crossAxisAlignment: .start,
      children: [
        StepHeader(
          done: has,
          title: l10n.typesafeTitle,
          detail: has ? l10n.typesafeSaved : l10n.typesafeNeeded,
        ),
        Padding(
          padding: StepHeader.bodyInset,
          child: Row(
            spacing: Spacing.sm,
            children: [
              Expanded(
                child: TextField(
                  key: const ValueKey(AppWidgetKeys.typesafeKeyField),
                  controller: _key,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: .new(
                    hintText: has ? l10n.typesafeHintReplace : l10n.typesafeHintNew,
                    errorText: _missing ? l10n.typesafeKeyMissing : widget.error,
                  ),
                  onSubmitted: (_) => _onSave(),
                ),
              ),
              InkButton(
                has ? l10n.replace : l10n.save,
                key: const ValueKey(AppWidgetKeys.typesafeSaveButton),
                onPressed: _onSave,
                busy: widget.saving,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
