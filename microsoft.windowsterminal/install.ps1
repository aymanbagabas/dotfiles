$dir = "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

# Create parent directory
if (!$DRY_RUN) {
	New-Item -ItemType Directory -Force -Path "$dir" > $null
}

Copy-Item -Path "$PSScriptRoot\settings.json" -Destination "$dir\settings.json"