import 'package:freezed_annotation/freezed_annotation.dart';

part 'capture_moment.freezed.dart';

/// UTC offset of the capture's time zone at [instantUtc], as given by its
/// IANA zone rules.
typedef UtcOffsetAt = Duration Function(DateTime instantUtc);

/// Wall-clock fields of [instantUtc] in the zone described by [offsetAt],
/// carried by a UTC-flagged [DateTime].
DateTime wallClockAt(DateTime instantUtc, UtcOffsetAt offsetAt) =>
    instantUtc.toUtc().add(offsetAt(instantUtc));

/// When a recording was captured and the rules of its time zone. Relative
/// expressions resolve against this, never the processing time.
@freezed
sealed class CaptureMoment with _$CaptureMoment {
  const CaptureMoment._();

  const factory CaptureMoment({required DateTime capturedAtUtc, required UtcOffsetAt offsetAt}) =
      _CaptureMoment;

  /// Wall-clock time of the capture in its time zone.
  DateTime get wallClock => wallClockAt(capturedAtUtc, offsetAt);
}
