/// Shortcut modifier keys.
enum Modifier { control, option, shift, command }

extension ModifierKeys on Modifier {
  /// The macOS menu symbol.
  String get symbol => switch (this) {
    .control => '⌃',
    .option => '⌥',
    .shift => '⇧',
    .command => '⌘',
  };

  /// The Carbon event-modifier flag.
  int get carbonFlag => switch (this) {
    .control => 0x1000,
    .option => 0x0800,
    .shift => 0x0200,
    .command => 0x0100,
  };
}
