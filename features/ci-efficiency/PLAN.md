# Capture CI and native agent migration

Status: Complete

## Outcome + scope

Make release verification a native workflow dependency and update the released Claude/Codex scaffold. Preserve app change detection, macOS compatibility builds, signing, notarization, Sparkle and iOS release policy. Apply the required expanded suites and lint profile through meaningful app repairs. A failed library cache write must leave prior entries usable, an unexpected body-read error must leave details unavailable until retry, and a reminder scheduling error must preserve owed work while later captures continue.

## Repository context

Owners: `.github/workflows/release.yml`, `hard-eng.gates.json`, `analysis_options.yaml`, native agent settings and the supported updater; existing notifiers, typed IDs/data mappers, form screens, theme/extensions, localized messages and their tests.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Autonomous — the user authorized released-source migration, Claude/Codex-only tooling, dependency upgrades, one combined pull request per repository, review, checks and merge.
Expanded suites and lint profiles are required under the user's later explicit instruction; the strict canonical profile is preserved while meaningful findings are repaired.

## Acceptance + steps

- [x] Latest verified scaffold → supported updater succeeds; repeat changes nothing; repository CLAUDE aliases and retired tooling are absent while unique guidance remains. → the supported setup installed `7eebdaf3d52b4bec956b1d21f416a7d7389f79b9` as its own commit; the repeat reported no newer CI-verified revision and left the tree clean; `CLAUDE.md`, `.github/hooks/hard-eng.json`, `.github/mcp.json` and the standalone `hard-eng.yml` workflow are retired and `AGENTS.md` keeps the unique rules.
- [x] The release job starts only after the hard-eng job succeeds, without polling on a macOS runner. → `release.yml` runs `hard-eng` as a job; `dmg` and `release` declare `needs: [changes, hard-eng]`; the polling step and its `checks: read` permission are removed; actionlint and zizmor pass.
- [x] CI-only changes continue to build and publish no app; app-changing pull requests retain the DMG and public What's New checks. → the `changes` app filter, `release` condition `needs.changes.outputs.app == 'true'`, the runner selection for `dmg` and the What's New steps are unchanged in the diff; actionlint and zizmor pass.
- [x] Actual verification and runner timing → measured local commands and results are recorded below with no percentage claim; hosted runner timing belongs to Delivery.
- [x] A failed SQLite refresh preserves prior entries and sync time, clears refreshing when mounted and surfaces a truthful failure; a later refresh can succeed. → existing repository regression with a real SQLite write failure.
- [x] A native reminder scheduling exception preserves owed progress, continues later captures and reports failure; retry schedules only still-owed reminders. → existing notifier regression with the real notification wrapper/native channel.
- [x] Body preparation preserves entries on exception or typed failure, permits retry and ignores obsolete requests. The originating visible screen shows loading, then opens an immutable editor snapshot; save/delete dispatch only after modal dismissal. → existing repository failure/retry case, bounded stale-request regression, actual route-away/root-modal journey and typed modal intent ordering.
- [x] Required strict lint profile → `flutter_skill_lints` ^0.13.0 with every existing linter rule and analyzer exclusion retained; `dart analyze --fatal-infos .` reports no issues; no hand-written ignore comments or baselines were added (the only added `// ignore:` lines are freezed generator output).
- [x] Native events remain detached and overlapping while errors are reported once by the existing owner. → existing recording request, overlapping start, interruption and limit journeys.
- [x] Failed key replacement and reconnect retain form input and release busy state; only newly persisted success clears input. → actual form journeys using failed persistence followed by a successful retry, including already-configured state.
- [x] Completed Notion connection reloads the seeded Groups cache and refreshes the Library from the setup screen that owns the connect form. → `completed Notion connection reloads seeded Groups and refreshes Library` widget journey; removing either call fails it at its intended assertion.
- [x] Failed reset leaves the current page and retained state available; only completed reset/reloads request Home. → existing reset journey with an injected storage failure before its successful retry.
- [x] Terminal native UI effects report internally while recording, transcription and reminder scheduling keep their failure contracts. → existing native channel/recording/reminder journeys and the strict profile pass.
- [x] Destination commands navigate through typed routes from the existing ShellRoute context without changing startup order. → existing startup, navigation and native recording/review journeys.
- [x] Home reopened after midnight reflects the new local day without a library mutation. → the existing widget journey leaves for Settings, advances the same clock and returns to Home with unchanged library state.

## Baseline + execution

Result: Passed
Evidence: Starting `480c55c9ca3b7dcf07baec876848aabe6819f416` completed [native CI](https://github.com/sgaabdu4/capture/actions/runs/35868109827) successfully before migration.
Execution: One builder at existing owners, followed by diff review, the full local gate, the pre-push snapshot gate and hosted checks.

## Risks + recovery

Preserve custom settings and instruction tails before retirement. Stop on a conflicting updater plan; recover a known migration change through Git without overwriting unrelated work. Retain existing publishing and product safety guards.

## ux_reference

Result: Passed
Evidence: Twelve private Flutter renders of the actual app on synthetic fixtures were inspected: an untitled Library task in Today, To-do and an expanded group, and a group without a description, on Mac and phone.
Surface: Existing — Home, To-do and Groups screens under `lib/features/*/presentation` with the existing theme and widgets.
Before: ![Mac Home before](../../build/ux/ci-efficiency/before/mac-home.png)
Proposed: ![Mac Home proposed](../../build/ux/ci-efficiency/proposed/mac-home.png)
Capture: Flutter widget-test renders with the bundled text and Material icon fonts, before and proposed runs each passing 2/2 capture cases; the other pairs are `mac-todo`, `mac-groups`, `phone-home`, `phone-todo` and `phone-groups` under the same folders. The before run restores the prior UI owners on the current fixture, not the whole old revision.
Review: Absent titles and descriptions are omitted, so dates move into the title gap and the descriptionless group header shortens; controls, dates and details remain without observed overflow. The entry dialog's group list now follows Groups state live instead of a snapshot taken when the dialog opened.

## Verification

Result: Passed
Evidence: `python3 .hooks/hard-eng.py check --base origin/main --plan-stage Draft` passed 12/12 gates in 108s with line coverage 78.84% (4032/5114; minimum 70%), 159 tests, analyzer clean and zero security, secret, vulnerability, actionlint and zizmor findings. The added connect journey passes (1/1, 9.2s) and the settings flow file passes 4/4; removing the Groups reload fails it with an empty group list, removing the Library refresh fails it with one refresh instead of two, and the source is restored byte-for-byte.
E2E: Passed — real CaptureApp widget journeys cover startup, navigation, settings connect/replace/reset failure and retry, body editing, midnight Home and native recording/reminder channels; the live Notion/Typesafe suite needs real credentials and was not run.

Delivery target: Merge
Delivery: Pending — hosted proof that `hard-eng` finishes before `dmg`, the DMG and What's New checks on this pull request, hosted runner timing, the squash merge and the merged-main `release` run. This change touches the app, so the CI-only no-publish path stays proven by the unchanged `changes` filter rather than by this merge.
