# Install global packages under %USERPROFILE%\.npm-global. Without this, npm
# takes its prefix from the active Node version, so every global package
# disappears on a Node upgrade.
#
# Use `npm config set` rather than linking an npmrc, because .npmrc also holds
# the registry auth token. A link would either drop that token or commit it to
# this repository.
#
# Windows puts the command shims in the prefix directory itself, not in a bin
# subdirectory, so %USERPROFILE%\.npm-global is what belongs on PATH.
if (Command-Exist npm) {
	Write-Host "Setting npm global prefix..."

	if (!$DRY_RUN) {
		npm config set prefix "$Env:USERPROFILE\.npm-global"
	}
}
