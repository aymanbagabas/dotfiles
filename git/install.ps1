if (!$DRY_RUN) {
	Templatize "$PSScriptRoot\gitconfig.tmpl" | Set-Content "$Env:USERPROFILE\.gitconfig" -Force
	git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"
}
Link-File "$PSScriptRoot\gitignore" "$Env:USERPROFILE\.gitignore"
