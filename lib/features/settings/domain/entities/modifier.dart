/// Shortcut modifier keys with their macOS symbols and Carbon flags.
enum Modifier {
  control('⌃', 0x1000),
  option('⌥', 0x0800),
  shift('⇧', 0x0200),
  command('⌘', 0x0100);

  const Modifier(this.symbol, this.carbonFlag);
  final String symbol;
  final int carbonFlag;
}
