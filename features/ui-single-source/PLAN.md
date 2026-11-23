# UI single-source rollout

Status: Complete

## Outcome + scope

Move all raw Flutter base controls outside `lib/core/widgets/` into shared library controls, remove raw colour literals from `macos/Runner/Native/Overlay.swift`, mirror token colours, integer lengths, and font families in `DESIGN.md` YAML front matter (and note fractional stroke/bar widths in prose), generate and complete `UI-LIBRARY.md`, upgrade `flutter_skill_lints` to `^0.16.0`, and include `lib/app/*` and `lib/core/router/*` in `shipping.ui_paths`. Visual appearance stays unchanged across all screens and overlays.

Out of scope: adding `ui_library` to `hard-eng.gates.json` (deferred until the `b5` release), redesigning screens or tokens, and changing non-UI features.

## Sources + coverage

Sources: N/A — the delegated task request is the only source.

## Repository context

Owners:
- `lib/core/theme/` owns colour, font, spacing, radius, size, overlay, and breakpoint tokens (`app_theme.dart`, `fonts.dart`, `overlay_tokens.dart`, `palette.dart`, `radii.dart`, `sizes.dart`, `spacing.dart`, `breakpoints.dart`, `capture_colors.dart`).
- `lib/core/widgets/` owns shared UI library controls (`InkButton`, `LineButton`, `LinkButton`, `IconAction`, `PaperField`, `PaperCheckbox`, `PaperSwitch`, `PaperDropdown`, `PaperSegmented`, `PaperDialog`, `PaperCard`, `TapSurface`, `IconBadge`, `StatusDot`, `EmptyNote`, `Underlined`, `PageFrame`, `ExpandableCard`).
- `macos/Runner/Native/Theme.swift` owns native macOS overlay colours used by `macos/Runner/Native/Overlay.swift`.
- `DESIGN.md` and `UI-LIBRARY.md` document the token values and shared widget catalog.
- `hard-eng.gates.json` defines `shipping.ui_paths`, and `analysis_options.yaml` configures `flutter_skill_lints: ^0.16.0`.
Same cause: N/A — first UI single-source rollout in this repository; searched all `lib/features/*/presentation/**`, `lib/app/**`, `lib/core/router/**`, and `macos/Runner/**` files and consolidated every remaining raw base control and raw colour literal.
Single source: Base controls (`IconButton`, `Checkbox`, `Switch`, `TextField`, `DropdownButtonFormField`, `SegmentedButton`, `AlertDialog`) now live only in `lib/core/widgets/` (searched all `lib/` via `flutter_skill_lints: ^0.16.0` `ui_base_control_outside_library`); macOS overlay colours live only in `macos/Runner/Native/Theme.swift` (searched `macos/Runner/` via `b5` `ui_whole`); font family names (`Fonts.titleFamily`, `Fonts.handFamily`), colours, and integer lengths are owned in `lib/core/theme/` and mirrored in `DESIGN.md` YAML front matter; shared widgets are catalogued in `UI-LIBRARY.md`.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Standing rule — merge each task PR once its checks pass (user, 2026-10-07); cross-project strict-rule PRs approved (user, 2026-11-15).

## Acceptance + steps

- [x] T1 Bump `flutter_skill_lints` to `^0.16.0` in `analysis_options.yaml` and resolve all 30 `ui_base_control_outside_library` errors by extracting `IconAction`, `PaperCheckbox`, `PaperSwitch`, `PaperField`, `PaperDropdown`, `PaperSegmented`, and `PaperDialog` into `lib/core/widgets/` → `test/core/widgets/ui_single_source_guideline_test.dart::shared library controls meet accessibility guidelines and forward actions` and `dart analyze --fatal-infos .` reports 0 issues.
- [x] T2 Move the raw `Color.white` and `Color.black` literals in `macos/Runner/Native/Overlay.swift` into `macos/Runner/Native/Theme.swift`, and add `lib/app/*` and `lib/core/router/*` to `shipping.ui_paths` in `hard-eng.gates.json` → N/A — static lint and macOS Swift build/test verification (`b5` `ui_whole.ui_findings_whole` reports 0 Swift colour and `ui_paths` findings; `swift format lint` and `macos` XCTests pass).
- [x] T3 Mirror all token colours, integer lengths, and font families in `DESIGN.md` YAML front matter (naming `Fonts.titleFamily` and `Fonts.handFamily` in `lib/core/theme/fonts.dart` and noting fractional stroke/bar widths `1.4`, `1.6`, `3.5` in prose) and generate `UI-LIBRARY.md` with complete use descriptions → `test/core/widgets/ui_single_source_guideline_test.dart::shared library controls meet accessibility guidelines and forward actions` and `b5` `ui_whole.ui_findings_whole` reports `B5_UI_HITS: 0`.
- [x] T4 Verify every changed screen and shared control keeps its visual appearance unchanged and passes Flutter accessibility guidelines (`textContrastGuideline`, `labeledTapTargetGuideline`, `iOSTapTargetGuideline`, and `androidTapTargetGuideline` for shared/desktop controls; `iOSTapTargetGuideline` for the pre-existing iPhone-only `ReviewCardButton` 46 pt height) → `test/core/widgets/ui_single_source_guideline_test.dart::changed groups and library widgets meet accessibility guidelines`, `test/app/responsive_layout_test.dart::every page keeps its text readable on a phone and on the Mac`, and byte-identical before/after renders.

