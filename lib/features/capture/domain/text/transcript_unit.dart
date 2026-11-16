import 'package:capture/features/capture/domain/entities/source_span.dart';
import 'package:capture/features/capture/domain/text/boundary_kind.dart';
import 'package:capture/features/capture/domain/values/passage_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transcript_unit.freezed.dart';

@freezed
sealed class TranscriptUnit with _$TranscriptUnit {
  const factory TranscriptUnit(PassageId id, SourceSpan span, BoundaryKind boundaryBefore) =
      _TranscriptUnit;
}
