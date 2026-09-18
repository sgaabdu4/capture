/// A global shortcut as a Carbon virtual key code plus modifier flags.
class Shortcut {
  const Shortcut(this.key, {required this.modifiers});

  factory Shortcut.fromJson(Map<String, Object?> json) => Shortcut(
    json['key']! as String,
    modifiers: {
      for (final m in json['modifiers']! as List<Object?>) Modifier.values.byName(m! as String),
    },
  );

  /// Letter or digit, upper case.
  final String key;
  final Set<Modifier> modifiers;

  static const defaultShortcut = Shortcut('R', modifiers: {Modifier.control, Modifier.option});

  int get keyCode => carbonKeyCodes[key]!;

  int get carbonModifiers => modifiers.fold(0, (flags, m) => flags | m.carbonFlag);

  /// macOS order: ⌃ ⌥ ⇧ ⌘ then the key.
  String get label =>
      '${[for (final m in Modifier.values)
        if (modifiers.contains(m)) m.symbol].join()}$key';

  Map<String, Object?> toJson() => {
    'key': key,
    'modifiers': [for (final m in modifiers) m.name],
  };

  @override
  bool operator ==(Object other) =>
      other is Shortcut &&
      other.key == key &&
      other.modifiers.length == modifiers.length &&
      other.modifiers.containsAll(modifiers);

  @override
  int get hashCode => Object.hash(key, Object.hashAllUnordered(modifiers));
}

enum Modifier {
  control('⌃', 0x1000),
  option('⌥', 0x0800),
  shift('⇧', 0x0200),
  command('⌘', 0x0100);

  const Modifier(this.symbol, this.carbonFlag);
  final String symbol;
  final int carbonFlag;
}

/// Why a shortcut can't be used, or null. At least two modifiers, one of
/// them ⌃ or ⌘, so ordinary typing and common app shortcuts (⌘R, ⌥R) are
/// never captured.
String? shortcutProblem(Shortcut s) {
  if (!carbonKeyCodes.containsKey(s.key)) return 'Use a letter or a digit.';
  if (s.modifiers.length < 2 ||
      !(s.modifiers.contains(Modifier.control) || s.modifiers.contains(Modifier.command))) {
    return 'Use at least two modifiers, including ⌃ or ⌘.';
  }
  return null;
}

/// Carbon kVK_ANSI_* codes (US layout positions).
const carbonKeyCodes = {
  'A': 0, 'S': 1, 'D': 2, 'F': 3, 'H': 4, 'G': 5, 'Z': 6, 'X': 7, //
  'C': 8, 'V': 9, 'B': 11, 'Q': 12, 'W': 13, 'E': 14, 'R': 15, 'Y': 16,
  'T': 17, '1': 18, '2': 19, '3': 20, '4': 21, '6': 22, '5': 23, '9': 25,
  '7': 26, '8': 28, '0': 29, 'O': 31, 'U': 32, 'I': 34, 'P': 35, 'L': 37,
  'J': 38, 'K': 40, 'N': 45, 'M': 46,
};
