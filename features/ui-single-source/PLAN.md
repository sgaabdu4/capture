# UI single-source rollout

Status: Complete

## Outcome + scope

Move all raw Flutter base controls outside `lib/core/widgets/` into shared library controls, remove raw colour literals from `macos/Runner/Native/Overlay.swift`, mirror token colours, integer lengths, and font families in `DESIGN.md` YAML front matter (and note fractional stroke/bar widths in prose), generate and complete `UI-LIBRARY.md`, upgrade `flutter_skill_lints` to `^0.16.0`, and include `lib/app/*` and `lib/core/router/*` in `shipping.ui_paths`. The touched screens must also pass the `look` review, so every visible fault the reviews raised on them is fixed here as a real UX fault: an off switch that looks on, field labels below the smallest type token, link buttons and the sidebar chip under the tap target size, a clear button far from the date chips, a reminder switch off the left edge, recording actions far from their details with no filled main action, a helper subtitle, a decorative motto, a long speech credit under the Speech model heading, hints cut short on a phone, and shortcut symbols that did not draw.

Out of scope: adding `ui_library` to `hard-eng.gates.json` (deferred until the `b5` release), redesigning screens beyond the faults the `look` reviews raised, and changing non-UI features.

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
- [x] T4 Every changed screen and shared control passes the Flutter accessibility guidelines (`textContrastGuideline`, `labeledTapTargetGuideline`, `iOSTapTargetGuideline`, `androidTapTargetGuideline`; `iOSTapTargetGuideline` only for the pre-existing iPhone-only `ReviewCardButton` 46 pt height) → `test/core/widgets/ui_single_source_guideline_test.dart::changed groups and library widgets meet accessibility guidelines`, `::recordings cards, link buttons and the sidebar meet accessibility guidelines`, `::the Recordings page meets accessibility guidelines`, `::iPhone wording for the speech credit and privacy meets guidelines`, and `test/app/responsive_layout_test.dart::every page keeps its text readable on a phone and on the Mac`.
- [x] T5 An off switch looks different from an on switch (theme thumb, track and outline by state) → `test/core/widgets/paper_switch_test.dart::a switch that is off does not look like one that is on`.
- [x] T6 `PaperField` shows its label above the field at the `bodySmall` size, merged into one accessible node, and draws the themed border without a decoration → `test/core/widgets/paper_field_test.dart::a field label sits above the field at the smallest type token or larger` and `::a field without a decoration still draws the themed border`.
- [x] T7 `LinkButton` has a 48 point tap target (`Sizes.tapTarget`, mirrored in `DESIGN.md`) and a flush mode; the sidebar `NotionChip` is 48 points tall → `test/core/widgets/link_button_test.dart` and the guideline test above.
- [x] T8 `WhenRow` keeps the clear button with the date chips and starts the reminder switch at the left edge, and its switch carries the label while the reminder text stays measured for contrast → `test/features/capture/presentation/widgets/when_row_test.dart::the clear button sits with the chips and the switch starts at the left edge` and `test/app/responsive_layout_test.dart::every page keeps its text readable on a phone and on the Mac`.
- [x] T9 Each recording shows its status, details and actions in one column; the one main action is a filled `InkButton` and Delete is aligned text → `test/features/capture/presentation/widgets/capture_card_test.dart`.
- [x] T10 Remove the Recordings helper subtitle and the sidebar motto, move the speech model credit to Privacy at 18 words, and shorten the key and link hints → `test/features/settings/presentation/widgets/speech_credit_test.dart` and `test/features/settings/presentation/screens/hints_fit_test.dart::every key and link hint shows whole on a phone`.
- [x] T11 Draw the shortcut modifier symbols through an explicit symbol font fallback (`Fonts.symbolFamily`, mirrored in `DESIGN.md`) → `test/features/settings/presentation/widgets/shortcut_keys_test.dart::the shortcut keys fall back to a font that holds the modifier symbols`.
- [x] T12 The key field turns Replace off until a key is typed, the linked Notion page field says `Current page`, the auto-save explanation is 20 words, the whole dialog panel is capped at `Sizes.dialogWidth` (`PaperDialog.width`), the dialog backdrop is the `Palette.scrim` token, and the expand arrow sits beside the recording details with status and time on one line → `test/features/settings/presentation/screens/typesafe_step_screen_test.dart`, `test/features/settings/presentation/screens/hints_fit_test.dart`, `test/features/settings/presentation/widgets/autosave_text_test.dart`, `test/core/widgets/paper_dialog_test.dart::the dialog panel is no wider than the dialog token` and `test/features/capture/presentation/widgets/capture_card_test.dart`.
- [x] T13 The delete dialog names the recording by its age and length and is only as tall as its content; each field and its button stay within `Sizes.fieldsWidth` (560, mirrored in `DESIGN.md`); the dropdown chevron uses `Palette.muted`; field borders use the `Palette.fieldEdge` token at 3 to 1 contrast; the page hint fits on a phone inside the real page and card padding → `test/features/capture/presentation/widgets/delete_capture_dialog_test.dart`, `test/features/settings/presentation/screens/typesafe_step_screen_test.dart::the key field and its button stay close together on a wide screen`, `test/core/widgets/paper_dropdown_test.dart`, `test/core/widgets/paper_field_test.dart::the field border has at least 3 to 1 contrast against the field fill` and `test/features/settings/presentation/screens/hints_fit_test.dart`.
- [x] T14 Recording actions wrap and hints wrap to two lines at large text sizes, the ready speech model line fits one line on a phone, page actions sit beside the page title, the off switch outline has 3 to 1 contrast, the delete dialog names the capture by status, age and length, the TypeSafe line no longer repeats the Privacy text, a recording's status line keeps a 12 point gap above its actions, and the ready green (`Palette.ok`) has 3 to 1 contrast on the card → `test/features/capture/presentation/widgets/capture_card_test.dart`, `test/features/settings/presentation/screens/hints_fit_test.dart`, `test/features/settings/presentation/widgets/step_header_test.dart`, `test/core/widgets/page_frame_test.dart`, `test/core/widgets/paper_switch_test.dart`, `test/core/theme/palette_test.dart` and `test/features/capture/presentation/extensions/capture_labels_test.dart`.

