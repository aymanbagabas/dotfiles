Import-Module pure-pwsh
Import-Module posh-git
Import-Module git-aliases -DisableNameChecking

# Pure PowerShell promt
$pure.PromptChar = '›'

function OnViModeChange {
    if ($args[0] -eq 'Command') {
        # Set the cursor to a blinking block.
        Write-Host -NoNewLine "`e[1 q"
    }
    else {
        # Set the cursor to a blinking line.
        Write-Host -NoNewLine "`e[5 q"
    }
}

# Read line opts
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
# Vi Mode
Set-PSReadLineOption -EditMode Vi -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange

# Golang path
if (Get-Command "go" -errorAction SilentlyContinue) {
    $Env:GOPATH = "$Env:USERPROFILE\.go"
    $Env:PATH += ";$Env:GOPATH\bin"
}

# Exports
$Env:KEYID = "593D6EEE7871708E329619322EBA00DFFCC63351"
$Env:EDITOR = "nvim"

# Aliases
Set-Alias -Name vim -Value nvim

# Before starting a new shell
Get-Quote