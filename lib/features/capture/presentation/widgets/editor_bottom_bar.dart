import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/testing/app_widget_keys.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/core/widgets/atoms/ink_button.dart';
import 'package:capture/core/widgets/atoms/line_button.dart';
import 'package:capture/features/capture/domain/entities/approval_problem.dart';
import 'package:capture/features/capture/domain/entities/capture_failure.dart';
import 'package:capture/features/capture/domain/entities/capture_stage.dart';
import 'package:capture/features/capture/presentation/extensions/capture_labels.dart';
import 'package:flutter/material.dart';

/// What blocks the save (or the last failure), with Don't save / Save.
class EditorBottomBar extends StatelessWidget {
  const EditorBottomBar({
    required this.stage,
    required this.problems,
    required this.failure,
    required this.saving,
    required this.onDontSave,
    required this.onSave,
    super.key,
  });

  final CaptureStage stage;
  final Set<ApprovalProblem> problems;
  final CaptureFailure? failure;
  final bool saving;
  final VoidCallback onDontSave;

  /// Null while the capture can't be saved.
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final BuildContext(:l10n, :colors, :paper, :textTheme, :compact) = context;
    final message = switch (failure) {
      _ when problems.isNotEmpty => [
        for (final p in problems) p.label(l10n),
      ].join(l10n.detailSeparator),
      final CaptureFailure f => f.label(l10n),
      null when stage == .saved => l10n.editorSaved,
      null => l10n.editorNothingSent,
    };
    final warning = problems.isNotEmpty || failure != null;
    final text = Text(
      message,
      style: textTheme.labelMedium?.copyWith(
        color: warning ? colors.error : colors.onSurfaceVariant,
      ),
    );
    final buttons = [
      if (stage == .proposed)
        LineButton(
          l10n.dontSave,
          key: const ValueKey(AppWidgetKeys.editorDontSaveButton),
          onPressed: onDontSave,
        ),
      InkButton(
        stage == .approved ? l10n.retrySave : l10n.saveToNotion,
        key: const ValueKey(AppWidgetKeys.editorSaveButton),
        busy: saving,
        onPressed: onSave,
      ),
    ];
    return Container(
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm)
          : const EdgeInsets.fromLTRB(Spacing.xxl, Spacing.md, Spacing.xxl, Spacing.lg),
      decoration: BoxDecoration(
        color: paper.sidebar,
        border: Border(top: .new(color: paper.line)),
      ),
      child: compact
          ? Column(
              crossAxisAlignment: .stretch,
              spacing: Spacing.xs,
              children: [
                text,
                Wrap(
                  alignment: .end,
                  spacing: Spacing.sm,
                  runSpacing: Spacing.xs,
                  children: buttons,
                ),
              ],
            )
          : Row(
              spacing: Spacing.sm,
              children: [
                Expanded(child: text),
                ...buttons,
              ],
            ),
    );
  }
}
