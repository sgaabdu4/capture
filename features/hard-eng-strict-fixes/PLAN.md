# Hard Eng strict rules

Status: Complete

## Outcome + scope

The project passes Hard Eng's strict checks with no regression: no comment blocks, no skipped test, CRAP at most 30, no unused class member, flutter_skill_lints 0.14.0, a current freshness report. Non-goals: new features.

## Repository context

Owners: `lib/`, `test/`, `integration_test/`, `ios/`, `macos/`, `analysis_options.yaml`, `.dart-decimaterc.json`, `pubspec.yaml`.
Same cause: the old rules allowed doc comments and an env-gated skip; the new ones refuse both.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Autonomous. The owner asked for the strict-rules repair across all projects (2026-11-15). The PR stays open for the coordinator to merge.

## Acceptance + steps

- [x] Every flagged comment block is removed, Swift files included.
- [x] The live Notion journey is no longer skipped by an environment flag: it lives in `integration_test/`, which `flutter test` does not run.
- [x] `.dart-decimaterc.json` holds `health.max_crap` 30 and every function is at or under it, by real tests or refactors.
- [x] No unused class member.
- [x] `flutter_skill_lints` is `^0.14.0`.
- [x] Freshness and every other gate pass.

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
Evidence:
- No regression: no test deleted or weakened and no gate or rule removed. The live Notion journey moved from `test/live/` to `integration_test/` and no longer skips on `E2E_LIVE`; it still runs on request with the command in the README. It needs real keys, so it was not run here (not checked). `flutter test`: 269 passed, none skipped (177 before, 2 skipped).
- New tests: native events, Notion page shapes and dates, label texts, group rules, groups notifier and seeding, capture analysis, delete and reminder in the flow notifier, recording upload, Notion workspace connect, entry editor reminder and day picker, speech model download.
- Run 1, the branch with its own `.hooks`, `python3 .hooks/hard-eng.py check --plan-stage Draft`: exit 0, 21 gate results PASS (lockfile, performance, actionlint, format-lint ios and macos, secrets-history, vulnerabilities, format, freshness, zizmor, secrets-files, security for ios, macos and the app, types-lint, tests for the app, macos and ios, dead-code-duplicates, duplicates for macos and ios). Log: run 1 of this plan's builder, `P6-fix-run1-draft.log`.
- Run 2, a scratch copy with Hard Eng develop `.hooks` and `.agents` (80756642, without `.agents/starters`, which no project install holds): exit 0, the same gates PASS. Log `P6-fix-run2-develop.log`.
- Run 3, `npx -y dart-decimate@0.0.76 check . --threshold 0 --strict --format json` (version printed first): exit 0, verdict pass, 0 findings. Log `P6-fix-run3-dd076.log`.
- Findings judged false: none.
