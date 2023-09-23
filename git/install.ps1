# Link global ignore
Link-File "$PSScriptRoot\ignore" "$Env:USERPROFILE\.gitignore"

Write-Host "Creating global git config..."
if (!$DRY_RUN) {
	Templatize "$PSScriptRoot\config" | Invoke-Expression
	git config --global gpg.program "C:\Program Files (x86)\GnuPG\bin\gpg.exe"
}