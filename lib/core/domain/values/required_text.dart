String requireText(String value, String name) {
  assert(value.trim().isNotEmpty, '$name must not be blank');
  return value;
}

/// Optional text from input: blank becomes null, anything else is kept as is.
String? optionalText(String value) => value.trim().isEmpty ? null : value;
