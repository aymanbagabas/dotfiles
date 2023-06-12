#!/bin/sh

# Create karabiner config directory
if ! $DRY_RUN; then
	mkdir -p ~/.config/karabiner
fi

link_file karabiner.json ~/.config/karabiner/karabiner.json
