# Hard Eng strict rules

Status: Complete

## Outcome + scope

The project passes Hard Eng's strict checks with no regression: no comment blocks, no skipped test, CRAP at most 30, no unused class member, flutter_skill_lints 0.14.0, a current freshness report. Non-goals: new features.

## Repository context

Owners: `lib/`, `test/`, `integration_test/`, `ios/`, `macos/`, `analysis_options.yaml`, `.dart-decimaterc.json`, `pubspec.yaml`.
Single source: the comment, skip and CRAP rules live in Hard Eng's checks and `.dart-decimaterc.json`; the shared flow test setup lives once in `test/helpers/capture_flow_harness.dart`.
Same cause: the old rules allowed doc comments and an env-gated skip; the new ones refuse both.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Autonomous. The owner asked for the strict-rules repair across all projects (2026-11-15). The PR stays open for the coordinator to merge.

## Acceptance + steps

- [x] Every flagged comment block is removed, Swift files included → N/A — a deleted comment has no behaviour; the HE-COMMENT-LINES pass of the check is the proof.
- [x] The live Notion journey is not skipped by an environment flag; it lives in `integration_test/`, which `flutter test` does not run → N/A — the journey needs real keys; the HE-NO-SWITCH-OFF pass and a `flutter test` run with no skipped test are the proof.
- [x] A transcript is analysed into the items Jev proposed → `test/features/capture/presentation/notifiers/capture_flow_editing_test.dart::a transcript becomes the items Jev proposed`.
- [x] A reminder follows the due date and time in the review flow → `test/features/capture/presentation/notifiers/capture_flow_editing_test.dart::turning it on sets the reminder at the due date and time`.
- [x] A group needs a name → `test/features/groups/domain/group_rules_test.dart::a blank name is missing`.
- [x] A saved capture uploads its recording once → `test/features/capture/data/datasources/notion_capture_remote_datasource_test.dart::uploads the audio, attaches the upload by id and returns it`.
- [x] Connecting again keeps the known Notion workspace → `test/features/settings/data/datasources/notion_workspace_remote_datasource_test.dart::keeps it without creating or searching anything`.
- [x] A finished speech model download makes the model ready → `test/features/settings/presentation/notifiers/settings_notifier_test.dart::a finished download makes the model ready and clears the progress`.
- [x] A picked day keeps the time of day → `test/features/library/presentation/screens/entry_dialog_screen_test.dart::a picked day replaces the date and keeps the time`.
- [x] Every function is at or under CRAP 30, no class member is unused, and `health.max_crap` is 30 → N/A — dart-decimate 0.0.76 with that setting is the proof: 0 findings.
- [x] `flutter_skill_lints` is `^0.14.0` → N/A — `dart analyze --fatal-infos .` reports no issues with it.
- [x] Freshness and every other gate pass → N/A — the gates are the proof, recorded in Verification.

## Baseline + execution

Result: Passed
Evidence: Before the work, a sealed scan of main (8c4c8fd) reported 2 HE-NO-SWITCH-OFF hits (the two live-test `skip:` lines), 139 HE-COMMENT-LINES blocks, 22 functions over CRAP 30 (dart-decimate 0.0.76), 1 unused class member (`AppWidgetKeys.notionDisconnectButton`) and a failing freshness gate (flutter_local_notifications 23.0.1 to 23.0.2). The Flutter SDK is the Mac's 3.50.0; CI floats on stable, so no pinned SDK applies.
Execution: One builder on `fix/hard-eng-strict-rules`, one commit for each rule or package, a draft PR from the first commit.

## Risks + recovery

A comment held a reason the code does not show: the reason is kept as one terse line.

## ux_reference

N/A — no visible change.

## Verification

Result: Passed
Evidence: three runs and the regression check, listed below.
- No regression: no test deleted or weakened and no gate or rule removed. The live Notion journey moved from `test/live/` to `integration_test/` and no longer skips on `E2E_LIVE`; it still runs on request with the command in the README. It needs real keys, so it was not run here (not checked). `flutter test`: 269 passed, none skipped (177 before, 2 skipped).
- New tests: native events, Notion page shapes and dates, label texts, group rules, groups notifier and seeding, capture analysis, delete and reminder in the flow notifier, recording upload, Notion workspace connect, entry editor reminder and day picker, speech model download.
- Run 1, the branch with its own `.hooks`, `python3 .hooks/hard-eng.py check --plan-stage Draft`: exit 0, 21 gate results PASS (lockfile, performance, actionlint, format-lint ios and macos, secrets-history, vulnerabilities, format, freshness, zizmor, secrets-files, security for ios, macos and the app, types-lint, tests for the app, macos and ios, dead-code-duplicates, duplicates for macos and ios). 
- Run 2, a scratch copy with Hard Eng develop `.hooks` and `.agents` (80756642, without `.agents/starters`, which no project install holds): exit 0, the same gates PASS. Log `P6-fix-run2-develop.log`.
- Run 3, `npx -y dart-decimate@0.0.76 check . --threshold 0 --strict --format json` (version printed first): exit 0, verdict pass, 0 findings. Log `P6-fix-run3-dd076.log`.
- Findings judged false: none.
Retro: None — nothing failed twice; the first iPhone tests run timed out at 240 s on a cold build and passed on the next run, and the plan check named each missing field once.
E2E: N/A — no user journey changed; the existing widget journeys in `test/app/` still pass, and the live Notion journey needs real keys.
