import 'package:capture/features/capture/domain/entities/source_span.dart';
import 'package:capture/features/capture/domain/text/transcript_unit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'thought.freezed.dart';

/// A complete thought: consecutive units joined at the selected boundaries.
/// Its span runs from the first unit's start to the last unit's end, so the
/// text between units is copied exactly (never re-joined or rewritten).
@freezed
sealed class Thought with _$Thought {
  const factory Thought(
    String id,
    List<TranscriptUnit> units,
    SourceSpan span, {

    /// True when the boundary that started this thought was uncertain.
    @Default(false) bool uncertainStart,

    /// True when the thought starts with a correction of an earlier,
    /// non-adjacent thought.
    @Default(false) bool lateCorrection,
  }) = _Thought;
}
