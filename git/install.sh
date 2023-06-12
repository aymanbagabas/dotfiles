#!/bin/bash

require "git"

link_file ignore ~/.gitignore

if ! $DRY_RUN; then
	git config --global user.name "$NAME"
	git config --global user.email "$EMAIL"
	git config --global user.signingKey "$KEYID"

	git config --global core.excludesFile ~/.gitignore
	git config --global core.editor "nvim"
	git config --global core.abbrev 12
	git config --global core.quotePath false

	if command_exist "diff-highlight"; then
		git config --global core.pager "diff-highlight | less"
		git config --global interactive.diffFilter "diff-highlight"
	fi

	git config --global color.ui true
	git config --global color.diff.meta "yellow"
	git config --global color.diff.frag "magenta bold"
	git config --global color.diff.commit "yellow bold"
	git config --global color.diff.old "red bold"
	git config --global color.diff.new "green bold"
	git config --global color.diff.whitespace "red reverse"
	git config --global color.diff-highlight.oldNormal "red bold"
	git config --global color.diff-highlight.oldHighlight "red bold 52"
	git config --global color.diff-highlight.newNormal "green bold"
	git config --global color.diff-highlight.newHighlight "green bold 22"

	git config --global commit.gpgsign true

	git config --global pull.rebase false

	git config --global init.defaultBranch master

	git config --global gpg.program gpg

	git config --global format.signOff true

	git config --global rerere.enabled true

	git config --global alias.fixes 'log --pretty=format:"Fixes: %h (\"%s\")"'
	git config --global alias.authors 'log --pretty=format:"%ad %an <%ae>" --date=format:"%Y"'
	git config --global alias.graph 'log --graph --all --decorate --oneline'
	git config --global alias.purge-tags '!git tag -l | xargs git tag -d && git fetch -t'

	# tig config
	git config --global tig.mouse true
	git config --global tig.mouse-wheel-cursor true
	git config --global tig.color.cursor "black green bold"
fi
