#!/bin/sh

echo "Installing bin executables..."

for script in "$DOTFILES"/bin/*; do
	name=${script##*/}
	if [ "$name" = "install.sh" ] || [ "$name" = "install.ps1" ] || [ ! -f "$script" ]; then
		continue
	fi

	link_file "$name" "$HOME/.bin/$name"
done
