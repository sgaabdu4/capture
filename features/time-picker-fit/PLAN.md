# Time picker fit

Status: Complete

## Outcome + scope

The time picker opened from the "9:00 AM" chip shows its whole hour and minute on iPhone 13 (390 × 844 pt), its selected AM/PM is readable, and the app's other low-contrast text and state icon meet WCAG AA. Out of scope: the date picker, the editor and review card layout, and the Mac page layout.

## Repository context

Owners: `lib/core/theme/app_theme.dart` owns the text theme. Material 3's `showTimePicker` (called from `lib/features/capture/presentation/extensions/when_pickers.dart`) draws the dial's digits and separator in `TextTheme.displayLarge`, which here is the 84 pt Caveat hero wordmark. The picker's fields are a fixed 80 pt tall, so the digits are squeezed and clipped, most visibly the right side of "00". The Mac picker has the same clipping.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Human-loop — on 2026-09-23 the owner asked for a fix, proof and a PR, and said not to change the Mac layout. When asked, they chose to fix the shared theme so the Mac picker's clipped digits are fixed as well ("Fix both"). No Mac page or dialog size changes. Later on 2026-09-23 the owner approved the merge ("merge all"), which publishes one Mac release.

## Acceptance + steps

- [x] T1 On iPhone 13, the hour and minute digits are laid out at their full height, so nothing clips them → `test/app/capture_app_test.dart` "the time picker opened from the review card shows its whole time on iPhone 13" passes. Without the fix it fails: 84 > 80.
- [x] T3 The selected AM/PM is readable: cream on ink, 16.2:1, like the selected hour. Before it was dark text on `Palette.muted` (tertiary colours unset, falling back to secondary), about 3.3:1 against WCAG AA 4.5:1 → after screenshot at 390 × 844 and 1280 × 800.
- [x] T4 The iPhone bottom bar's unselected labels and icons are readable: `onSurfaceVariant` (`Palette.muted`, 4.89:1 on the bar) instead of `Palette.faint` (2.39:1) → `test/app/responsive_layout_test.dart` "every page keeps its text readable on a phone and on the Mac" runs `textContrastGuideline` on every page at 390 pt and the Mac window. It fails without the fix (2.39 on each label) and passes with it.
- [x] T5 Text-field hints use `labelMedium` (muted, 5.2:1 on a field) instead of `Palette.faint` (2.5:1) → before/after screenshot of the To-Do search field.
- [x] T6 The setup step's unchecked circle, a state icon, uses `onSurfaceVariant` (5.1:1) instead of `Palette.faint` (2.49:1, under the 3:1 needed for icons) → before/after screenshot of setup.
- [x] T2 Every page and dialog still lays out from 320 pt to 4K → `test/app/responsive_layout_test.dart` passes.

## Baseline + execution

Result: Passed
Evidence: 2026-09-23 on the task branch from `origin/main` (56e1482), with only this plan added: `python3 .hooks/hard-eng.py check --plan-stage Draft` → 14/14 PASS, exit 0.
Execution: One builder. Add `timePickerTheme.hourMinuteTextStyle = displayMedium` (the 48 pt page-title style) in `buildAppTheme`, plus the focused phone test.

## Risks + recovery

- Digits are smaller on Mac too (84 → 48 pt). That was agreed; recovery is to revert the theme lines.
- `textContrastGuideline` only checks text it can find in the semantics tree; it missed the AM/PM case, so screenshots remain that proof.
- Deliberately unchanged: excluded proposal items and disabled buttons are faded (WCAG exempts inactive controls; no fade keeps grey text at 4.5:1). `Palette.faint` stays for the "not saved" status dot, which sits beside a text label giving the same status.

## ux_reference

Result: Passed
Evidence: Widget-test renders of the real app at the same route, state and viewport, before and after the fix (icons show as boxes because the test does not load the Material icon font).
Surface: Existing — Material time picker from the editor's time chip, themed by `lib/core/theme/app_theme.dart`
Before: ![Before, iPhone 13 time picker with "00" clipped](../../build/ux/time-picker-fit/before/iphone13-time-picker.png)
Proposed: ![After, iPhone 13 time picker showing the whole 9 : 00](../../build/ux/time-picker-fit/proposed/iphone13-time-picker.png)
Capture: `matchesGoldenFile` of `MaterialApp` in a throwaway test (not committed): phone editor at 390 × 844 and Mac at 1280 × 800, dial and keyboard entry, the time chip tapped. The keyboard-entry mode already used 48 pt and is unchanged.
Review: Inspected iPhone 13 dial and entry modes and the Mac dial, and the before/after bottom bar, search hint (`build/ux/time-picker-fit/proposed/iphone-nav-and-hint.png`) and setup step (`iphone-setup-step.png`); the Mac has the same clipping before and is fixed after, with no change to the dialog or page size.

## Verification

Result: Passed
Evidence: 2026-09-23. The new test fails without the fix (`Expected: <= 80.0, Actual: 84.0`) and passes with it. `flutter test test/app/responsive_layout_test.dart test/app/capture_app_test.dart` → 17/17 passed. `python3 .hooks/hard-eng.py check --plan-stage Complete` → 14/14 PASS, exit 0.
E2E: Passed — the iPhone review card → Edit → time chip → picker journey, run as a widget test at 390 × 844 pt.

Delivery target: Merge
Delivery: Pending — PR #23 with before/after screenshots and green Hard Eng CI; merge to `main`.
