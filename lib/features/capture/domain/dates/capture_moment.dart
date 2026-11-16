import 'package:freezed_annotation/freezed_annotation.dart';

part 'capture_moment.freezed.dart';

typedef UtcOffsetAt = Duration Function(DateTime instantUtc);

DateTime wallClockAt(DateTime instantUtc, UtcOffsetAt offsetAt) =>
    instantUtc.toUtc().add(offsetAt(instantUtc));

@freezed
sealed class CaptureMoment with _$CaptureMoment {
  const CaptureMoment._();

  const factory CaptureMoment({required DateTime capturedAtUtc, required UtcOffsetAt offsetAt}) =
      _CaptureMoment;

  /// Wall-clock time of the capture in its time zone.
  DateTime get wallClock => wallClockAt(capturedAtUtc, offsetAt);
}
