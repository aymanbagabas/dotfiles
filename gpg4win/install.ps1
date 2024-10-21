$dir = "$Env:APPDATA\gnupg"

# Create parent directory
if (!$DRY_RUN) {
	New-Item -ItemType Directory -Force -Path "$dir" > $null
}

Copy-Item -Path "$PSScriptRoot\gpg-agent.conf" -Destination "$dir\gpg-agent.conf"

# Run gpg-agent on startup
Copy-Item -Path "$PSScriptRoot\gpg-connect-agent.exe.lnk" -Destination "$Env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\gpg-connect-agent.exe.lnk"