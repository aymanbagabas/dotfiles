#!/bin/sh

if [ -d "/Applications/iTerm.app" ]; then
	echo "Setting up iTerm2 preferences..."
	if ! $DRY_RUN; then
		# Specify the preferences directory
		defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$DOTFILES/iterm2"

		# Tell iTerm2 to use the custom preferences in the directory
		defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
	fi
else
	echo "iTerm2 not installed, skipping..."
fi
