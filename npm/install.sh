#!/bin/sh

# Install global packages under ~/.npm-global, which zprofile already puts on
# PATH. Without this, npm takes its prefix from fnm, which points inside the
# active Node version, so every global package disappears on a Node upgrade.
#
# Use `npm config set` rather than linking an npmrc, because ~/.npmrc also
# holds the registry auth token. A symlink would either drop that token or
# commit it to this repository.
if command_exist npm; then
	echo "Setting npm global prefix..."

	if ! $DRY_RUN; then
		npm config set prefix "$HOME/.npm-global"
	fi
fi
