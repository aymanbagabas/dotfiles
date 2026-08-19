New-Item -ItemType Directory -Path "$Env:USERPROFILE\.codex" -Force > $null
Link-File "$PSScriptRoot\config.toml" "$Env:USERPROFILE\.codex\config.toml"
