if (!$DRY_RUN) {
	New-Item -ItemType Directory -Path "$Env:APPDATA\gnupg" -Force > $null
	Templatize "$PSScriptRoot\gpg.conf.tmpl" | Set-Content "$Env:APPDATA\gnupg\gpg.conf" -Force
	Copy-Item -Path "$PSScriptRoot\gpg-agent.conf" -Destination "$Env:APPDATA\gnupg\gpg-agent.conf" -Force
	Add-Content "$Env:APPDATA\gnupg\gpg-agent.conf" "`nenable-win32-openssh-support`nuse-standard-socket"
	Copy-Item -Path "$PSScriptRoot\gpg-connect-agent.exe.lnk" -Destination "$Env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\gpg-connect-agent.exe.lnk"
}
