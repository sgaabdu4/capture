# Setup record test wait

Status: Complete

## Outcome + scope

The app test "first launch shows the setup steps and still records" waits until recording has actually started, instead of giving the start a fixed 100 ms of real time. It then passes however long the draft takes to reach disk. Out of scope: app code (the flow is correct) and other tests.

## Repository context

Owner: `test/app/capture_app_test.dart`. Tapping Record asks for the microphone, creates the draft on disk (real file I/O, hence `runAsync`) and then starts the recorder. The rest of that chain runs in the test's fake-async zone, so it only moves on when the test pumps. The old test allowed 100 ms of real time, then verified. Under load the draft write took longer, so `startRecording` had not been called yet. This is the same cause PR #22 fixed in the notifier tests.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Human-loop — on 2026-09-23 the Hard Eng stop-hook gate on `main` (a1867f8) reported "first launch shows the setup steps and still records" failing while the machine's load average was 72. Hard Eng requires every reported finding to be repaired as its own change. The owner had approved "merge all" and asked for Hard Eng findings to be fixed ("fix it then instead of stopping, hard eng gave us good feedback so fix the issue"). Tests only, so merging publishes no Mac release.

## Acceptance + steps

- [x] T1 The test waits in 100 ms steps of real time, pumping after each one, until `startRecording` is called, for at most 5 seconds (then `verify` names the missing call). Proof: with the mic check made 150 ms slow (a local experiment, not committed), the old test fails with "No matching calls", and the new test passes with 150 ms and 1 s delays. Without a delay it passes repeatedly.

## Baseline + execution

Result: Passed
Evidence: 2026-09-23 on `fix/setup-record-test-wait` from `origin/main` (a1867f8). The gate failure was intermittent: the test passed 5 of 5 isolated reruns right after the failed gate run, at load average 72.
Execution: One builder; one test, then PR.

## Risks + recovery

- A real regression that never starts recording now fails after 5 seconds instead of 100 ms. Recovery: `verify` still reports the missing `startRecording` call.

## ux_reference

N/A — tests only; no app screens change.

## Verification

Result: Passed
Evidence: 2026-09-23 on `fix/setup-record-test-wait`. `python3 .hooks/hard-eng.py check --plan-stage Complete` → 15/15 PASS, exit 0 (line coverage 76.54%).
- Cause reproduced: with a 150 ms mic check, the old test fails ("No matching calls" for `startRecording`). With 150 ms and 1 s delays, the new test passes.
- Without a delay: 5 of 5 passes in a row. `dart analyze --fatal-infos` on the file → no issues. A first attempt that awaited the call inside `runAsync` timed out, because the chain needs pumps; that approach was replaced.
E2E: N/A — tests only.

Delivery target: Merge
Delivery: Pending — PR, merge to `main`, main CI green.
