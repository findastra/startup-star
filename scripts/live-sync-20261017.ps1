# Startup Star live sync: keep Astra's Pet Apps on this PC current with GitHub, so changes show up live.
# Claude Opus 5.5 (claude-opus-5-5), 2026-10-17, at Astra's request ("just needs to grab changes, faster if possible").
#
# Every $FastSeconds it fetches astras-pet-os; every $SlowSeconds it fetches every other repo in the folder.
# A repo is fast-forwarded only when it is safe: on a branch with an upstream, no uncommitted or unpushed work,
# and strictly behind. Nothing is merged, reset, stashed or overwritten; anything else is only logged.
# When astras-pet-os brings new pets, art or a new desktop program, the star restarts so the desktop shows it.
#
#   powershell -ExecutionPolicy Bypass -File .\live-sync-20261017.ps1            # run (loops until stopped)
#   powershell -ExecutionPolicy Bypass -File .\live-sync-20261017.ps1 -Once      # one pass, then exit
param(
  [string]$Root = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)),
  [int]$FastSeconds = 30,
  [int]$SlowSeconds = 300,
  [switch]$Once
)
$ErrorActionPreference = "Continue"
$state = Join-Path $env:LOCALAPPDATA "astras-pet-apps"
New-Item -ItemType Directory -Force -Path $state | Out-Null
$log = Join-Path $state "live-sync-20261017.log"
function Log([string]$msg) {
  $line = "{0}  {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $msg
  Add-Content -LiteralPath $log -Value $line
  if ((Get-Item -LiteralPath $log).Length -gt 1MB) { Move-Item -Force -LiteralPath $log -Destination "$log.old" }
}

# Only one copy runs.
$mutex = New-Object System.Threading.Mutex($false, "Local\astras-pet-apps-live-sync")
if (-not $mutex.WaitOne(0)) { exit 0 }

$petos = Join-Path $Root "astras-pet-os"
$starExe = Join-Path $petos "bin\desktop-pets-20261008.exe"
$starPaths = @('pets.json', 'art/frames/', 'desktop-art/', 'bin/desktop-pets-20261008.exe')

function Sync-Repo([string]$dir) {
  $name = Split-Path -Leaf $dir
  $branch = git -C $dir symbolic-ref --quiet --short HEAD 2>$null
  if (-not $branch) { return $null }
  $upstream = git -C $dir rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>$null
  if (-not $upstream) { return $null }
  git -C $dir fetch --quiet --prune 2>$null
  if ($LASTEXITCODE -ne 0) { Log "$name  fetch failed (offline?)"; return $null }
  $counts = (git -C $dir rev-list --left-right --count "HEAD...$upstream" 2>$null) -split '\s+'
  if ($counts.Count -lt 2) { return $null }
  $ahead = [int]$counts[0]; $behind = [int]$counts[1]
  if ($behind -eq 0) { return $null }
  if ($ahead -gt 0) { Log "$name  $branch is $behind behind and $ahead ahead of ${upstream}: left alone (someone has unpushed work)"; return $null }
  if (git -C $dir status --porcelain --untracked-files=no 2>$null) { Log "$name  $branch is $behind behind: left alone (uncommitted changes)"; return $null }
  $before = git -C $dir rev-parse HEAD
  git -C $dir merge --ff-only --quiet $upstream 2>$null
  if ($LASTEXITCODE -ne 0) { Log "$name  fast-forward refused"; return $null }
  $changed = @(git -C $dir diff --name-only $before HEAD)
  Log "$name  $branch +$behind commit(s) from $upstream ($($changed.Count) files)"
  return $changed
}

function Restart-Star {
  if (-not (Test-Path -LiteralPath $starExe)) { return }
  $running = Get-CimInstance Win32_Process -Filter "Name='desktop-pets-20261008.exe'" -ErrorAction SilentlyContinue
  if (-not $running) { return }   # the star is closed on purpose; do not open it
  & $starExe $petos --quit | Out-Null
  Start-Sleep -Seconds 2
  Start-Process -FilePath $starExe -ArgumentList ('"' + $petos + '"') -WorkingDirectory $petos
  Log "star restarted to show the new pets and art"
}

Log "live sync started (PetOS every ${FastSeconds}s, other repos every ${SlowSeconds}s)"
$lastSlow = [DateTime]::MinValue
do {
  $changed = Sync-Repo $petos
  if ($changed -and ($changed | Where-Object { $p = $_; $starPaths | Where-Object { $p -eq $_ -or $p.StartsWith($_) } })) { Restart-Star }
  if (((Get-Date) - $lastSlow).TotalSeconds -ge $SlowSeconds) {
    $lastSlow = Get-Date
    Get-ChildItem -LiteralPath $Root -Directory | Where-Object { $_.FullName -ne $petos -and (Test-Path -LiteralPath (Join-Path $_.FullName '.git')) } |
      ForEach-Object { [void](Sync-Repo $_.FullName) }
  }
  if (-not $Once) { Start-Sleep -Seconds $FastSeconds }
} while (-not $Once)
$mutex.ReleaseMutex()
