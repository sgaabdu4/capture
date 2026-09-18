import 'package:freezed_annotation/freezed_annotation.dart';

part 'jev_usage.freezed.dart';

/// Token usage reported for one Jev request.
@freezed
sealed class JevUsage with _$JevUsage {
  const factory JevUsage(int inputTokens, int outputTokens) = _JevUsage;
}