## Baseline + execution

Result: Passed
Evidence: 2026-11-23 on `origin/main` updated via PR #52 (`4cbb8bd`, Hard Eng `ce348c30`): baseline `b5` `ui_whole` audit reported 8 findings (`lib/app/*`, `lib/core/router/*`, missing `UI-LIBRARY.md`, missing `DESIGN.md` front matter, and 3 `Overlay.swift` raw colours); bumping `flutter_skill_lints` to `^0.16.0` reported 30 `ui_base_control_outside_library` findings.
Execution: One builder. Extract 7 shared widgets into `lib/core/widgets/`, update 20 presentation files and 2 widget tests, then fix each visible fault the `look` reviews raised as its own commit with a failing test first, tokenize `Overlay.swift` colours in `Theme.swift`, update `Fonts` constants and `DESIGN.md` front matter, write `UI-LIBRARY.md`, add `test/core/widgets/ui_single_source_guideline_test.dart`, verify `B5_UI_HITS: 0`, and run full Hard Eng checks, `look`, and `challenge`.

## Risks + recovery

- Wrapping base controls (`Checkbox`, `TextField`, `AlertDialog`, `IconButton`, `Switch`, `DropdownButtonFormField`, `SegmentedButton`) could alter widget keys or semantics if forwarded incorrectly. Mitigated by forwarding keys and identical Material properties, adding accessible `semanticLabel` / `MergeSemantics` where checkboxes and switches lacked labels, verifying all existing widget and responsive tests, adding `meetsGuideline` checks across all changed widgets, and comparing before and after renders at 390, 768 and 1240 px.
- The visible fixes change layout on the Recordings cards, the Edit task dialog, the Settings page and the sidebar. Mitigated by one test per fix, the responsive layout test from 320 to 3840 pt, and the three-width captures.
- Recovery: revert the `fix/ui-single-source` branch or PR commits cleanly.

## ux_reference

Result: Passed
Evidence: Widget-test renders of the real app (`CaptureApp`) at 390, 768 and 1280 px on Settings, Recordings, the Delete recording dialog and the Edit task dialog, taken at the merge base `origin/main` (`4cbb8bd`, scratch worktree) and at this branch, with the bundled Caveat, Patrick Hand and Material Icons fonts and the macOS symbols font loaded. All 12 pairs changed on purpose (for example Delete dialog on phone `8db4823f` to `13e06874`). The To-Do page is not in the proposal, because no file of that page changed.
Surface: Existing — `/recordings`, rendered by `lib/features/capture/presentation/screens/recordings_screen.dart`
Before: ![Before, delete dialog on phone on main](../../build/ux/ui-single-source/before-delete-dialog-phone.png)
Proposed: ![After, delete dialog on phone on fix/ui-single-source](../../build/ux/ui-single-source/after-delete-dialog-phone.png)
Controls: `PaperSwitch` — new `lib/core/widgets/atoms/paper_switch.dart` — mockup ![PaperSwitch](docs/design/shared-controls.png); `PaperField` — new `lib/core/widgets/atoms/paper_field.dart` — mockup ![PaperField](docs/design/shared-controls.png); `PaperDropdown` — new `lib/core/widgets/atoms/paper_dropdown.dart` — mockup ![PaperDropdown](docs/design/shared-controls.png); `PaperCheckbox` — new `lib/core/widgets/atoms/paper_checkbox.dart` — mockup ![PaperCheckbox](docs/design/shared-controls.png); `PaperSegmented` — new `lib/core/widgets/atoms/paper_segmented.dart` — mockup ![PaperSegmented](docs/design/shared-controls.png); `IconAction` — new `lib/core/widgets/atoms/icon_action.dart` — mockup ![IconAction](docs/design/shared-controls.png); `PaperDialog` — new `lib/core/widgets/paper_dialog.dart` — mockup ![PaperDialog](docs/design/shared-controls.png); `LinkButton` — reuses `lib/core/widgets/atoms/link_button.dart`; `InkButton` — reuses `lib/core/widgets/atoms/ink_button.dart`
Capture: Rendered `CaptureApp` through a widget test with a repaint boundary at 390 × 844, 768 × 1024 and 1280 × 860 (Settings at 2000 high), with the same scratch test run once at the merge base and once at this branch, so fonts and icons match on both sides.
Review: Inspected every After image. The Edit task dialog now shows the label above each field, the off switch with a light track, the clear button beside the chips and the switch at the left edge. Recordings shows one column per card with a filled Review button and aligned Delete text. Settings shows whole hints, the shortcut symbols and the credit under Privacy. The delete dialog names the recording and wraps its content.
Rules:

