import 'package:capture/core/theme/breakpoints.dart';
import 'package:capture/core/theme/capture_colors.dart';
import 'package:capture/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  AppLocalizations get l10n => .of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// A phone-sized window: bottom bar instead of the sidebar, tighter
  /// margins.
  bool get compact => MediaQuery.sizeOf(this).width < Breakpoints.sidebar;

  CaptureColors get paper => Theme.of(this).extension<CaptureColors>() ?? const .new();

  /// Whether this context's nearest modal route is currently visible.
  bool get isCurrentModalRoute {
    final isCurrent = ModalRoute.isCurrentOf(this);
    if (isCurrent == null) return true;
    return isCurrent;
  }
}
