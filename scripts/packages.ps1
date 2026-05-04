
$PKGS = @(
	"7zip.7zip",
	"BurntSushi.ripgrep.MSVC",
	"Git.Git",
	"GnuPG.Gpg4win",
	"Kitware.CMake",
	"Rustlang.Rustup",
	"mbuilov.sed",
	"Microsoft.PowerShell",
	@{
		Id = "Microsoft.VisualStudio.2022.BuildTools"
		Override = "--wait --passive --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"
	},
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
foreach ($pkg in $PKGS) {
	$id = if ($pkg -is [string]) { $pkg } else { $pkg.Id }
	$args = @(
		"install",
		"--id", $id,
		"-e",
		"--accept-package-agreements",
		"--accept-source-agreements"
	)

	if ($pkg -isnot [string] -and $pkg.Override) {
		$args += @("--override", $pkg.Override)
	}

	if ($DRY_RUN) {
		Write-Host ("winget.exe " + ($args -join " "))
		continue
	}

	& winget.exe @args
}
