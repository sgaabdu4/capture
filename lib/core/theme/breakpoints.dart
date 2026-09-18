/// Layout widths, in logical pixels.
abstract final class Breakpoints {
  /// Narrower windows swap the sidebar for a bottom bar.
  static const double sidebar = 840;

  /// Narrower content stacks side-by-side cards.
  static const double stacked = 720;

  /// Widest column of page content; wider windows centre it.
  static const double content = 1280;
}
