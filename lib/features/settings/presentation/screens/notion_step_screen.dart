import 'dart:async';

import 'package:capture/core/crash/crash.dart';
import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/core/widgets/atoms/link_button.dart';
import 'package:capture/features/settings/presentation/widgets/step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Completes with true once Notion is connected.
typedef NotionConnect = Future<bool> Function({required String token, required String pageLink});

/// Obscure and clear the connection token after storage; never show or log its text.
class NotionStepScreen extends ConsumerStatefulWidget {
  const NotionStepScreen({
    required this.connected,
    required this.workspaceName,
    required this.hasToken,
    required this.connecting,
    required this.error,
    required this.onConnect,
    required this.onShowGuide,
    super.key,
  });

  final bool connected;

  /// Shown in "Connected to …".
  final String workspaceName;
  final bool hasToken;
  final bool connecting;

  /// Why the last attempt failed, if it did.
  final String? error;
  final NotionConnect onConnect;

  /// Opens the pictured guide to creating the connection.
  final VoidCallback onShowGuide;

  @override
  ConsumerState<NotionStepScreen> createState() => _NotionStepScreenState();
}

class _NotionStepScreenState extends ConsumerState<NotionStepScreen> {
  final _token = TextEditingController();
  final _page = TextEditingController();
  bool _tokenMissing = false;

  static const _errorLines = 3;

  @override
  void dispose() {
    _token.dispose();
    _page.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    final context = this.context;
    final missing = _token.text.trim().isEmpty && !widget.hasToken;
    setState(() => _tokenMissing = missing);
    if (missing) return;
    final connected = await widget.onConnect(token: _token.text, pageLink: _page.text);
    if (!context.mounted) return;
    if (connected) _token.clear();
  }

  void _onConnect() => unawaited(_connect().catchError(Crash.error));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final connected = widget.connected;
    return Column(
      crossAxisAlignment: .start,
      children: [
        StepHeader(
          done: connected,
          title: l10n.notionTitle,
          detail: connected ? l10n.notionConnectedTo(widget.workspaceName) : l10n.notionNeeded,
        ),
        Padding(
          padding: StepHeader.bodyInset,
          child: Column(
            crossAxisAlignment: .start,
            spacing: Spacing.xs,
            children: [
              LinkButton(
                l10n.notionShowMe,
                key: const ValueKey(AppWidgetKeys.notionGuideButton),
                icon: Icons.help_outline,
                onPressed: widget.onShowGuide,
              ),
              TextField(
                key: const ValueKey(AppWidgetKeys.notionTokenField),
                controller: _token,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                decoration: .new(
                  hintText: widget.hasToken ? l10n.notionTokenHintReplace : l10n.notionTokenHintNew,
                ),
              ),
              Row(
                spacing: Spacing.sm,
                children: [
                  Expanded(
                    child: TextField(
                      key: const ValueKey(AppWidgetKeys.notionPageField),
                      controller: _page,
                      decoration: .new(
                        hintText: l10n.notionPageHint,
                        errorText: _tokenMissing ? l10n.notionTokenMissing : widget.error,
                        errorMaxLines: _errorLines,
                      ),
                      onSubmitted: (_) => _onConnect(),
                    ),
                  ),
                  InkButton(
                    connected ? l10n.reconnect : l10n.connect,
                    key: const ValueKey(AppWidgetKeys.notionConnectButton),
                    onPressed: _onConnect,
                    busy: widget.connecting,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
