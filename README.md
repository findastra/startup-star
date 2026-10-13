# Startup Star

*A pet app by Astra.* The star in the Windows system tray that brings out Astra's desktop pets.

## Open it
- Double-click **Startup Star** in this folder or in the Start menu.
- It also starts by itself when you sign in to Windows. Turn that off from the star's right-click
  menu ("Start desktop pets when I sign in").
- Can't see the star? Click the **^** by the clock. To keep it showing, go to Settings →
  Personalization → Taskbar → Other system tray icons and turn on desktop-pets.

## Clicks
- Tray star, left click: show or hide the star on the desktop.
- Desktop star, double-click: line the pets up on the floor, or let them roam again.
- Right click: the menu (show or hide the pets, line up, start at sign-in, quit).

## Where things are today
| What | Where |
|---|---|
| The program | `Documents\Projects\astras-pet-os\bin\desktop-pets-20261008.exe` (the old date in the name is misleading; the current build is from 2026-10-11) |
| Its source | `scripts\desktop-pets-20261011.cs` in [astras-pet-apps](https://github.com/findastra/astras-pet-apps) |
| How it is built | `build-desktop-pets-20261011.ps1` in the same repo |
| Shortcuts | `scripts\install-shortcuts-20261012.ps1` here makes them |

Startup Star does not copy or change the program yet. It only gives it a name, a shortcut and
a home.

## What is next (not built)
Under ASTRAS_PET_OS the star becomes the **desktop host** (Phase 7 of the
[migration plan](https://github.com/findastra/astras-pet-apps/blob/main/docs/migration/PLAN.md)).
This repo is where it moves. Planned:
1. Move the desktop source and build here, with a real program name (`startup-star.exe`) and a
   version number, keeping Codex's current code as the starting point.
2. The star only **shows** pets; their work runs in separate workers, so closing the star never
   stops a pet's work.
3. Tray clicks from the architecture: single = star, double = herd, triple = lineup or roam,
   right = menu.
4. An installer and a self-test, and a clear rollback instead of a pile of `before-*` copies.
