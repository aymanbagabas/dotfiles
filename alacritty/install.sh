#!/bin/sh

# Create alacritty config directory
if ! $DRY_RUN; then
	mkdir -p ~/.config/alacritty
fi

link_file config.yml ~/.config/alacritty/alacritty.yml
link_file config.toml ~/.config/alacritty/alacritty.toml
