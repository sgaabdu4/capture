import 'dart:async';

import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/capture/presentation/extensions/capture_labels.dart';
import 'package:capture/features/settings/data/datasources/speech_model_datasource.dart';
import 'package:capture/features/settings/presentation/extensions/settings_labels.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_notifier.dart';
import 'package:capture/features/settings/presentation/notifiers/settings_state.dart';
import 'package:capture/features/settings/presentation/widgets/model_step.dart';
import 'package:capture/features/settings/presentation/widgets/notion_step.dart';
import 'package:capture/features/settings/presentation/widgets/typesafe_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Speech model, TypeSafe key and Notion steps, shared by the Home setup
/// panel and Settings.
class SetupStepsScreen extends ConsumerWidget {
  const SetupStepsScreen({super.key});

  static const _dividerHeight = Spacing.xl + Spacing.xs;

  Future<bool> _saveKey(BuildContext context, WidgetRef ref, String key) async {
    await ref.read(settingsProvider.notifier).saveTypesafeKey(key);
    if (!context.mounted) return false;
    final SettingsState(:hasTypesafeKey, :keyFailure) = ref.read(settingsProvider);
    return hasTypesafeKey && keyFailure == null;
  }

  Future<bool> _connect(
    BuildContext context,
    WidgetRef ref, {
    required String token,
    required String pageLink,
  }) async {
    await ref.read(settingsProvider.notifier).connectNotion(token: token, pageLink: pageLink);
    if (!context.mounted) return false;
    final SettingsState(:notionConnected, :notionFailure, :pageLinkInvalid) = ref.read(
      settingsProvider,
    );
    return notionConnected && notionFailure == null && !pageLinkInvalid;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final (:modelReady, :modelDownload) = ref.watch(
      settingsProvider.select((s) => (modelReady: s.modelReady, modelDownload: s.modelDownload)),
    );
    final (:hasKey, :savingKey, :keyFailure) = ref.watch(
      settingsProvider.select(
        (s) => (hasKey: s.hasTypesafeKey, savingKey: s.savingKey, keyFailure: s.keyFailure),
      ),
    );
    final (:connected, :name, :hasToken) = ref.watch(
      settingsProvider.select(
        (s) => (
          connected: s.notionConnected,
          name: s.workspace?.workspaceName,
          hasToken: s.hasNotionToken,
        ),
      ),
    );
    final (:connecting, :failure, :linkInvalid) = ref.watch(
      settingsProvider.select(
        (s) => (connecting: s.connecting, failure: s.notionFailure, linkInvalid: s.pageLinkInvalid),
      ),
    );
    return Column(
      crossAxisAlignment: .start,
      children: [
        ModelStep(
          ready: modelReady,
          download: modelDownload,
          totalBytes: parakeetTotalBytes,
          onDownload: () => ref.read(settingsProvider.notifier).downloadModel(),
        ),
        const Divider(height: _dividerHeight),
        TypesafeStep(
          hasKey: hasKey,
          saving: savingKey,
          error: keyFailure?.label(l10n),
          onSave: (key) => _saveKey(context, ref, key),
        ),
        const Divider(height: _dividerHeight),
        NotionStep(
          connected: connected,
          workspaceName: switch (name) {
            final String n when n.isNotEmpty => n,
            _ => l10n.notionYourWorkspace,
          },
          hasToken: hasToken,
          connecting: connecting,
          error: linkInvalid ? l10n.notionPageMissing : failure?.label(l10n),
          onConnect: ({required token, required pageLink}) =>
              _connect(context, ref, token: token, pageLink: pageLink),
        ),
      ],
    );
  }
}
