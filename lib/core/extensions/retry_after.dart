import 'dart:io';

import 'package:http/http.dart' as http;

extension RetryAfter on http.BaseResponse {
  /// The longest server-requested wait honoured before a retry.
  static const max = Duration(seconds: 60);

  /// Retry-After in whole seconds, capped at [max]; null when absent or not a number.
  Duration? get retryAfter {
    final value = headers[HttpHeaders.retryAfterHeader];
    if (value == null) return null;
    final seconds = int.tryParse(value);
    if (seconds == null) return null;
    final wait = Duration(seconds: seconds);
    return wait > max ? max : wait;
  }
}
