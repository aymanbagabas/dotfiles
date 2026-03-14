
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

Write-Host "Installing packages..."
if (!$DRY_RUN) {
	winget.exe install $PGKS -e
}
