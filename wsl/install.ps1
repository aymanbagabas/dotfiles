# Configure WSL 2 with Debian on Windows.

$isAdmin = ([Security.Principal.WindowsPrincipal] `
	[Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$needsReboot = $false

# Check and enable required Windows features
if (!$isAdmin) {
	Write-Host "Skipping Windows feature enablement (requires elevation)." -ForegroundColor Yellow
} else {
	$wslFeature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
	$vmpFeature = Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform

	if ($wslFeature.State -ne "Enabled" -or $vmpFeature.State -ne "Enabled") {
		if ($wslFeature.State -ne "Enabled") {
			if (!$DRY_RUN) {
				Write-Host "Enabling Windows Subsystem for Linux..."
				dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
				$needsReboot = $true
			}
		}

		if ($vmpFeature.State -ne "Enabled") {
			if (!$DRY_RUN) {
				Write-Host "Enabling Virtual Machine Platform..."
				dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
				$needsReboot = $true
			}
		}

		if ($needsReboot) {
			Write-Host "A reboot is required before WSL can be fully configured. Please reboot and re-run." -ForegroundColor Yellow
			return
		}
	} else {
		Write-Host "WSL and Virtual Machine Platform features already enabled."
	}
}

# Update WSL
if (!$DRY_RUN) {
	Write-Host "Updating WSL..."
	wsl.exe --update
}

# Set WSL 2 as default version
if (!$DRY_RUN) {
	Write-Host "Setting WSL default version to 2..."
	wsl.exe --set-default-version 2
}

# Install Debian if not already installed
if (!$DRY_RUN) {
	$installed = wsl.exe --list --quiet 2>$null |
		ForEach-Object { $_.Trim().Trim([char]0) } |
		Where-Object { $_ }

	if ($installed -notcontains "Debian") {
		Write-Host "Installing Debian..."
		wsl.exe --install -d Debian --no-launch
	} else {
		Write-Host "Debian already installed."
	}

	# Set Debian as default distro
	Write-Host "Setting Debian as default WSL distro..."
	wsl.exe --set-default Debian
}
