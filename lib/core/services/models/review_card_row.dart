import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_card_row.freezed.dart';

/// One item row on the native review card.
@freezed
sealed class ReviewCardRow with _$ReviewCardRow {
  const factory ReviewCardRow({
    required String id,

    /// SF Symbol name.
    required String icon,
    required String title,
    required String detail,
  }) = _ReviewCardRow;
}
