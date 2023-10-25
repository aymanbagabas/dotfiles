#!/bin/sh

# Create alacritty config directory
if ! $DRY_RUN; then
	mkdir -p ~/.config/alacritty
fi

link_file config ~/.config/alacritty/alacritty.yml
