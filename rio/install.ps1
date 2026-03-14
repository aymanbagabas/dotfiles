New-Item -ItemType Directory -Path "$Env:LOCALAPPDATA\rio" -Force > $null
Copy-Item "$PSScriptRoot\config.toml" "$Env:LOCALAPPDATA\rio\config.toml" -Force
