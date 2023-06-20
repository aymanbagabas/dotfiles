#!/bin/bash

# shared package names
pkgs=(
	git
	zsh
	tmux
	neovim
	fzf
	ripgrep
	gnupg
	pinentry
	exa
	direnv
	bat
	htop
	jq
	source-highlight
)

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
			$(
				for pkg in "${pkgs[@]}"; do
					if [ "$pkg" = "neovim" ]; then
						echo "brew \"$pkg\", args: ['HEAD']"
					else
						echo "brew \"$pkg\""
					fi
				done
			)
			brew "pinentry-mac"
			brew "gsed"
			brew "fortune"
			brew "gh"
			brew "hub"
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
			cask "multitouch"
			cask "font-inconsolata"
			cask "font-symbols-only-nerd-font"

			mas "Magnet", id: 441258766
			mas "Microsoft Remote Desktop", id: 1295203466
		EOF
	fi
	;;
linux*)
	# Use /etc/os-release to determine distro
	. /etc/os-release
	id=$ID

	# count the number of items in $ID_LIKE
	id_like=("$id")
	if [ -n "$ID_LIKE" ]; then
		IFS=' ' read -r -a id_like <<<"$ID_LIKE"
	fi

	# for i in {1..2}; do
	for i in $(seq ${#id_like[@]}); do
		case "$id" in
		ubuntu | debian)
			# Install packages
			echo "Installing packages..."
			if ! $DRY_RUN; then
				sudo apt-get install software-properties-common
				sudo add-apt-repository -y ppa:neovim-ppa/unstable
				sudo apt-get update
				sudo apt-get install -y \
					"${pkgs[@]}" \
					pinentry-tty \
					fortune-mod
			fi
			break
			;;
		fedora | rhel)
			# Install packages
			echo "Installing packages..."
			if ! $DRY_RUN; then
				sudo yum install -y \
					"${pkgs[@]}" \
					pinentry-tty \
					fortune-mod
			fi
			break
			;;
		arch)
			# Install packages
			echo "Installing packages..."
			if ! $DRY_RUN; then
				sudo pacman -S --noconfirm \
					"${pkgs[@]}" \
					fortune-mod
			fi
			;;
		*)
			if [ "$i" -ne ${#id_like[@]} ]; then
				# Choose the next item in $ID_LIKE
				id=${id_like[$i]}
			else
				echo "Unsupported distro: $id"
				exit 1
			fi
			;;
		esac
	done
	;;
esac
