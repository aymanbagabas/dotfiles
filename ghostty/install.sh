#!/bin/sh

# Create ghostty config directory
if ! $DRY_RUN; then
	mkdir -p ~/.config/ghostty
fi

link_file config ~/.config/ghostty/
