# Capture

A private voice diary for Mac and iPhone: press a shortcut (or Record with Capture on iPhone), speak, review the separated notes and tasks, approve, and save them to your own Notion library.

## Register

Product — a private, single-user alpha for the owner's own Mac and iPhone, Notion workspace and TypeSafe key.

## Users

One person (the owner) who wants to capture spoken thoughts from any app without switching context, and later find them organised in Notion as notes, tasks and timed reminders on the Mac or iPhone.

## Problem

Spoken diary entries mix unrelated thoughts (learning, personal life, ideas, errands). Filing one recording as one item loses structure, while splitting per sentence fragments coherent thoughts. Tasks and reminders buried in speech are easily missed or mis-dated.

## Product Purpose

Intended flow (planned; the repository currently contains only the empty Flutter macOS scaffold):

Shortcut → record → stop → transcribe locally with Parakeet-TDT-0.6B-v3 → code proposes candidate boundaries → Jev (TypeSafe API) judges boundaries and classifies each thought into user-configured groups → code builds an editable proposal (titles from source text, deterministic dates) → user approves (or auto-save does, when on and nothing needs a decision) → save capture, audio, transcript, notes and tasks to Notion → schedule approved reminders on the device.

Notion is the source of truth for saved content and group definitions; a local SQLite database holds drafts, pending operations and a rebuildable cache. Nothing capture-related is written or scheduled before approval.

## Brand Personality / Tone

Quiet, personal, notebook-like. Plain, truthful status wording ("Draft on this Mac", "Task saved; reminder not scheduled"). No hype, no chatbot voice, no AI-written summaries.

## Boundaries

- macOS and iPhone (iOS 26+); Flutter plus small Swift components where needed. iPhone transcription uses FluidAudio/Core ML; the Mac uses sherpa-onnx.
- Private BYOK alpha: owner's Notion internal-connection token and TypeSafe API key, stored in Keychain.
- No accounts, backend, public OAuth, billing, platforms other than Mac and iPhone (no iPad layout), calendar or Apple Reminders integration, chat, semantic search, weekly summaries, recurring tasks, live captions, always-on listening or agent frameworks.
- No Gemini, ChatGPT or other generative model; no automatic fallback provider. Jev makes narrow typed decisions only.
- Captures up to five minutes in this alpha; English date phrases only.
- Audio never goes to TypeSafe. The transcript and group descriptions go to TypeSafe; approved content and recordings go to Notion; drafts/cache stay local. The app is not offline-only.
- No destructive Notion changes, publishing or pushing without permission.

## Stack

- Flutter app: `lib/`, `macos/`, `ios/` (with the `CaptureControls` Control Centre extension), `pubspec.yaml`.
- iPhone CI and TestFlight: `codemagic.yaml`. Mac releases: `.github/workflows/release.yml`.
- Tests: `test/`.
- Hard Eng checks: `hard-eng.gates.json`, `AGENTS.md`.
