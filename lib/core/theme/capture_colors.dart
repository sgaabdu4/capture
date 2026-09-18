import 'package:capture/core/theme/palette.dart';
import 'package:flutter/material.dart';

/// Paper-look colours with no Material [ColorScheme] slot.
class CaptureColors extends ThemeExtension<CaptureColors> {
  const CaptureColors();

  Color get sidebar => Palette.sidebar;
  Color get selected => Palette.selected;
  Color get card => Palette.card;
  Color get line => Palette.line;
  Color get faint => Palette.faint;
  Color get pencil => Palette.ray;
  Color get mic => Palette.mic;
  Color get ok => Palette.ok;
  Color get warn => Palette.warn;
  Color get flag => Palette.flag;
  Color get shadow => Palette.shadow;
  Color get micShadow => Palette.micShadow;

  @override
  CaptureColors copyWith() => this;

  @override
  CaptureColors lerp(CaptureColors? other, double t) => this;
}
