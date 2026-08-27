#!/bin/sh

echo "Installing bin executables..."

for script in "$DOTFILES"/bin/*; do
	name=${script##*/}

	# bootstrap sources these itself; they are installers, not executables to
	# link. Matching the whole family keeps an install_darwin.sh or
	# install_linux.sh added later from ending up in ~/.bin.
	case "$name" in
	install.sh | install.ps1 | install_*.sh | install_*.ps1)
		continue
		;;
	esac

	if [ ! -f "$script" ]; then
		continue
	fi

	link_file "$name" "$HOME/.bin/$name"
done
