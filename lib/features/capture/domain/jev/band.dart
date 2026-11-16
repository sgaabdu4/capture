import 'package:freezed_annotation/freezed_annotation.dart';

part 'band.freezed.dart';

@freezed
sealed class Band with _$Band {
  const Band._();

  const factory Band(double decide, double low, double high) = _Band;

  bool yes(double p) => p >= decide;

  bool uncertain(double p) => p >= low && p < high;
}
