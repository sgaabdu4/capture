import 'package:capture/features/capture/domain/values/jev_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'jev_call_metrics.freezed.dart';

/// Metadata recorded per Jev request — never transcript or answers.
@freezed
sealed class JevCallMetrics with _$JevCallMetrics {
  const factory JevCallMetrics({
    required JevModel model,
    required Duration latency,
    required int inputTokens,
    required int outputTokens,
    required int questions,
    String? requestId,
  }) = _JevCallMetrics;
}
