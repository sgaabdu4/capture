import 'package:flutter/material.dart';

/// Tokens measured from the approved references (docs/design/reference).
/// Keep in sync with the native overlay's `Theme.swift`.
abstract final class Palette {
  static const paper = Color(0xFFFBF9F3);
  static const sidebar = Color(0xFFF6F4EE);
  static const selected = Color(0xFFEDEAE4);
  static const card = Color(0xFFFDFBF7);
  static const line = Color(0xFFE9E4DA);
  static const ink = Color(0xFF1A1916);
  static const muted = Color(0xFF6E6A63);
  static const faint = Color(0xFFA59F96);
  static const ray = Color(0xFFD0CAC3);
  static const mic = Color(0xFF161714);
  static const ok = Color(0xFF5FBA4B);
  static const warn = Color(0xFFC98A2B);
  static const error = Color(0xFFB4533C);
  static const cream = Color(0xFFFBF5ED);
}

abstract final class Fonts {
  static const title = 'Caveat';
  static const hand = 'Patrick Hand';
}

abstract final class Styles {
  static const wordmark = TextStyle(
    fontFamily: Fonts.title,
    fontSize: 46,
    fontWeight: FontWeight.w700,
    color: Palette.ink,
    height: 1,
  );
  static const hero = TextStyle(
    fontFamily: Fonts.title,
    fontSize: 84,
    fontWeight: FontWeight.w700,
    color: Palette.ink,
    height: 1,
  );
  static const pageTitle = TextStyle(
    fontFamily: Fonts.title,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: Palette.ink,
    height: 1.1,
  );
  static const cardTitle = TextStyle(
    fontFamily: Fonts.hand,
    fontSize: 25,
    color: Palette.ink,
    height: 1.2,
  );
  static const tagline = TextStyle(
    fontFamily: Fonts.hand,
    fontSize: 26,
    color: Palette.ink,
    letterSpacing: 0.6,
  );
  static const body = TextStyle(
    fontFamily: Fonts.hand,
    fontSize: 18,
    color: Palette.ink,
    height: 1.35,
  );
  static const label = TextStyle(
    fontFamily: Fonts.hand,
    fontSize: 16,
    color: Palette.muted,
    height: 1.3,
  );
  static const small = TextStyle(
    fontFamily: Fonts.hand,
    fontSize: 14,
    color: Palette.muted,
  );
}

ThemeData captureTheme() {
  const scheme = ColorScheme.light(
    primary: Palette.ink,
    onPrimary: Palette.cream,
    secondary: Palette.muted,
    surface: Palette.paper,
    onSurface: Palette.ink,
    error: Palette.error,
    outline: Palette.line,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: Palette.paper,
    fontFamily: Fonts.hand,
    splashFactory: NoSplash.splashFactory,
    hoverColor: Palette.selected.withValues(alpha: 0.6),
    dividerColor: Palette.line,
    textTheme: const TextTheme(
      bodyMedium: Styles.body,
      bodyLarge: Styles.body,
      bodySmall: Styles.small,
      titleMedium: Styles.cardTitle,
      labelLarge: Styles.body,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Palette.card,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      labelStyle: Styles.label,
      hintStyle: Styles.label.copyWith(color: Palette.faint),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Palette.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Palette.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Palette.ink),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      side: const BorderSide(color: Palette.ink, width: 1.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      fillColor: WidgetStateProperty.resolveWith(
        (s) =>
            s.contains(WidgetState.selected) ? Palette.ink : Colors.transparent,
      ),
      checkColor: const WidgetStatePropertyAll(Palette.cream),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Palette.paper,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Palette.ink,
      contentTextStyle: TextStyle(
        fontFamily: Fonts.hand,
        fontSize: 16,
        color: Palette.cream,
      ),
      behavior: SnackBarBehavior.floating,
    ),
    tooltipTheme: const TooltipThemeData(
      textStyle: TextStyle(
        fontFamily: Fonts.hand,
        fontSize: 14,
        color: Palette.cream,
      ),
    ),
  );
}
