# Startup Star: make the star openable by double-click and start it when Astra signs in.
# Creates "Startup Star.lnk" in this folder and in the Start menu, turns on the desktop
# program's own sign-in startup (its --install-startup mode), then opens the star.
# Run again any time; it overwrites only the two shortcuts it made.
param(
  [string]$PetApps = (Join-Path $env:USERPROFILE "Documents\Projects\astras-pet-os"),
  [switch]$NoStartup,
  [switch]$NoLaunch
)
$ErrorActionPreference = "Stop"
$exe = Join-Path $PetApps "bin\desktop-pets-20261008.exe"
if (-not (Test-Path $exe)) { throw "Desktop pets program not found: $exe" }

$here = Split-Path -Parent $PSScriptRoot
$startMenu = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs"
$shell = New-Object -ComObject WScript.Shell
# The shortcut wears the folder's star (Astra, 2026-10-17; Flash Audit A53): the folder icon from desktop.ini,
# else the Windows star (shell32.dll, icon 43). The program's own icon is not a star.
$icon = "$env:SystemRoot\System32\shell32.dll,43"
$ini = Join-Path $here "desktop.ini"
if (Test-Path -LiteralPath $ini) {
  $line = Get-Content -LiteralPath $ini | Where-Object { $_ -match '^\s*IconResource\s*=' } | Select-Object -First 1
  if ($line) { $icon = ($line -split '=', 2)[1].Trim() }
}
foreach ($dir in @($here, $startMenu)) {
  $link = $shell.CreateShortcut((Join-Path $dir "Startup Star.lnk"))
  $link.TargetPath = $exe
  $link.Arguments = '"' + $PetApps + '"'
  $link.WorkingDirectory = $PetApps
  $link.IconLocation = $icon
  $link.Description = "Startup Star: the tray star and Astra's desktop pets"
  $link.Save()
  Write-Output "Shortcut: $(Join-Path $dir 'Startup Star.lnk')"
}

if (-not $NoStartup) { & $exe $PetApps --install-startup | Out-Null; Write-Output "Starts when you sign in: on" }
if (-not $NoLaunch) { Start-Process -FilePath $exe -ArgumentList ('"' + $PetApps + '"') -WorkingDirectory $PetApps; Write-Output "Star opened" }
