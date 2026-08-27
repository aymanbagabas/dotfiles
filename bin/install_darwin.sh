#!/bin/sh

echo "Installing macOS bin executables..."

# Only macOS needs these: its sed and awk are BSD, while everywhere else they
# are already GNU. bin/install.sh leaves this directory alone because it only
# links regular files.
link_file "darwin/sed" "$HOME/.bin/sed"
link_file "darwin/awk" "$HOME/.bin/awk"
