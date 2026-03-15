New-Item -ItemType Directory -Path "$Env:USERPROFILE\.ssh" -Force > $null
Link-File "$PSScriptRoot\config" "$Env:USERPROFILE\.ssh\config"
