New-Item -ItemType Directory -Path "$Env:APPDATA\alacritty" -Force > $null
Copy-Item "$PSScriptRoot\alacritty.toml" "$Env:APPDATA\alacritty\alacritty.toml" -Force
