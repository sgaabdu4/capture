import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

/// Outcome of an operation whose failure is an expected, typed case (an
/// unreachable server, a rejected key, a malformed answer). Exceptions from
/// libraries are converted to [Err] once, at the boundary that expects them.
@Freezed(map: .none, when: .none)
sealed class Result<T, E> with _$Result<T, E> {
  const Result._();

  const factory Result.ok(T value) = Ok<T, E>;
  const factory Result.err(E failure) = Err<T, E>;

  /// The value, or null for a failure.
  T? get valueOrNull => switch (this) {
    Ok(:final value) => value,
    Err() => null,
  };
}
