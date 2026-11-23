---
colors:
  paper: "#fbf9f3"
  sidebar: "#f6f4ee"
  selected: "#edeae4"
  card: "#fdfbf7"
  line: "#e9e4da"
  fieldEdge: "#8a857c"
  ink: "#1a1916"
  muted: "#6e6a63"
  faint: "#a59f96"
  ray: "#d0cac3"
  mic: "#161714"
  ok: "#5fba4b"
  warn: "#c98a2b"
  error: "#b4533c"
  cream: "#fbf5ed"
  scrim: "#0000008a"
  charcoal: "#403b36"
  charcoalRow: "#4a443e"
  charcoalButton: "#524c45"
  creamMuted: "#bdb4aa"
  pillShadow: "#00000040"
  cardShadow: "#00000047"
  cardEdge: "#ffffff0f"
  cardRule: "#0000002e"
  micWell: "#ffffff14"
  flag: "#f6ebd7"
  shadow: "#0000000f"
  micShadow: "#00000033"
spacing:
  hair: 2px
  xxs: 4px
  xs: 8px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  xxl: 48px
  xxxl: 64px
rounded:
  r4: 4px
  r6: 6px
  r10: 10px
  r12: 12px
  r16: 16px
  r18: 18px
  r22: 22px
typography:
  displayLarge:
    fontFamily: "Caveat"
    fontSize: 84px
  displayMedium:
    fontFamily: "Caveat"
    fontSize: 48px
  headlineLarge:
    fontFamily: "Caveat"
    fontSize: 46px
  headlineSmall:
    fontFamily: "Caveat"
    fontSize: 24px
  titleLarge:
    fontFamily: "Patrick Hand"
    fontSize: 26px
    letterSpacing: 0.6px
  titleMedium:
    fontFamily: "Patrick Hand"
    fontSize: 25px
  titleSmall:
    fontFamily: "Patrick Hand"
    fontSize: 21px
  bodyLarge:
    fontFamily: "Patrick Hand"
    fontSize: 24px
  bodyMedium:
    fontFamily: "Patrick Hand"
    fontSize: 18px
  labelLarge:
    fontFamily: "Patrick Hand"
    fontSize: 20px
  labelMedium:
    fontFamily: "Patrick Hand"
    fontSize: 16px
  bodySmall:
    fontFamily: "Patrick Hand"
    fontSize: 14px
  modifierSymbols:
    fontFamily: "Apple Symbols"
    fontSize: 25px
  overlayCardTitle:
    fontFamily: "Caveat"
    fontSize: 34px
  overlayStatus:
    fontFamily: "Patrick Hand"
    fontSize: 17px
  overlayTimer:
    fontFamily: "Patrick Hand"
    fontSize: 15px
iconSizes:
  s16: 16px
  s18: 18px
  s20: 20px
  s22: 22px
  s24: 24px
  s26: 26px
  s28: 28px
sizes:
  hairline: 1px
  spinnerStroke: 2px
  sourceRule: 3px
  progressBar: 6px
  shadowOffset: 6px
  statusDot: 10px
  micShadowOffset: 10px
  spinner: 18px
  shadowBlur: 18px
  micShadowBlur: 24px
  badge: 44px
  tapTarget: 48px
  fieldsWidth: 560px
  micRaysExtent: 150px
  groupMenuWidth: 170px
  micDiameter: 200px
  sidebarWidth: 260px
  dialogWidth: 460px
  guideWidth: 520px
  guideHeight: 560px
  setupMaxWidth: 760px
  cardsMaxWidth: 1080px
overlay:
  barGap: 3px
  barMin: 4px
  dot: 7px
  rowGap: 8px
  reasonGap: 10px
  stopSquare: 11px
  closeIcon: 11px
  workingGap: 12px
  reviewPillGap: 14px
  cardGap: 14px
  buttonGap: 14px
  micIcon: 15px
  recordingGap: 16px
  cardCloseIcon: 16px
  rowIconGap: 18px
  closeButton: 22px
  rowIcon: 24px
  waveHeight: 26px
  ruleSpace: 28px
  stopButton: 30px
  rowIconWidth: 30px
  micWell: 34px
  buttonHeight: 46px
  editWidth: 70px
  rowHeight: 74px
  noWidth: 92px
  waveWidth: 118px
  rowsMaxHeight: 300px
