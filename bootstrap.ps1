# This script bootstraps a Windows development environment by installing
# packages via winget and configuring dotfiles.

# Exit if not running on Windows
if ($ENV:OS -ne "Windows_NT" -and [System.Environment]::OSVersion.Platform -ne "Win32NT") {
	Write-Host "This script is only supported on Windows"
	exit 1
}

# Load .env variables
$envFile = Join-Path $PSScriptRoot ".env"
if (Test-Path $envFile) {
	Get-Content $envFile | ForEach-Object {
		if ($_ -match '^\s*([^#][^=]*)=(.*)$') {
			$key = $Matches[1].Trim()
			$value = $Matches[2].Trim().Trim('"').Trim("'")
			Set-Variable -Name $key -Value $value -Scope Script
		}
	}
}

function Templatize {
	param([string]$Template)
	$content = Get-Content $Template -Raw
	return $ExecutionContext.InvokeCommand.ExpandString($content)
}

$PGKS = @(
	"7zip.7zip",
	"BurntSushi.ripgrep.MSVC",
	"Git.Git",
	"GnuPG.Gpg4win",
	"Microsoft.PowerShell",
	"Microsoft.VisualStudioCode",
	"Microsoft.WindowsTerminal",
	# "Neovim.Neovim",
	"Neovim.Neovim.Nightly", # Use nightly until 0.12 is released
	"Notepad++.Notepad++",
	"OpenJS.NodeJS",
	"cURL.cURL",
	"eza-community.eza",
	"junegunn.fzf",
	"sharkdp.fd"
)

Write-Host "===== Installing packages..."
winget.exe install $PGKS -e

Write-Host "===== Done installing packages."
Write-Host

Write-Host "===== Bootstrapping dotfiles..."
Write-Host
Write-Host "===== Configuring Git..."
. "$PSScriptRoot\git\install.ps1"
Write-Host "===== Done configuring Git."
Write-Host

Write-Host "===== Configuring Neovim..."
. "$PSScriptRoot\neovim\install.ps1"
Write-Host "===== Done configuring Neovim."
Write-Host

Write-Host "===== Configuring GnuPG..."
. "$PSScriptRoot\gnupg\install.ps1"
Write-Host "===== Done configuring GnuPG."
Write-Host
