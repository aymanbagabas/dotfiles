# Create config directory
if (!$DRY_RUN) {
	New-Item -ItemType Directory -Force -Path "$Env:LOCALAPPDATA\nvim" > $null
}

# Link files
Link-File "$PSScriptRoot\lua" "$Env:LOCALAPPDATA\nvim\lua"
Link-File "$PSScriptRoot\init.lua" "$Env:LOCALAPPDATA\nvim\init.lua"
Link-File "$PSScriptRoot\lazy-lock.json" "$Env:LOCALAPPDATA\nvim\lazy-lock.json"
Link-File "$PSScriptRoot\neoconf.json" "$Env:LOCALAPPDATA\nvim\neoconf.json"
