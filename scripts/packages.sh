#!/bin/bash

case "$OSTYPE" in
darwin*)
	# Install Xcode command line tools
	if ! xcode-select --version >/dev/null 2>&1; then
		echo "Installing Xcode command line tools..."
		if ! $DRY_RUN; then
			xcode-select --install
		fi
	fi

	# Install Homebrew
	if ! command_exist brew; then
		echo "Installing Homebrew..."
		if ! $DRY_RUN; then
			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		fi
	fi

	# Install packages
	echo "Installing packages..."
	if ! $DRY_RUN; then
		brew install --quiet git zsh mas
		brew bundle --no-lock --file=/dev/stdin <<-EOF
			brew "difftastic"
			brew "tig"
			brew "tmux"
			brew "neovim", args: ['HEAD']
			brew "fzf"
			brew "ripgrep"
			brew "gnupg"
			brew "pinentry"
			brew "pinentry-mac"
			brew "gsed"
			brew "exa"
			brew "direnv"
			brew "zoxide"
			brew "bat"
			brew "fortune"
			brew "gh"
			brew "hub"
			brew "htop"
			brew "jq"
			brew "source-highlight"
			brew "tz"

			cask "google-chrome"
			cask "alfred"
			cask "iterm2-beta"
			cask "alt-tab"
			cask "clipy"
			cask "spotify"
			cask "textmate"
			cask "the-unarchiver"
			cask "karabiner-elements"

			mas "Magnet", id: 441258766
			mas "Microsoft Remote Desktop", id: 1295203466
		EOF
	fi
	;;
esac