- Mistake-proof: Pass — Delete asks again in `DeleteCaptureDialog`, and the reminder switch shows off with a light track and grey knob, and on with an ink track and cream knob.
- Least effort: Pass — 1 click to open Review, 2 clicks to delete a recording (Delete, then confirm), and 1 click to save an edit.
- Observe: Pass — status, age, length and item counts come from the capture record, so nobody confirms them.
- Undo: Pass — Delete confirms first and says that the copy in Notion stays, and Review can be left without saving.
- No clutter: Pass — 21 kept, 3 removed on the phone Recordings page (the helper subtitle, the sidebar motto and the second credit line under Speech model).
- Hierarchy: Pass — each card has one filled action (Review or Retry), Delete and Cancel are plain text, and the dialog has one filled Delete.
- Alignment: Pass — a recording's status, details and actions share one left edge, the clear button sits with the date chips, the reminder switch starts at the field edge, and Show me how starts at the text edge.
- Spacing: Pass — `Spacing` tokens separate fields, chips and card lines, with more space between groups than inside them.
- Design system: Pass — field labels use the `bodySmall` token (14 pt), controls come from `lib/core/widgets/`, and the symbol font is a token in `DESIGN.md`.
- Messages: Pass — the Shortcut line shows its keys, and every key and link hint shows whole on a phone.
- States: Pass — saved and waiting recordings, the off and on switch, and the filled and plain actions render their true state.
- Time: Pass — ages and times keep their local, relative form (`20 minutes ago`, `8:00 PM`).
- Audit: N/A — a local note capture app with no staff or admin roles.
- Accessibility: Pass — link buttons, the sidebar chip and the fields are at least 48 pt, and the guideline tests cover contrast, labels and tap targets.
- Widths: Pass — captured at 390, 768 and 1280 px, and `test/app/responsive_layout_test.dart` covers 320 to 3840 pt with no overflow.
- Performance: Pass — no data read or rebuild path changed, and `test/performance/text_pipeline_perf_test.dart` passes in the full run.

## Verification

Result: Passed
Evidence: 2026-11-23. `dart analyze --fatal-infos .` (`flutter_skill_lints: ^0.16.0`) → 0 issues; `dart format --output=none --set-exit-if-changed .` → 0 changes; `b5` `ui_whole.ui_findings_whole` with Hard Eng develop (`["lib/core/widgets/**"]`) → `B5_UI_HITS: 0`; `flutter test --no-pub` → 311/311 passed. The two `check` runs, `look` and `challenge` results are in the PR body.
E2E: Passed — full Flutter widget journeys (`test/app/capture_app_test.dart`, `test/app/settings_flow_test.dart`, `test/app/responsive_layout_test.dart`) and the guideline tests pass.
Real service: N/A — pure UI single-source refactor; no Notion, Jev, or external API code changed.
Retro: The new guideline tests caught a 31 pt field and a 37 pt sidebar chip, and a full `flutter test` run caught that merged semantics on the reminder switch row failed `test/app/responsive_layout_test.dart`; the switch now carries its own label and the duplicate text is hidden from screen readers. Running `challenge` caught missing `Complete` plan fields, an untested Clear search `IconAction` state, `Review declined:` single-line syntax, and `Controls:` wording; next time check plan validation via `--quick` before the first commit, keep `DESIGN.md` strictly factual, and format every declined finding as `Review declined: finding :: reason`.
Review declined: ReviewCardButton 46 pt height fails Android 48 pt tap-target guideline :: pre-existing unchanged iPhone-only overlay control mirroring macOS Overlay.swift (height 46), which meets iOSTapTargetGuideline (44 pt); resizing it would violate the unchanged visual appearance requirement, and ui_single_source_guideline_test.dart tests ReviewCard in its own viewport against contrast, semantic label, and iOS tap-target guidelines.
Review declined: DESIGN.md YAML front matter omits 1.4px, 1.6px, and 3.5px lengths :: b5 ui_tokens.py DART_LENGTH only extracts integer or .0 Dart static constants, so adding fractional lengths to YAML front matter causes token_findings failures; those three dimensions are documented in DESIGN.md prose while YAML front matter mirrors all 48 parser-extracted lengths with B5_UI_HITS 0.
Review declined: the plan directs a merge beyond the recorded approval :: the task brief for this change states the merge authority, and the Authority line cites only the user's standing rule that task PRs merge once their checks pass.

Delivery target: Merge
Delivery: Pending — checks, challenge, PR, CI, and merge to `main`.
