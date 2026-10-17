# Rules for assistants working on Startup Star (startup-star)

*A tool by Astra.* Public credit is always **Astra**. A tool does a job but has no face, so Startup Star gets no pet art, moods or intelligence levels; it is the Friendly Farmer's tool.

Started by Claude Opus 5.5 (`claude-opus-5-5`), 2026-10-12, as Astra's head chat. Record your model name and version here when you change something substantial.

## Read first
- This repo will be the ASTRAS_PET_OS **desktop host**. The architecture lives in
  `ASTRAS_PET_OS.md` in [astras-pet-apps](https://github.com/findastra/astras-pet-apps); where
  it disagrees with this file, it wins. Write `ASTRAS_PET_OS` (with the S) in files and code.
- Today the program still lives in `astras-pet-apps` (`scripts/desktop-pets-20261011.cs`,
  `bin/desktop-pets-20261008.exe`). Do not move or delete it there until the move is planned,
  tested and approved by Astra. Codex has been doing the desktop work: coordinate through a
  handoff card before changing the desktop source.
- Preserve Astra's desktop decisions recorded in `docs/pet-revisions-20261011.md` and
  `docs/tray-star-handoff-20261011.md` in astras-pet-apps (sizes, no sparkles, outlines,
  Paper Girl and File Master together).

## Rules
- The star shows pets; it never becomes the pets' execution engine.
- Ask Astra before creating the GitHub repo, publishing, or changing startup settings on her PC.
- Say plainly what is not done.
- The shortcut wears the folder's star, never the program's own icon (Astra, 2026-10-17; Flash Audit A53). Claude Opus 5.5, 2026-10-17.
- Star fix and live sync, Claude Opus 5.5 (`claude-opus-5-5`), 2026-10-17: the shortcut script finds astras-pet-os next to this repo instead of the old `Documents\Projects` path, and also writes the live-sync sign-in launcher; `scripts/live-sync-20261017.ps1` fast-forwards clean, behind repos (PetOS every 30 s, others every 5 min) and restarts the star when pets or art change. After the folder moves to `Documents\Astra's PetOS`, run `scripts/install-shortcuts-20261012.ps1` once. The star's local draft list (`%LOCALAPPDATA%stras-pet-apps\desktop-drafts-20261011.json`) holds absolute art paths; a folder move breaks it the same way (backup of the pre-fix copy kept beside it).
