Write-Host "Installing bin executables..."

$sourceDir = $PSScriptRoot
Get-ChildItem -LiteralPath $sourceDir -File |
	Where-Object { $_.Name -notin @("install.sh", "install.ps1") } |
	ForEach-Object {
		Link-File $_.FullName (Join-Path $HOME ".bin\$($_.Name)")
	}
