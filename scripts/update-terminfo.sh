#!/usr/bin/env bash
#
# This script will update the terminfo database with the latest version of
# terminfo definitions from ncurses for tmux, and alacrity.
# See: https://gist.github.com/bbqtd/a4ac060d6f6b9ea6fe3aabe735aa9d95

set -e

tmpdir=$(mktemp -d)
cd "$tmpdir"

# Download latest ncurses terminfo database
echo "Downloading and extracting terminfo database..."
curl -sLO https://invisible-island.net/datafiles/current/terminfo.src.gz && gunzip terminfo.src.gz

# Update database
echo "Updating terminfo database..."
/usr/bin/tic -xe alacritty,alacritty-direct,tmux-256color terminfo.src

# Cleanup
echo "Cleaning up..."
rm -rf "$tmpdir"
