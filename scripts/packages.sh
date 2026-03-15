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
	direnv
	bat
	htop
	jq
	eza
	fd
	zoxide
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

	# Install packages via Brewfile
	echo "Installing packages..."
	if ! $DRY_RUN; then
		brew bundle --no-lock --file="$DOTFILES/Brewfile"
	fi
	;;
linux*)
	# Use /etc/os-release to determine distro
	. /etc/os-release
	id=$ID

	id_like=("$id")
	if [ -n "$ID_LIKE" ]; then
		IFS=' ' read -r -a id_like <<<"$ID_LIKE"
	fi

	for i in $(seq ${#id_like[@]}); do
		case "$id" in
		ubuntu | debian)
			echo "Installing packages..."
			if ! $DRY_RUN; then
				sudo mkdir -p /etc/apt/keyrings
				wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
				echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
				sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list

				sudo apt-get install -y software-properties-common
				sudo add-apt-repository -y ppa:neovim-ppa/unstable
				sudo apt-get update
				sudo apt-get install -y \
					"${pkgs[@]}" \
					pinentry-tty \
					fortune-mod \
					fd-find
			fi
			break
			;;
		fedora | rhel)
			echo "Installing packages..."
			if ! $DRY_RUN; then
				sudo yum install -y \
					"${pkgs[@]}" \
					pinentry-tty \
					fortune-mod \
					fd-find
			fi
			break
			;;
		arch)
			echo "Installing packages..."
			if ! $DRY_RUN; then
				sudo pacman -S --noconfirm \
					"${pkgs[@]}" \
					pinentry \
					base-devel \
					fortune-mod \
					fd
			fi
			;;
		*)
			if [ "$i" -ne ${#id_like[@]} ]; then
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
