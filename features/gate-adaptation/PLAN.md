# Gate adaptation for the empty scaffold

Status: Complete

## Outcome + scope

Make the Hard Eng baseline pass on the new Flutter macOS project by repairing its actual failures. No product behaviour beyond the first pure-Dart module the performance and boundary gates need as a subject.

## Repository context

Owners: `test/widget_test.dart`, `.dart-decimaterc.json`, `lib/domain/`, `test/domain/`, `test/performance/`, `pubspec.yaml`.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Autonomous — user brief §2 (proceed through repository approval steps to implementation); local commits and a local merge into `main` only; no remote exists and nothing is pushed.

## Acceptance + steps

- [x] Scaffold widget test compiles against the real `MainApp` → `flutter test` passes.
- [x] Architecture boundaries use real prefixes (`lib/domain` → no `services/app/ui`; `lib/services` → no `app/ui`; `lib/app` → no `ui`) → forbidden probe import fails, removed probe passes.
- [x] Performance suite has a real workload (candidate splitting + coverage of a ~1,200-word transcript) with a 50 ms budget → passes; budget of 1 ms fails.
- [x] Candidate splitter keeps UTF-16 offsets/excerpts and loses no text → `dart test test/domain` passes.
- [x] Full gate → `python3 .hooks/hard-eng.py check` passes.

## Baseline + execution

Result: Passed
Evidence: Current baseline after repair = `python3 .hooks/hard-eng.py check --plan-stage Draft` → all 13 checks PASS. Original failed baseline (preserved): same command on 2c0980d → FAIL types-lint + strict-types-lint + tests (installer's `test/widget_test.dart` references a nonexistent `MyApp`), FAIL import-boundaries (no project prefixes), FAIL performance (no `test/performance`); PASS format, security, dead-code-duplicates, secrets-files, secrets-history.
Execution: Single builder on `repair/gate-adaptation`; merge into local `main`, then rebase `feature/capture-alpha`.

## Risks + recovery

Coverage threshold could fail with a near-empty app → cover real code with real tests only; no filler tests.

## ux_reference

N/A — no visible change; the default scaffold screen is unchanged.

## Verification

Result: Passed
Evidence: `python3 .hooks/hard-eng.py check --plan-stage Draft` → all 13 checks PASS (line coverage 104/125 = 83.2%). Boundary probe `lib/domain/probe_bad.dart` importing `lib/ui/probe.dart` → decimate reported `boundary-violation`; removed → "No findings". Performance budget set to 1 ms → test failed (8.38 ms measured); restored 50 ms → passed. `dart test test/domain test/performance` → 13 passed.
E2E: N/A — gate adaptation only; no user journey changes.
