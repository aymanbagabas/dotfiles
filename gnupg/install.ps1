$dir = "$Env:APPDATA\gnupg"

# Create GnuPG config directory
if (!$DRY_RUN) {
	New-Item -ItemType Directory -Force -Path "$dir" > $null
}

# Create GnuPG config file
Write-Host "Creating GnuPG config file..."
if (!$DRY_RUN) {
	$gpgconf = Templatize "$PSScriptRoot\gpg.conf"
	Write-Output $gpgconf > "$dir\gpg.conf"
}

# Create GnuPG agent config file
$PINENTRY_PROGRAM = "C:\Program Files (x86)\Gpg4win\bin\pinentry.exe"
Write-Host "Creating GnuPG agent config file..."
if (!$DRY_RUN) {
	$gpgagentconf = Templatize "$PSScriptRoot\gpg-agent.conf"
	Write-Output $gpgagentconf > "$dir\gpg-agent.conf"

	# Windows SSH
	#enable-putty-support
	#enable-win32-openssh-support
	Insert-Line -Pattern "^enable-win32-openssh-support" -Line "enable-win32-openssh-support" -Path "$dir\gpg-agent.conf"
	#use-standard-socket
	Insert-Line -Pattern "^use-standard-socket" -Line "use-standard-socket" -Path "$dir\gpg-agent.conf"
}