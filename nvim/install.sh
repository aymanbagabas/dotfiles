#!/bin/bash

# Create nvim config directory
if ! $DRY_RUN; then
	mkdir -p ~/.config/nvim
fi

link_file lua ~/.config/nvim/lua
link_file init.lua ~/.config/nvim/init.lua
link_file lazy-lock.json ~/.config/nvim/lazy-lock.json
link_file neoconf.json ~/.config/nvim/neoconf.json
