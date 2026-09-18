import 'package:capture/core/services/models/review_card_row.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_card_payload.freezed.dart';

/// Localized content for the native review card near the pill.
@freezed
sealed class ReviewCardPayload with _$ReviewCardPayload {
  const factory ReviewCardPayload({
    required String countLine,
    required List<ReviewCardRow> rows,
    required bool canApprove,
    String? blockedReason,
  }) = _ReviewCardPayload;
}
