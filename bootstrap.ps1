param(
	[Parameter(HelpMessage = "Dry run")]
	[switch]$DryRun,
	[Parameter(HelpMessage = "Show this help message and exit")]
	[switch]$Help,
	[Parameter(HelpMessage = "Action to perform")]
	[string]$Action = $null
)

# Global variables
Get-Content .vars | ForEach-Object { Invoke-Expression "`$$_" }
$DRY_RUN = $false

if ($Help) {
	Show-Help
	return
}
if ($DryRun) {
	$DRY_RUN = $true
}

# Functions

function Templatize {
	param(
		[Parameter(Mandatory = $true)]
		[string]$TemplatePath
	)
	Get-Content "$TemplatePath" -Raw | ForEach-Object { $ExecutionContext.InvokeCommand.ExpandString($_) }
}

function Insert-Line {
	param(
		[Parameter(Mandatory = $true)]
		[string]$Pattern,
		[Parameter(Mandatory = $true)]
		[string]$Line,
		[Parameter(Mandatory = $true)]
		[string]$Path
	)
	Write-Host "Inserting line '$Line' into '$Path'"
	if (!$DRY_RUN) {
		if ((Get-Content "$Path" | Select-String -Pattern "$Pattern" -Quiet) -eq $false) {
			Write-Output "$Line" | Out-File -Append "$Path"
		}
	}
}

function Link-File {
	param(
		[Parameter(Mandatory = $true)]
		[string]$Source,
		[Parameter(Mandatory = $true)]
		[string]$Destination
	)
	Write-Host "Linking $Source -> $Destination"
	if (!$DRY_RUN) {
		New-Item -ItemType Directory -Path (Split-Path $Destination -Parent) -Force > $null
		New-Item -ItemType SymbolicLink -Path "$Destination" -Target "$Source" -Force > $null
	}
}

function Install {
	if ($DRY_RUN) {
		Write-Host "Dry run, won't install anything"
	}
	else {
		Write-Host "Installing dotfiles..."
	}

	Write-Host
	Get-ChildItem "$PSScriptRoot\*\install.ps1" | ForEach-Object {
		Write-Host "===== Installing '$($_.Directory.BaseName)' dotfiles..."

		& $_.FullName

		Write-Host
	}

	Write-Host "Done installing dotfiles"
}

function Show-Help {
	Write-Host "Usage: bootstrap.ps1 [-DryRun] [-Help] [-Action <action>]"
	Write-Host "  -DryRun: Dry run"
	Write-Host "  -Help: Show this help message"
	Write-Host "  -Action: Action to perform"
	Write-Host "    install: Install dotfiles"
	Write-Host "    help: Show this help message and exit"
	Get-ChildItem "$PSScriptRoot\scripts\*.ps1" | ForEach-Object { Write-Host "    $(($_).BaseName)" }
}

switch ($Action) {
	"install" {
		Install
		return
	}
	"help" {
		Show-Help
		return
	}
	default {
		$scripts = @((Get-ChildItem "$PSScriptRoot\scripts\*.ps1").BaseName)
		for ($i = 0; $i -lt $scripts.Length; $i++) {
			if ($Action -eq $scripts[$i]) {
				& "$PSScriptRoot\scripts\$($scripts[$i])"
				return
			}
		}
		Show-Help
		exit 1
	}
}
