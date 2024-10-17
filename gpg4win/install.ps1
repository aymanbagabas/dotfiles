$dir = "$Env:APPDATA\gnupg"

# Create parent directory
if (!$DRY_RUN) {
	New-Item -ItemType Directory -Force -Path "$dir" > $null
}

Copy-Item -Path "$PSScriptRoot\gpg-agent.conf" -Destination "$dir\gpg-agent.conf"