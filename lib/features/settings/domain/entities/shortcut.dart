import 'package:capture/features/settings/domain/entities/modifier.dart';
import 'package:capture/features/settings/domain/entities/shortcut_problem.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shortcut.freezed.dart';

/// A global shortcut: a letter or digit (upper case) plus modifiers.
@freezed
sealed class Shortcut with _$Shortcut {
  const Shortcut._();

  const factory Shortcut(String key, {required Set<Modifier> modifiers}) = _Shortcut;

  /// ⌃⌥R: free in common apps, unlike ⌘R.
  static const standard = Shortcut('R', modifiers: {.control, .option});

  /// Fewest modifiers that keep ordinary typing and app shortcuts safe.
  static const _minModifiers = 2;

  /// Carbon kVK_ANSI_* codes (US layout positions).
  static const carbonKeyCodes = {
    'A': 0, 'S': 1, 'D': 2, 'F': 3, 'H': 4, 'G': 5, 'Z': 6, 'X': 7, //
    'C': 8, 'V': 9, 'B': 11, 'Q': 12, 'W': 13, 'E': 14, 'R': 15, 'Y': 16,
    'T': 17, '1': 18, '2': 19, '3': 20, '4': 21, '6': 22, '5': 23, '9': 25,
    '7': 26, '8': 28, '0': 29, 'O': 31, 'U': 32, 'I': 34, 'P': 35, 'L': 37,
    'J': 38, 'K': 40, 'N': 45, 'M': 46,
  };

  int? get keyCode => carbonKeyCodes[key];

  int get carbonModifiers => modifiers.fold(0, (flags, m) => flags | m.carbonFlag);

  /// macOS order: ⌃ ⌥ ⇧ ⌘ then the key.
  String get label => [
    for (final m in Modifier.values)
      if (modifiers.contains(m)) m.symbol,
    key,
  ].join();

  /// At least two modifiers, one of them ⌃ or ⌘, so ordinary typing and
  /// common app shortcuts (⌘R, ⌥R) are never captured.
  ShortcutProblem? get problem {
    if (keyCode == null) return .unsupportedKey;
    final anchored = modifiers.contains(Modifier.control) || modifiers.contains(Modifier.command);
    if (modifiers.length < _minModifiers || !anchored) return .tooFewModifiers;
    return null;
  }
}
