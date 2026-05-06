New-Item -ItemType Directory -Path "$Env:USERPROFILE\.copilot" -Force > $null
Link-File "$PSScriptRoot\copilot-instructions.md" "$Env:USERPROFILE\.copilot\copilot-instructions.md"
