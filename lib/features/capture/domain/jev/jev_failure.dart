import 'package:capture/core/domain/values/result.dart';

/// Failure categories the capture flow reacts to. Drafts are always kept.
enum JevFailure { invalidKey, rateLimited, unavailable, network, invalidResponse }

typedef JevOutcome<T> = Result<T, JevFailure>;
