$source = $PSScriptRoot
$target = Join-Path $Env:LOCALAPPDATA "nvim"
$targetParent = Split-Path $target -Parent

if (-not (Test-Path $targetParent)) {
	Write-Host "Creating '$targetParent'"
	if (-not $DRY_RUN) {
		New-Item -ItemType Directory -Path $targetParent -Force > $null
	}
}

if (Test-Path $target) {
	Write-Host "Deleting '$target'"
	if (-not $DRY_RUN) {
		Remove-Item -LiteralPath $target -Recurse -Force
	}
}

Write-Host "Copying '$source' to '$target'"
if (-not $DRY_RUN) {
	New-Item -ItemType Directory -Path $target -Force > $null
	Get-ChildItem -LiteralPath $source -Force |
		Where-Object { $_.Name -ne ".git" } |
		Copy-Item -Destination $target -Recurse -Force
}
