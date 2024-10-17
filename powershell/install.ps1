# Create PowerShell config directory
if (!$DRY_RUN) {
	New-Item -ItemType Directory -Force -Path "$Env:USERPROFILE\Documents\PowerShell" > $null
}

# Install modules
if (!$DRY_RUN) {
	Install-Module -Name pure-pwsh -Scope CurrentUser -Force
	Install-Module -Name posh-git -Scope CurrentUser -Force
	Install-Module -Name Get-Quote -Scope CurrentUser -Force
	Install-Module -Name git-aliases -Scope CurrentUser -Force
}

# Link files
Copy-Item -Path "$PSScriptRoot\Microsoft.PowerShell_profile.ps1" -Destination "$Env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"