import 'package:capture/features/capture/domain/jev/jev_usage.dart';
import 'package:capture/features/capture/domain/values/jev_answer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'jev_result.freezed.dart';

/// A decoded Jev response: one answer per asked question key.
@freezed
sealed class JevResult with _$JevResult {
  const factory JevResult(String model, Map<String, JevAnswer> answers, JevUsage usage) =
      _JevResult;
}
