import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:capture/features/settings/presentation/widgets/step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Obscure and clear the API key after storage; never show or log its text.
class TypesafeStepScreen extends ConsumerStatefulWidget {
  const TypesafeStepScreen({
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

  final ValueChanged<String> onSave;

  @override
  ConsumerState<TypesafeStepScreen> createState() => _TypesafeStepScreenState();
}

class _TypesafeStepScreenState extends ConsumerState<TypesafeStepScreen> {
  final _key = TextEditingController();
  bool _missing = false;

  @override
  void dispose() {
    _key.dispose();
    super.dispose();
  }

  void _onSave() {
    final empty = _key.text.trim().isEmpty;
    setState(() => _missing = empty);
    if (empty) return;
    widget.onSave(_key.text);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(settingsProvider.select((s) => s.keySavedSerial), (_, _) => _key.clear());
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
