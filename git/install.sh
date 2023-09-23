#!/bin/sh

require "git"

link_file ignore ~/.gitignore

echo "Creating gitconfig file..."
if ! $DRY_RUN; then
	eval "$(templatize config)"

	if command_exist "diff-highlight"; then
		git config --global core.pager "diff-highlight | less"
		git config --global interactive.diffFilter "diff-highlight"
	fi
fi
