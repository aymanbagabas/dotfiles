#!/bin/bash

# Copy bin executables
if [ ! -d ~/.local/bin ]; then
	if ! $DRY_RUN; then
		mkdir -p ~/.local/bin/
	fi
fi

if ! $DRY_RUN; then
	cp -r "$DOTFILES/bin" ~/.local/bin/
fi