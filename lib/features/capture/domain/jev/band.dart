import 'package:freezed_annotation/freezed_annotation.dart';

part 'band.freezed.dart';

/// Decision band for a Noul P(yes). A value inside [low, high) is treated as
/// uncertain and flagged for review; the provisional decision is still
/// `p >= decide`.
@freezed
sealed class Band with _$Band {
  const Band._();

  const factory Band(double decide, double low, double high) = _Band;

  bool yes(double p) => p >= decide;

  bool uncertain(double p) => p >= low && p < high;
}