## Baseline + execution

Result: Passed
Evidence: 2026-11-23 on `origin/main` updated via PR #52 (`4cbb8bd`, Hard Eng `ce348c30`): baseline `b5` `ui_whole` audit reported 8 findings (`lib/app/*`, `lib/core/router/*`, missing `UI-LIBRARY.md`, missing `DESIGN.md` front matter, and 3 `Overlay.swift` raw colours); bumping `flutter_skill_lints` to `^0.16.0` reported 30 `ui_base_control_outside_library` findings.
Execution: One builder. Extract 7 shared widgets into `lib/core/widgets/`, update 20 presentation files and 2 widget tests, tokenize `Overlay.swift` colours in `Theme.swift`, update `Fonts` constants and `DESIGN.md` front matter, write `UI-LIBRARY.md`, add `test/core/widgets/ui_single_source_guideline_test.dart`, verify `B5_UI_HITS: 0`, and run full Hard Eng checks, `look`, and `challenge`.

## Risks + recovery

- Wrapping base controls (`Checkbox`, `TextField`, `AlertDialog`, `IconButton`, `Switch`, `DropdownButtonFormField`, `SegmentedButton`) could alter widget keys or semantics if forwarded incorrectly. Mitigated by forwarding keys and identical Material properties, adding accessible `semanticLabel` / `MergeSemantics` where checkboxes and switches lacked labels, verifying all existing widget and responsive tests, adding `meetsGuideline` checks across all changed widgets, and comparing before/after renders byte-for-byte.
- Recovery: revert the `fix/ui-single-source` branch or PR commits cleanly.

## ux_reference

Result: Passed
Evidence: Widget-test renders of the real app (`CaptureApp`) on Recordings (`26e8dad3`), Edit task dialog (`0cb2ebec`), To-Do (`be0ff97f`, `74d5fa99`), Home (`033ec5fe`), and Settings (`dc31fb86`), taken at `origin/main` and `fix/ui-single-source`, are all SHA-256 byte-identical; inspected `after-delete-dialog.png` with `look`.
Surface: Existing — `/recordings`, rendered by `lib/features/capture/presentation/screens/recordings_screen.dart`
Before: ![Before, delete dialog on phone on main](../../build/ux/ui-single-source/before-delete-dialog.png)
Proposed: ![After, delete dialog on phone on fix/ui-single-source](../../build/ux/ui-single-source/after-delete-dialog.png)
Controls: None — visual appearance is unchanged; existing Material base controls were wrapped verbatim in shared library widgets under `lib/core/widgets/` with no new visual control design.
Capture: Rendered `CaptureApp` via widget test at 390 × 844 and 1240 × 860 with bundled Caveat, Patrick Hand, and MaterialIcons fonts loaded, comparing `origin/main` and `fix/ui-single-source` PNG bytes (all six pairs byte-identical).
Review: Inspected `/recordings`, the Edit task dialog, `/todo`, `/`, and `/settings` before and after; visual appearance is completely unchanged across all screens, dialogs, cards, fields, checkboxes, and buttons.
Rules:

