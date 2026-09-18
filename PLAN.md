# Capture macOS alpha

Status: Draft

## Outcome + scope

Working private Mac alpha: shortcut → record → local Parakeet transcript → code candidate boundaries + Jev decisions → editable proposal → approve → Notion (captures, audio, library, groups) → approved macOS reminders. Non-goals: brief §1 exclusions (accounts, backend, OAuth, other platforms, calendars, chat, search, summaries, recurring tasks, live captions, other models).

## Repository context

Owners: `lib/` (Dart app + logic), `macos/Runner/` (Swift overlay panel, hotkey, audio, notifications), `test/` (unit/widget/eval fixtures), `PRODUCT.md`, `DESIGN.md`. Starting point = empty `flutter create --platforms=macos --empty` scaffold (commit 9cb35cf) + Hard Eng scaffold (2c0980d).

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Autonomous — user brief §2 "proceed to implementation instead of stopping after the plan"; local commits on `feature/capture-alpha` only; no push, publish or unrelated Notion changes.

## Acceptance + steps

- [ ] Pending detailed acceptance after baseline.

## Baseline + execution

Result: Pending
Evidence: Pending `python3 .hooks/hard-eng.py check --plan-stage Draft`
Execution: Single builder; slices per brief §18.

## Risks + recovery

Pending.

## ux_reference

Result: Pending
Evidence: Pending
Surface: New — no prior UI
Before: N/A — empty scaffold with no prior UI
Proposed: Pending
Capture: Pending
Review: Pending

## Verification

Result: Pending
Evidence: Pending
E2E: Required — shortcut from another app → speak → review → approve → Notion + reminder.
