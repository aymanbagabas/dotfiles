$dir = "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

# Create parent directory
if (!$DRY_RUN) {
	New-Item -ItemType Directory -Force -Path "$dir" > $null
}

Link-File "$PSScriptRoot\settings.json" "$dir\settings.json"