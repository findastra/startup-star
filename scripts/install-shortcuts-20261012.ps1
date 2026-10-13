# Startup Star: make the star openable by double-click and start it when Astra signs in.
# Creates "Startup Star.lnk" in this folder and in the Start menu, turns on the desktop
# program's own sign-in startup (its --install-startup mode), then opens the star.
# Run again any time; it overwrites only the two shortcuts it made.
param(
  [string]$PetApps = "C:\Users\audra\Documents\Projects\astras-pet-os",
  [switch]$NoStartup,
  [switch]$NoLaunch
)
$ErrorActionPreference = "Stop"
$exe = Join-Path $PetApps "bin\desktop-pets-20261008.exe"
if (-not (Test-Path $exe)) { throw "Desktop pets program not found: $exe" }

$here = Split-Path -Parent $PSScriptRoot
$startMenu = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs"
$shell = New-Object -ComObject WScript.Shell
foreach ($dir in @($here, $startMenu)) {
  $link = $shell.CreateShortcut((Join-Path $dir "Startup Star.lnk"))
  $link.TargetPath = $exe
  $link.Arguments = '"' + $PetApps + '"'
  $link.WorkingDirectory = $PetApps
  $link.IconLocation = "$exe,0"
  $link.Description = "Startup Star: the tray star and Astra's desktop pets"
  $link.Save()
  Write-Output "Shortcut: $(Join-Path $dir 'Startup Star.lnk')"
}

if (-not $NoStartup) { & $exe $PetApps --install-startup | Out-Null; Write-Output "Starts when you sign in: on" }
if (-not $NoLaunch) { Start-Process -FilePath $exe -ArgumentList ('"' + $PetApps + '"') -WorkingDirectory $PetApps; Write-Output "Star opened" }
