# Link global ignore
Link-File "$PSScriptRoot\ignore" "$Env:USERPROFILE\.gitignore"

Write-Host "Creating global git config..."
if (!$DRY_RUN) {
	Templatize "$PSScriptRoot\config" | Invoke-Expression

	# XXX: We're intentionally using forward slashes (/) here because git
	# doesn't like backslashes in paths.
	git config --global gpg.program "C:/Program Files (x86)/GnuPG/bin/gpg.exe"

	# Use Windows OpenSSH
	git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"
}