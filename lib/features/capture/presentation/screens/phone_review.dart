import 'dart:async';

import 'package:capture/core/extensions/extensions.dart';
import 'package:capture/core/services/models/review_card_payload.dart';
import 'package:capture/core/services/models/review_card_row.dart';
import 'package:capture/core/services/native_event.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:capture/features/capture/presentation/extensions/review_card_content.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_flow_notifier.dart';
import 'package:capture/features/capture/presentation/widgets/review_card.dart';
import 'package:capture/features/capture/presentation/widgets/review_pill.dart';
import 'package:capture/features/groups/presentation/notifiers/groups_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The review card over its "Not saved yet" pill, with the Mac's actions.
class PhoneReview extends ConsumerWidget {
  const PhoneReview({super.key});

  /// The Mac card's SF Symbols, drawn with the app's Material icons.
  static IconData _icon(String symbol) => switch (symbol) {
    'calendar' => Icons.calendar_today_outlined,
    'checkmark.square' => Icons.check_box_outlined,
    _ => Icons.description_outlined,
  };

  static void _act(WidgetRef ref, ReviewAction action) =>
      unawaited(ref.read(captureFlowProvider.notifier).onReviewAction(action));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final reviewing = ref.watch(captureFlowProvider.select((s) => s.reviewing));
    final card = ref.watch(groupsProvider.select((g) => reviewing?.reviewCard(l10n, g)));
    return Column(
      mainAxisSize: .min,
      spacing: Spacing.sm,
      children: [
        if (card case ReviewCardPayload(
          :final countLine,
          :final rows,
          :final canApprove,
          :final blockedReason,
        ))
          ReviewCard(
            countLine: countLine,
            rows: [
              for (final ReviewCardRow(:icon, :title, :detail) in rows)
                (icon: _icon(icon), title: title, detail: detail),
            ],
            canApprove: canApprove,
            blockedReason: blockedReason,
            onYes: () => _act(ref, .yes),
            onNo: () => _act(ref, .no),
            onEdit: () => _act(ref, .edit),
            onLater: () => _act(ref, .later),
          ),
        ReviewPill(onLater: () => _act(ref, .later)),
      ],
    );
  }
}
