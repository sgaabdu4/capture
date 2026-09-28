# Capture CI and native agent migration

Status: Draft

## Outcome + scope

Make release verification a native workflow dependency and update the released Claude/Codex scaffold. Preserve app change detection, macOS compatibility builds, signing, notarization, Sparkle and iOS release policy. Apply the required expanded suites and lint profile through meaningful app repairs and verified producer corrections. A failed library cache write must leave prior entries usable, and a reminder scheduling error must preserve owed work while later captures continue.

## Repository context

Owners: `.github/workflows/release.yml`, `.github/workflows/hard-eng.yml`, `hard-eng.gates.json`, native agent settings and the supported updater; existing notifiers, typed IDs/data mappers, form screens, theme/extensions, localized messages and their tests.

## Decisions + authorization

Blockers: The prior released lint-profile migration reported 114 findings in existing app/test code. App repairs are prepared and independently reviewed; the matching canonical lint is published and full candidate verification is next. The baseline repairs proceed under the Draft repair route.
Handoff: Approval
Authority: Autonomous — the user authorized released-source migration, pnpm wherever supported, Claude/Codex-only tooling, one combined pull request per repository, review, checks and merge.
Expanded suites and lint profiles are required under the user's later explicit instruction; preserve the strict canonical profile while repairing meaningful findings.

## Acceptance + steps

- [ ] Released scaffold at `2e246601a5dab5148cd8c9b829acb416da869294` → supported updater succeeds; repeat changes nothing; repository CLAUDE aliases and retired tooling are absent while unique guidance remains.
- [ ] The release job starts only after the hard-eng job succeeds, without polling on a macOS runner. → native gates and workflow checks pass with the original assertions.
- [ ] CI-only changes continue to build and publish no app; app-changing pull requests retain the DMG and public What's New checks. → existing native tests and configured checks pass.
- [ ] Actual verification and runner timing → retain measured commands/results; make no unsupported percentage claim.
- [x] A failed SQLite refresh preserves prior entries and sync time, clears refreshing when mounted and surfaces a truthful failure; a later refresh can succeed. → existing repository regression with a real SQLite write failure.
- [x] A native reminder scheduling exception preserves owed progress, continues later captures and reports failure; retry schedules only still-owed reminders. → existing notifier regression with the real notification wrapper/native channel.
- [ ] Required strict lint profile → repair actual ownership/error handling findings, preserve persisted checkpoint values and app behavior, and resolve proven detector defects at the canonical producer without suppressions or baselines.
- [x] Home reopened after midnight reflects the new local day without a library mutation. → the existing widget journey leaves for Settings, advances the same clock and returns to Home with unchanged library state.

## Baseline + execution

Result: Passed
Evidence: Starting `480c55c9ca3b7dcf07baec876848aabe6819f416` completed [native CI](https://github.com/sgaabdu4/capture/actions/runs/35868109827) successfully before migration; the later candidate's required-profile failure is recorded below.
Execution: One builder at existing owners, followed by diff review and the native candidate, Ready and shipping checks. Heavy suites run only in the coordinated slot.

## Risks + recovery

Preserve custom settings and instruction tails before retirement. Stop on a conflicting updater plan; recover a known migration change through Git without overwriting unrelated work. Retain existing publishing and product safety guards.

## ux_reference

Existing layouts and interactions remain the reference; failure feedback reports the library/reminder recovery outcome without claiming success. Verify before/after states with an untitled Library task in Today, To-do and an expanded group; a group without a description; and an untitled phone/native review item with approval still blocked. Absent text is omitted, so row heights may change; preserve the other controls, dates and details and record actual visual evidence rather than assuming identical layout.

## Verification

Result: Failed
Evidence: The released d208 candidate ran in 105.35s: eleven native gates passed, including tests (22.002s); the strict analyzer failed with 86 errors, 27 warnings and one info after the lint-profile upgrade. No scaffold migration was applied. The independent recovery and midnight-repair reviews are clear. Nullable ReviewCardRow generation passed in 1.61s with all other current outputs preserved. The corrected midnight regression failed at its intended assertion against the former keepAlive projection (one stale task instead of three, 4.817s). The reviewed repair and both real recovery cases, date-only menu and absent review-title validation all pass (5/5, 4.112s). Native temporary generation and rendering restored all current generated and fixture bytes. Full required-profile verification remains pending.
E2E: Pending — the existing database/provider and native-notification-channel regressions prove failure, permission denial and owed retry. Fourteen private before/after Flutter renders with the bundled text and Material icon fonts passed in 4.758s/4.661s for Mac/phone Home, To-do, expanded groups and phone review. Inspected omission moves dates into absent title gaps, shortens the descriptionless group header and untitled review row, and retains controls and blocked approval without observed overflow. These use the actual app with synthetic existing fixtures; the before phase restores the exact prior UI owners on the current fixture, not the entire old revision. They are not a live device or native Swift review window. Exact hosted app/DMG checks remain required for delivery. Private artifacts: `/tmp/hard-eng-capture-profile-proof-e6qllac4/material-icons`.

Delivery target: Merge
Delivery: Pending — exact pull request checks, guarded merge and merged-main results remain required.
