#!/bin/bash

echo "===== Setting shell"

require "zsh"
require "sudo"

case "$SHELL" in
*zsh)
	echo "zsh already set as default shell, skipping..."
	;;
*)
	echo "Setting zsh as default shell..."

	if ! $DRY_RUN; then
		sudo chsh -s /bin/zsh
	fi
	;;
esac