- Mistake-proof: Pass — deleting a recording opens `DeleteCaptureDialog` for confirmation; Review opens the proposal editor without auto-saving.
- Least effort: Pass — 1 clicks to open Review, trigger delete confirmation, expand a recording card, or switch navigation tabs.
- Observe: Pass — each recording card clearly shows its status dot, status label ("Saved to Notion" or "Waiting for your review"), age, duration, and saved item counts.
- Undo: Pass — Delete asks for confirmation in `DeleteCaptureDialog` before removing a recording, and Review can be dismissed without saving.
- No clutter: Pass — 10 kept, 0 removed on the phone Recordings screen (settings icon, two recording cards with status/actions, and five bottom navigation tabs).
- Hierarchy: Pass — the handwritten underlined Recordings heading leads the page, followed by paper capture cards with quiet action icons and bottom navigation.
- Alignment: Pass — heading, subtitle, capture cards, status dots, trailing actions, and bottom navigation align cleanly within the 390 px viewport.
- Spacing: Pass — consistent `Spacing` and `Radii` tokens separate the header, capture cards, internal metadata lines, and bottom navigation.
- Design system: Pass — paper palette (`#fbf9f3`, `#fdfbf7`, `#edeae4`, `#1a1916`, `#6e6a63`, `#5fba4b`, `#c98a2b`), `Caveat` page heading, `Patrick Hand` labels, rounded paper cards, and shared `lib/core/widgets/` controls match `DESIGN.md` and `UI-LIBRARY.md`.
- Messages: Pass — subtitle ("Kept on this Mac. Saved captures are also in Notion."), status labels, and item counts use clear, plain copy.
- States: Pass — saved and waiting-for-review states render truthfully with distinct status dots and actions; empty states are verified by `test/app/responsive_layout_test.dart`.
- Time: Pass — relative capture times ("20 minutes ago") and durations ("0:14") render from local time formatting (`test/core/data/notion/notion_shapes_test.dart`).
- Audit: N/A — local desktop/iPhone note capture app with no multi-user staff/admin audit log.
- Accessibility: Pass — `test/core/widgets/ui_single_source_guideline_test.dart` and `test/app/responsive_layout_test.dart` verify contrast, semantic labels, and tap target guidelines across changed controls.
- Widths: Pass — `test/app/responsive_layout_test.dart` verifies every page and dialog from 320 pt to 3840 pt with zero overflow.
- Performance: Pass — `test/performance/text_pipeline_perf_test.dart` passes within budget and control wrappers add no extra rebuilds or allocations.

## Verification

Result: Passed
Evidence: 2026-11-23. `dart analyze --fatal-infos .` (`flutter_skill_lints: ^0.16.0`) → 0 issues; `dart format --output=none --set-exit-if-changed` → 0 changes; `swift format lint --strict` → 0 issues; `b5` `ui_whole.ui_findings_whole` (`["lib/core/widgets/**"]`) → `B5_UI_HITS: 0`; before/after PNG renders of phone To-Do (`be0ff97f`), desktop To-Do (`74d5fa99`), Home (`033ec5fe`), and Settings (`dc31fb86`) are SHA-256 byte-identical; `flutter test --no-pub` → 275/275 passed including `test/core/widgets/ui_single_source_guideline_test.dart`.
E2E: Passed — full Flutter widget journeys (`test/app/capture_app_test.dart`, `test/app/settings_flow_test.dart`, `test/app/responsive_layout_test.dart`) and `test/core/widgets/ui_single_source_guideline_test.dart` pass.
Real service: N/A — pure UI single-source refactor; no Notion, Jev, or external API code changed.
Retro: A full `flutter test` run caught that merged semantics on the reminder switch row failed `test/app/responsive_layout_test.dart`; the switch now carries its own label and the duplicate text is hidden from screen readers. Running `challenge` caught missing `Complete` plan fields, an untested Clear search `IconAction` state, `Review declined:` single-line syntax, and `Controls:` wording; next time check plan validation via `--quick` before the first commit, keep `DESIGN.md` strictly factual, and format every declined finding as `Review declined: finding :: reason`.
Review declined: ReviewCardButton 46 pt height fails Android 48 pt tap-target guideline :: pre-existing unchanged iPhone-only overlay control mirroring macOS Overlay.swift (height 46), which meets iOSTapTargetGuideline (44 pt); resizing it would violate the unchanged visual appearance requirement, and ui_single_source_guideline_test.dart tests ReviewCard in its own viewport against contrast, semantic label, and iOS tap-target guidelines.
Review declined: DESIGN.md YAML front matter omits 1.4px, 1.6px, and 3.5px lengths :: b5 ui_tokens.py DART_LENGTH only extracts integer or .0 Dart static constants, so adding fractional lengths to YAML front matter causes token_findings failures; those three dimensions are documented in DESIGN.md prose while YAML front matter mirrors all 48 parser-extracted lengths with B5_UI_HITS 0.

Delivery target: Merge
Delivery: Pending — checks, challenge, PR, CI, and merge to `main`.
