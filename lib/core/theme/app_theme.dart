import 'package:capture/core/theme/capture_colors.dart';
import 'package:capture/core/theme/fonts.dart';
import 'package:capture/core/theme/palette.dart';
import 'package:capture/core/theme/radii.dart';
import 'package:capture/core/theme/sizes.dart';
import 'package:capture/core/theme/spacing.dart';
import 'package:flutter/material.dart';

/// Handwritten type scale from the references:
/// displayLarge = hero wordmark, displayMedium = page title,
/// headlineLarge = sidebar wordmark, headlineSmall = sidebar motto,
/// titleLarge = tagline, titleMedium = card title, bodyLarge = large body,
/// bodyMedium = body, labelLarge = label, bodySmall = small print.
const _textTheme = TextTheme(
  displayLarge: .new(
    fontFamily: Fonts.title,
    fontSize: 84,
    fontWeight: .w700,
    color: Palette.ink,
    height: 1,
  ),
  displayMedium: .new(
    fontFamily: Fonts.title,
    fontSize: 48,
    fontWeight: .w700,
    color: Palette.ink,
    height: 1.1,
  ),
  headlineLarge: .new(
    fontFamily: Fonts.title,
    fontSize: 46,
    fontWeight: .w700,
    color: Palette.ink,
    height: 1,
  ),
  headlineSmall: .new(fontFamily: Fonts.title, fontSize: 24, color: Palette.muted, height: 1.1),
  titleLarge: .new(fontFamily: Fonts.hand, fontSize: 26, color: Palette.ink, letterSpacing: 0.6),
  titleMedium: .new(fontFamily: Fonts.hand, fontSize: 25, color: Palette.ink, height: 1.2),
  titleSmall: .new(fontFamily: Fonts.hand, fontSize: 21, color: Palette.ink),
  bodyLarge: .new(fontFamily: Fonts.hand, fontSize: 24, color: Palette.ink, height: 1.3),
  bodyMedium: .new(fontFamily: Fonts.hand, fontSize: 18, color: Palette.ink, height: 1.35),
  labelLarge: .new(fontFamily: Fonts.hand, fontSize: 20, color: Palette.ink),
  labelMedium: .new(fontFamily: Fonts.hand, fontSize: 16, color: Palette.muted, height: 1.3),
  bodySmall: .new(fontFamily: Fonts.hand, fontSize: 14, color: Palette.muted),
);

ThemeData buildAppTheme() => .new(
  colorScheme: _scheme,
  scaffoldBackgroundColor: Palette.paper,
  fontFamily: Fonts.hand,
  splashFactory: NoSplash.splashFactory,
  pageTransitionsTheme: const .new(builders: {.macOS: FadeForwardsPageTransitionsBuilder()}),
  hoverColor: Palette.selected.withValues(alpha: Opacities.hover),
  textTheme: _textTheme,
  dividerTheme: const .new(color: Palette.line),
  extensions: const [CaptureColors()],
  inputDecorationTheme: _inputTheme(),
  checkboxTheme: _checkboxTheme(),
  switchTheme: const .new(
    thumbColor: WidgetStatePropertyAll(Palette.cream),
    trackColor: WidgetStatePropertyAll(Palette.ink),
  ),
  filledButtonTheme: _filledButtonTheme(),
  outlinedButtonTheme: _outlinedButtonTheme(),
  textButtonTheme: .new(
    style: TextButton.styleFrom(
      foregroundColor: Palette.ink,
      textStyle: _textTheme.labelMedium,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.xs, vertical: Spacing.xxs),
    ),
  ),
  segmentedButtonTheme: .new(
    style: SegmentedButton.styleFrom(
      selectedBackgroundColor: Palette.ink,
      selectedForegroundColor: Palette.cream,
      foregroundColor: Palette.ink,
      side: const .new(color: Palette.line),
      textStyle: _textTheme.labelMedium,
    ),
  ),
  chipTheme: .new(
    backgroundColor: Palette.flag,
    side: .none,
    labelStyle: _textTheme.bodySmall?.copyWith(color: Palette.ink),
  ),
  progressIndicatorTheme: const .new(
    color: Palette.ink,
    linearTrackColor: Palette.selected,
    linearMinHeight: Sizes.progressBar,
  ),
  timePickerTheme: .new(
    // The default, displayLarge, is the hero wordmark and overflows the
    // picker's fixed fields.
    hourMinuteTextStyle: _textTheme.displayMedium,
    // The default AM/PM uses the unset tertiary colours, grey on grey;
    // selected matches the selected hour instead.
    dayPeriodColor: WidgetStateColor.resolveWith(
      (s) => s.contains(WidgetState.selected) ? Palette.ink : Colors.transparent,
    ),
    dayPeriodTextColor: WidgetStateColor.resolveWith(
      (s) => s.contains(WidgetState.selected) ? Palette.cream : Palette.muted,
    ),
  ),
  dialogTheme: const .new(
    backgroundColor: Palette.paper,
    shape: RoundedRectangleBorder(borderRadius: Radii.rounded16),
  ),
  snackBarTheme: .new(
    backgroundColor: Palette.ink,
    contentTextStyle: _textTheme.labelMedium?.copyWith(color: Palette.cream),
    behavior: .floating,
  ),
  tooltipTheme: .new(textStyle: _textTheme.bodySmall?.copyWith(color: Palette.cream)),
);

const _scheme = ColorScheme.light(
  primary: Palette.ink,
  onPrimary: Palette.cream,
  secondary: Palette.muted,
  surface: Palette.paper,
  onSurface: Palette.ink,
  onSurfaceVariant: Palette.muted,
  error: Palette.error,
  outline: Palette.line,
);

const _fieldBorder = OutlineInputBorder(
  borderRadius: Radii.rounded10,
  borderSide: .new(color: Palette.line),
);

InputDecorationThemeData _inputTheme() => .new(
  filled: true,
  fillColor: Palette.card,
  isDense: true,
  contentPadding: const EdgeInsets.all(Spacing.sm),
  labelStyle: _textTheme.labelMedium,
  hintStyle: _textTheme.labelMedium,
  border: _fieldBorder,
  enabledBorder: _fieldBorder,
  focusedBorder: _fieldBorder.copyWith(borderSide: const .new(color: Palette.ink)),
);

CheckboxThemeData _checkboxTheme() => .new(
  side: const .new(color: Palette.ink, width: Sizes.checkboxBorder),
  shape: const RoundedRectangleBorder(borderRadius: Radii.rounded4),
  fillColor: .resolveWith(
    (s) => s.contains(WidgetState.selected) ? Palette.ink : Colors.transparent,
  ),
  checkColor: const WidgetStatePropertyAll(Palette.cream),
);

FilledButtonThemeData _filledButtonTheme() => .new(
  style: FilledButton.styleFrom(
    backgroundColor: Palette.ink,
    foregroundColor: Palette.cream,
    disabledBackgroundColor: Palette.ink.withValues(alpha: Opacities.disabled),
    disabledForegroundColor: Palette.cream,
    textStyle: _textTheme.bodyMedium,
    padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.sm),
    shape: const RoundedRectangleBorder(borderRadius: Radii.rounded12),
  ),
);

OutlinedButtonThemeData _outlinedButtonTheme() => .new(
  style: OutlinedButton.styleFrom(
    foregroundColor: Palette.ink,
    side: const .new(color: Palette.line, width: Sizes.outline),
    textStyle: _textTheme.bodyMedium,
    padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
    shape: const RoundedRectangleBorder(borderRadius: Radii.rounded12),
  ),
);
