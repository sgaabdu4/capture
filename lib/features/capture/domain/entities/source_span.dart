import 'package:freezed_annotation/freezed_annotation.dart';

part 'source_span.freezed.dart';

/// Offsets convention (shared by all Dart code; native code never produces
/// offsets): UTF-16 code-unit indices into the transcript string, half-open
/// `[start, end)`. Boundaries are only ever placed on whitespace/word starts,
/// so a span never splits a surrogate pair.
@freezed
sealed class SourceSpan with _$SourceSpan {
  /// [excerpt] is an exact copy of the source text; kept separately because
  /// offsets alone go stale if the transcript is later edited elsewhere.
  const factory SourceSpan(int start, int end, String excerpt) = _SourceSpan;
}
