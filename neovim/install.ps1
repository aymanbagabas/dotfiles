Remove-Item -Recurse -Force "$Env:LOCALAPPDATA\nvim" -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path "$Env:LOCALAPPDATA\nvim" -Force > $null
Copy-Item -Path "$PSScriptRoot\*" -Destination "$Env:LOCALAPPDATA\nvim" -Recurse -Force
