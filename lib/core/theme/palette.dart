import 'package:flutter/material.dart';

/// Colours measured from the approved references (docs/design/reference).
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

  // The recording pill and review card (`Overlay.swift`).
  static const charcoal = Color(0xFF403B36);
  static const charcoalRow = Color(0xFF4A443E);
  static const charcoalButton = Color(0xFF524C45);
  static const creamMuted = Color(0xFFBDB4AA);
  static const pillShadow = Color(0x40000000);
  static const cardShadow = Color(0x47000000);
  static const cardEdge = Color(0x0FFFFFFF);
  static const cardRule = Color(0x2E000000);
  static const micWell = Color(0x14FFFFFF);
  static const flag = Color(0xFFF6EBD7);
  static const shadow = Color(0x0F000000);
  static const micShadow = Color(0x33000000);
}
