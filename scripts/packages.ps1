
$PGKS = @(
	"7zip.7zip",
	"Git.Git",
	"GnuPG.Gpg4win",
	"Microsoft.PowerShell",
	"Microsoft.VisualStudioCode",
	"Microsoft.WindowsTerminal",
	"Neovim.Neovim",
	"Notepad++.Notepad++",
	"eza-community.eza"
)

Write-Host "Installing packages..."
if (!$DRY_RUN) {
	winget.exe install $PGKS -e
}
