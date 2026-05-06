New-Item -ItemType Directory -Path "$Env:USERPROFILE\.ssh" -Force > $null
Link-File "$PSScriptRoot\config" "$Env:USERPROFILE\.ssh\config"

# Configure OpenSSH Authentication Agent and npiperelay on Windows.

$isAdmin = ([Security.Principal.WindowsPrincipal] `
	[Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Enable and start OpenSSH Authentication Agent
$svc = Get-Service -Name ssh-agent -ErrorAction SilentlyContinue
if ($null -eq $svc) {
	Write-Host "ssh-agent service not found. Install Windows OpenSSH Client first." -ForegroundColor Yellow
} else {
	if ($svc.StartType -ne "Automatic") {
		if (!$isAdmin) {
			Write-Host "Skipping ssh-agent service configuration (requires elevation)." -ForegroundColor Yellow
		} elseif (!$DRY_RUN) {
			Write-Host "Setting ssh-agent service to start automatically..."
			Set-Service -Name ssh-agent -StartupType Automatic
		}
	}
	if ($svc.Status -ne "Running") {
		if (!$DRY_RUN) {
			Write-Host "Starting ssh-agent service..."
			Start-Service ssh-agent
		}
	}
}

# Install npiperelay for WSL SSH agent forwarding
if (!(Command-Exist "npiperelay.exe")) {
	if (!$DRY_RUN) {
		Write-Host "Installing npiperelay..."
		winget.exe install --id albertony.npiperelay -e --accept-package-agreements --accept-source-agreements
	}
} else {
	Write-Host "npiperelay.exe already installed."
}
