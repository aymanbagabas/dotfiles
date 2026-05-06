#!/bin/sh

link_file zshrc ~/.zshrc
link_file zprofile ~/.zprofile

# Switch default shell to zsh if not already set
case "$SHELL" in
*zsh)
	;;
*)
	if command_exist zsh; then
		ZSH_PATH="$(command -v zsh)"
		echo "Current shell is $SHELL. Change to zsh?"
		printf "Run 'chsh -s %s'? [y/N] " "$ZSH_PATH"
		if ! $DRY_RUN; then
			read -r answer
			if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
				chsh -s "$ZSH_PATH"
			fi
		fi
	fi
	;;
esac
