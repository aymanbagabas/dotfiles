# This script bootstraps a Windows development environment.

param(
	[switch]$DryRun,
	[switch]$Help,
	[string]$Command
)

$DRY_RUN = $DryRun

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

function Link-File {
	param([string]$From, [string]$To)
	Write-Host "Linking '$From' to '$To'"
	$dir = Split-Path $To -Parent
	if (!(Test-Path $dir)) {
		New-Item -ItemType Directory -Path $dir -Force > $null
	}
	if (!$DRY_RUN) {
		New-Item -ItemType SymbolicLink -Path $To -Target $From -Force > $null
	}
}

function Command-Exist {
	param([string]$Cmd)
	return !!(Get-Command $Cmd -ErrorAction SilentlyContinue)
}

function Require {
	param([string]$Cmd)
	if (!(Command-Exist $Cmd)) {
		Write-Host "Command '$Cmd' not found"
		exit 1
	}
}

function _Install {
	if (!$DRY_RUN) {
		Write-Host "Installing/updating dotfiles..."
	} else {
		Write-Host "Dry run, not installing/updating dotfiles..."
	}
	Write-Host

	Get-ChildItem -Path $PSScriptRoot -Directory | ForEach-Object {
		$install = Join-Path $_.FullName "install.ps1"
		if (Test-Path $install) {
			Write-Host "===== Installing $($_.Name) dotfiles..."
			. $install
			Write-Host
		}
	}

	Write-Host "Done installing/updating dotfiles"
	Write-Host
}

function _Usage {
	Write-Host "Usage: bootstrap.ps1 [-DryRun] [-Help] [command]"
	Write-Host
	Write-Host "Commands:"
	Write-Host "  install   Install dotfiles"
	Write-Host "  help      Show this help message and exit"
	$scriptsDir = Join-Path $PSScriptRoot "scripts"
	if (Test-Path $scriptsDir) {
		Get-ChildItem -Path $scriptsDir -Filter "*.ps1" | ForEach-Object {
			Write-Host "  $($_.BaseName)"
		}
	}
	Write-Host
	Write-Host "Options:"
	Write-Host "  -Help     Show this help message and exit"
	Write-Host "  -DryRun   Dry run"
}

function _Main {
	if ($Help) {
		_Usage
		exit 0
	}

	switch ($Command) {
		"install" {
			_Install
		}
		"help" {
			_Usage
		}
		"" {
			_Usage
			exit 1
		}
		default {
			$script = Join-Path $PSScriptRoot "scripts\$Command.ps1"
			if (Test-Path $script) {
				. $script
				exit 0
			}
			Write-Host "Invalid command: $Command" -ForegroundColor Red
			_Usage
			exit 1
		}
	}
}

_Main
