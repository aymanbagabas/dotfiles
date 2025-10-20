# This script bootstraps a Windows development environment by installing
# packages via winget and configuring dotfiles.

# Exit if not running on Windows
if ($ENV:OS -ne "Windows_NT" -and [System.Environment]::OSVersion.Platform -ne "Win32NT") {
	Write-Host "This script is only supported on Windows"
	exit 1
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
Copy-Item "$PSScriptRoot\git\gitconfig" "$Env:HOME\.gitconfig" -Force
Copy-Item "$PSScriptRoot\git\gitignore" "$Env:HOME\.gitignore" -Force
git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"
git config --global gpg.program "C:/Program Files (x86)/GnuPG/bin/gpg.exe"

Write-Host "===== Done configuring Git."
Write-Host

Write-Host "===== Configuring Neovim..."
New-Item -ItemType Directory -Path "$Env:LOCALAPPDATA\nvim" -Force > $null
Copy-Item "$PSScriptRoot\neovim" "$Env:LOCALAPPDATA\nvim" -Recurse -Force
Write-Host "===== Done configuring Neovim."
Write-Host

Write-Host "===== Configuring GnuPG..."
New-Item -ItemType Directory -Path "$Env:APPDATA\Roaming\gnupg" -Force > $null
Copy-Item "$PSScriptRoot\gnupg\gpg-agent.conf" "$Env:APPDATA\gnupg\gpg-agent.conf" -Force
Write-Host "\n" >> "$Env:APPDATA\gnupg\gpg-agent.conf"
Write-Host "enable-win32-openssh-support" >> "$Env:APPDATA\gnupg\gpg-agent.conf"
Write-Host "use-standard-socket" >> "$Env:APPDATA\gnupg\gpg-agent.conf"
# Run gpg-agent on startup
Copy-Item -Path "$PSScriptRoot\gnupg\gpg-connect-agent.exe.lnk" -Destination "$Env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\gpg-connect-agent.exe.lnk"
Write-Host "===== Done configuring GnuPG."
Write-Host
