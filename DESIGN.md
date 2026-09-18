# Capture Design

## Overview

A macOS main window plus a menu-bar panel and a tiny desktop recording overlay. The appearance follows the owner's approved Capture reference images, which have not yet been added to this repository. No UI is implemented yet; the default Flutter scaffold in `lib/main.dart` is a placeholder. Exact colour, font and spacing values will be recorded here when the theme is built from the references.

Principles: notebook-like and personal, calm, truthful states, no decorative features or dead controls.

## Colors

Approved direction, with no values set yet: a light cream background, black or near-black text, thin neutral separators, restrained shadows. The overlay uses dark charcoal with cream waveform and controls. No coloured category dots, bright gradients or new brand colours.

## Typography

Approved direction: handwritten, notebook-style typography matching the original Capture designs. Fonts must be licensed, bundled and readable. No fonts have been chosen yet.

## Layout

Consistent spacing and soft rounded, paper-like cards. The home screen centres a prominent black circular microphone button. The overlay pill sits bottom-centre on the active display, clear of the Dock, with the compact review card directly above it.

## Components

No components are implemented yet. The planned composition follows.

- Atoms: outline icons, the black circular microphone button, text styles, separators.
- Molecules: capture list row, note/task row with group and date, status label, waveform with stop control.
- Organisms: recording pill, "Ready to save?" review card with a scrollable proposal list, group editor, menu-bar panel (Record, Open app, Settings, Quit).
- Templates: desktop shell with navigation (Capture wordmark home, Groups, Recordings, To-do, Upcoming), settings, and a combined onboarding flow.
- Pages: Home, Groups, Recordings, To-do, Upcoming, Settings, Onboarding, focused proposal editor.

## Do's and Don'ts

- Do build real widgets. Keep theme tokens (type, spacing, colours, radii, icons) small and reusable.
- Do show truthful statuses and empty states. Show no recording indicator after the microphone stops.
- Do hide deferred features instead of adding dead buttons.
- Don't use screenshots as backgrounds, draw a fake menu bar, or change the wallpaper.
- Don't use generic Material styling, chatbot bubbles, oversized statistics or a redesign.
- Don't let clicking outside the review card, or pressing Enter in another app, approve a save.
