# Record request test wait

Status: Complete

## Outcome + scope

The two "Record with Capture" tests that start a recording from a request wait until the flow is actually recording, instead of draining the event queue a fixed number of times. They then pass however long the start takes. Out of scope: app code (the flow itself is correct) and the other tests.

## Repository context

Owner: `test/features/capture/presentation/notifiers/capture_flow_notifier_test.dart`, group "Record with Capture". A `RecordRequested` event calls `start()` without awaiting it. `_start()` asks for the microphone, then creates a draft on disk (`createDraft`, real file I/O in a temp folder), then starts the recorder. `pumpEventQueue()` only drains microtasks and zero-length timers, so it can return before that I/O finishes.

## Decisions + authorization

Blockers: None
Handoff: Approval
Authority: Human-loop — on 2026-09-23 the Hard Eng gate reported "Record with Capture a request while idle starts recording: Expected recording, Actual idle", and the owner asked to "fix it and open a PR".

## Acceptance + steps

- [x] T1 "a request while idle starts recording" and "a second request, or one arriving mid-start, keeps a single recording" wait for `CapturePhase.recording` through a listener, with a 5-second limit, rather than using `pumpEventQueue()`. Proof: with the mic check made 50 ms slow (a local experiment, not committed), the old tests fail with the gate's exact message and the new tests pass; without the delay, the file passes repeatedly.

## Baseline + execution

Result: Passed
Evidence: 2026-09-23 on `fix/record-request-test-wait` from `origin/main` (56e1482), before any test change: `python3 .hooks/hard-eng.py check --plan-stage Draft --base 4b825dc642cb6eb9a060e54bf8d69288fbee4904` → 14/14 PASS, exit 0. The gate failure itself was intermittent: the test passed in 5 of 5 isolated reruns, 12 of 12 loaded group runs and 5 of 5 loaded full-suite coverage runs.
Execution: One builder; one test file, then PR.

## Risks + recovery

- A real regression that never reaches recording would now fail after 5 seconds with a timeout instead of at once. Recovery: the timeout names the phase it waited for.

## ux_reference

N/A — tests only; no app screens change.

## Verification

Result: Passed
Evidence: 2026-09-23 on `fix/record-request-test-wait`.
- Cause reproduced: with the group's mic check made 50 ms slow (not committed), the old tests failed with the gate's message "Expected: CapturePhase.recording, Actual: CapturePhase.idle" (2 of 5 in the group failed). With the same delay, the fixed group passed 5/5.
- Without the delay: `flutter test test/features/capture/presentation/notifiers/capture_flow_notifier_test.dart` → 20/20 passed, five runs in a row. `dart analyze` on the file → no issues.
- Gates: `python3 .hooks/hard-eng.py check --plan-stage Complete` → 14/14 PASS, exit 0.
E2E: N/A — tests only.

Delivery target: PR
Delivery: Pending — PR opened after Hard Eng CI passes.
