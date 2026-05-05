#!/bin/sh

target="$HOME/.config/nvim"

if [ -d "$target" ] && [ ! -L "$target" ]; then
	printf "Deleting '%s'\n" "$target"
	if ! $DRY_RUN; then
		rm -rf "$target"
	fi
fi

link_file . "$target"
