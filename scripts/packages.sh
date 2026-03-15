#!/bin/bash

if ! xcode-select --version >/dev/null 2>&1; then
	echo "Installing Xcode command line tools..."
	$DRY_RUN || xcode-select --install
fi

if ! command_exist brew; then
	echo "Installing Homebrew..."
	$DRY_RUN || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing packages via Brewfile..."
$DRY_RUN || brew bundle --no-lock --file="$DOTFILES/Brewfile"
