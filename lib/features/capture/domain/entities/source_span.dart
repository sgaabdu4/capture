import 'package:capture/features/capture/domain/values/excerpt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'source_span.freezed.dart';

@freezed
sealed class SourceSpan with _$SourceSpan {
  const factory SourceSpan(int start, int end, Excerpt excerpt) = _SourceSpan;
}
