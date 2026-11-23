# UI single-source rollout

Status: Complete

## Outcome + scope

Move all raw Flutter base controls outside `lib/core/widgets/` into shared library controls, remove raw colour literals from `macos/Runner/Native/Overlay.swift`, mirror every colour, length, and font family token in `DESIGN.md` YAML front matter, generate and complete `UI-LIBRARY.md`, upgrade `flutter_skill_lints` to `^0.16.0`, and include `lib/app/*` and `lib/core/router/*` in `shipping.ui_paths`. Visual appearance stays unchanged across all screens and overlays.

Out of scope: adding `ui_library` to `hard-eng.gates.json` (deferred until the `b5` release), redesigning screens or tokens, and changing non-UI features.

## Repository context

Owners:
- `lib/core/theme/` owns colour, font, spacing, radius, size, overlay, and breakpoint tokens (`app_theme.dart`, `fonts.dart`, `overlay_tokens.dart`, `palette.dart`, `radii.dart`, `sizes.dart`, `spacing.dart`, `breakpoints.dart`, `capture_colors.dart`).
- `lib/core/widgets/` owns shared UI library controls (`InkButton`, `LineButton`, `LinkButton`, `IconAction`, `PaperField`, `PaperCheckbox`, `PaperSwitch`, `PaperDropdown`, `PaperSegmented`, `PaperDialog`, `PaperCard`, `TapSurface`, `IconBadge`, `StatusDot`, `EmptyNote`, `Underlined`, `PageFrame`, `ExpandableCard`).
- `macos/Runner/Native/Theme.swift` owns native macOS overlay colours used by `macos/Runner/Native/Overlay.swift`.
- `DESIGN.md` and `UI-LIBRARY.md` document the token values and shared widget catalog.
- `hard-eng.gates.json` defines `shipping.ui_paths`, and `analysis_options.yaml` configures `flutter_skill_lints: ^0.16.0`.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Delegated implementation task — roll out UI single-source compliance on `fix/ui-single-source`, keep visual appearance unchanged, leave `hard-eng.gates.json` without `ui_library`, and open a PR without merging.

## Acceptance + steps

- [x] T1 Bump `flutter_skill_lints` to `^0.16.0` in `analysis_options.yaml` and resolve all 30 `ui_base_control_outside_library` errors by extracting `IconAction`, `PaperCheckbox`, `PaperSwitch`, `PaperField`, `PaperDropdown`, `PaperSegmented`, and `PaperDialog` into `lib/core/widgets/` → `dart analyze --fatal-infos .` reports 0 issues.
- [x] T2 Move the raw `Color.white` and `Color.black` literals in `macos/Runner/Native/Overlay.swift` into `macos/Runner/Native/Theme.swift`, and add `lib/app/*` and `lib/core/router/*` to `shipping.ui_paths` in `hard-eng.gates.json`.
- [x] T3 Mirror all token colours, lengths, and font families in `DESIGN.md` YAML front matter (naming `Fonts.titleFamily` and `Fonts.handFamily` in `lib/core/theme/fonts.dart`) and generate `UI-LIBRARY.md` with complete use descriptions → `b5` `ui_whole.ui_findings_whole` reports `B5_UI_HITS: 0`.
- [x] T4 Verify every changed screen and shared control keeps its visual appearance unchanged and passes all four Flutter accessibility guidelines (`textContrastGuideline`, `labeledTapTargetGuideline`, `iOSTapTargetGuideline`, `androidTapTargetGuideline`) → `test/core/widgets/ui_single_source_guideline_test.dart`, full Flutter test suite, and macOS Swift checks pass.

## Baseline + execution

Result: Passed
Evidence: 2026-11-23 on `origin/main` updated via PR #52 (`4cbb8bd`, Hard Eng `ce348c30`): baseline `b5` `ui_whole` audit reported 8 findings (`lib/app/*`, `lib/core/router/*`, missing `UI-LIBRARY.md`, missing `DESIGN.md` front matter, and 3 `Overlay.swift` raw colours); bumping `flutter_skill_lints` to `^0.16.0` reported 30 `ui_base_control_outside_library` findings.
Execution: One builder. Extract 7 shared widgets into `lib/core/widgets/`, update 20 presentation files and 2 widget tests, tokenize `Overlay.swift` colours in `Theme.swift`, update `Fonts` constants and `DESIGN.md` front matter, write `UI-LIBRARY.md`, add `test/core/widgets/ui_single_source_guideline_test.dart`, verify `B5_UI_HITS: 0`, and run full Hard Eng checks and `challenge`.

## Risks + recovery

- Wrapping base controls (`Checkbox`, `TextField`, `AlertDialog`, `IconButton`, `Switch`, `DropdownButtonFormField`, `SegmentedButton`) could alter widget keys or semantics if forwarded incorrectly. Mitigated by forwarding keys and identical Material properties, verifying all existing widget and responsive tests, adding `meetsGuideline` checks across all changed widgets, and comparing before/after renders.
- Recovery: revert the `fix/ui-single-source` branch or PR commits cleanly.

## ux_reference

Result: Passed
Evidence: Widget-test renders of the real app (`CaptureApp` at 1240 × 860 Mac window) on Settings and Home taken at the merge base (`origin/main`) and at the PR head (`fix/ui-single-source`), plus independent `look` inspection.
Surface: Existing — `/` and `/settings`, rendered by `lib/features/shell/presentation/screens/app_shell_screen.dart` and `lib/features/settings/presentation/screens/settings_screen.dart`
Before: ![Before, Settings screen on main](../../build/ux/ui-single-source/before-settings.png)
Proposed: ![After, Settings screen on fix/ui-single-source](../../build/ux/ui-single-source/after-settings.png)
Capture: Rendered via a temporary `matchesGoldenFile`-style widget render at 1240 × 860 with bundled Caveat, Patrick Hand, and MaterialIcons fonts loaded, comparing `origin/main` and `fix/ui-single-source` byte-for-byte.
Review: Before and After renders of Home and Settings are byte-identical (0 pixel difference), confirming UI appearance is unchanged; independent `look` inspection passed against `DESIGN.md` and `UI-LIBRARY.md`.

## Verification

Result: Passed
Evidence: 2026-11-23. `dart analyze --fatal-infos .` → 0 issues with `flutter_skill_lints: ^0.16.0`; `dart format --output=none --set-exit-if-changed` → 0 changes; `swift format lint --strict` → 0 issues; `b5` `ui_whole.ui_findings_whole` with `["lib/core/widgets/**"]` → `B5_UI_HITS: 0`; before/after renders of Home (`033ec5fe`) and Settings (`dc31fb86`) at 1240 × 860 are SHA-256 byte-identical; `flutter test --no-pub` → 272/272 passed including `test/core/widgets/ui_single_source_guideline_test.dart` (all four `meetsGuideline` checks).
E2E: Passed — full Flutter widget journeys (`test/app/capture_app_test.dart`, `test/app/settings_flow_test.dart`, `test/app/responsive_layout_test.dart`) and `test/core/widgets/ui_single_source_guideline_test.dart` pass.

Delivery target: PR
Delivery: Pending — open PR from `fix/ui-single-source` against `main` (do not merge).
