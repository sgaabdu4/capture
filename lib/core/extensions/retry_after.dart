import 'dart:io';

import 'package:http/http.dart' as http;

extension RetryAfter on http.BaseResponse {
  /// The longest server-requested wait honoured before a retry.
  static const max = Duration(seconds: 60);

  /// The Retry-After header in whole seconds, capped at [max]; null when
  /// absent or not a number.
  Duration? get retryAfter {
    final seconds = int.tryParse(headers[HttpHeaders.retryAfterHeader] ?? '');
    if (seconds == null) return null;
    final wait = Duration(seconds: seconds);
    return wait > max ? max : wait;
  }
}