breakpoints:
  stacked: 720px
  sidebar: 840px
  content: 1280px
---
# Capture Design

## Overview

A macOS main window plus a menu-bar panel and a compact recording overlay, with a matching responsive phone layout. Exact colour, font, spacing, radius, size and breakpoint tokens live in `lib/core/theme/` (mirrored in `macos/Runner/Native/Theme.swift` for the native overlay) and in the YAML front matter above.

Principles: notebook-like and personal, calm, truthful states, no decorative features or dead controls.

## Colors

Warm paper palette: light cream background (`paper`, `sidebar`, `card`), dark ink text (`ink`, `muted`, `faint`), thin warm separators (`line`), the input outline (`fieldEdge`, 3 to 1 against the field fill), restrained shadows (`shadow`, `micShadow`), and muted semantic accents (`ok`, `warn`, `error`, `flag`). The recording pill and review card use dark charcoal surfaces (`charcoal`, `charcoalRow`, `charcoalButton`) with cream text and controls (`cream`, `creamMuted`). No coloured category dots, bright gradients or new brand colours.

## Typography

Handwritten notebook typography bundled under `assets/fonts/`: `Caveat` for display and page headings (`Fonts.titleFamily`, used by `displayLarge`, `displayMedium`, `headlineLarge`, `headlineSmall`, and `overlayCardTitle`) and `Patrick Hand` for card/dialog titles, body text, controls and labels (`Fonts.handFamily`, used by `titleLarge` through `bodySmall`). `Apple Symbols` (`Fonts.symbolFamily`) is the fallback that draws the modifier symbols ⌃ ⌥ ⇧ ⌘, which the handwriting fonts do not hold.

## Layout

Consistent spacing (`Spacing`), soft rounded paper cards (`Radii`), and responsive breakpoints (`Breakpoints.stacked`, `Breakpoints.sidebar`, `Breakpoints.content`). Fine stroke and waveform tokens defined in `lib/core/theme/sizes.dart` and `lib/core/theme/overlay_tokens.dart` are `Sizes.outline` (`1.4` px), `Sizes.checkboxBorder` (`1.6` px), and `OverlayTokens.barWidth` (`3.5` px). The home screen centres a prominent black circular microphone button (`Sizes.micDiameter`). The overlay pill sits bottom-centre on the active display, clear of the Dock, with the compact review card directly above it.

## Components

Shared UI controls live in `lib/core/widgets/` and are listed in `UI-LIBRARY.md`. Feature screens and widgets compose those shared controls instead of building raw Material base controls directly.

- Atoms (`lib/core/widgets/atoms/`): `InkButton`, `LineButton`, `LinkButton`, `IconAction`, `PaperField`, `PaperCheckbox`, `PaperSwitch`, `PaperDropdown`, `PaperSegmented`, `PaperCard`, `TapSurface`, `IconBadge`, `StatusDot`, `EmptyNote`, `Underlined`.
- Shared layouts (`lib/core/widgets/`): `PageFrame`, `ExpandableCard`, `PaperDialog`.
- Feature surfaces (`lib/features/*/presentation/`): Home, Groups, Recordings, To-do, Upcoming, Settings, Onboarding, review editor, and iPhone overlay.

## Do's and Don'ts

- Do build real widgets. Keep theme tokens (type, spacing, colours, radii, icons) small and reusable.
- Do show truthful statuses and empty states. Show no recording indicator after the microphone stops.
- Do hide deferred features instead of adding dead buttons.
- Don't use screenshots as backgrounds, draw a fake menu bar, or change the wallpaper.
- Don't use generic Material styling, chatbot bubbles, oversized statistics or a redesign.
- Don't let clicking outside the review card, or pressing Enter in another app, approve a save.
