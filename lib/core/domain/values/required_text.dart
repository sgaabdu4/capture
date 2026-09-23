/// Returns [value] unchanged, or throws when it is blank. Required domain
/// text is checked once, where its value object is made.
String requireText(String value, String name) {
  if (value.trim().isEmpty) throw ArgumentError.value(value, name, 'must not be blank');
  return value;
}

/// Optional text from input: blank becomes null, anything else is kept as is.
String? optionalText(String value) => value.trim().isEmpty ? null : value;
