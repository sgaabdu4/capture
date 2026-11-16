import 'package:capture/features/capture/domain/entities/source_span.dart';
import 'package:capture/features/capture/domain/text/transcript_unit.dart';
import 'package:capture/features/capture/domain/values/passage_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'thought.freezed.dart';

@freezed
sealed class Thought with _$Thought {
  const factory Thought(
    PassageId id,
    List<TranscriptUnit> units,
    SourceSpan span, {

    /// True when the boundary that started this thought was uncertain.
    @Default(false) bool uncertainStart,

    @Default(false) bool lateCorrection,
  }) = _Thought;
}
