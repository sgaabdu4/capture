import 'package:capture/features/capture/domain/entities/source_span.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'source_span_model.freezed.dart';
part 'source_span_model.g.dart';

@freezed
sealed class SourceSpanModel with _$SourceSpanModel {
  const SourceSpanModel._();

  const factory SourceSpanModel({required int start, required int end, required String excerpt}) =
      _SourceSpanModel;

  factory SourceSpanModel.fromJson(Map<String, dynamic> json) => _$SourceSpanModelFromJson(json);

  factory SourceSpanModel.fromEntity(SourceSpan s) =>
      SourceSpanModel(start: s.start, end: s.end, excerpt: s.excerpt);

  SourceSpan toEntity() => .new(start, end, excerpt);
}
