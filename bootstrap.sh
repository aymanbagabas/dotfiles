#!/bin/bash

# Exit on error
set -e

# Source global variables
. ./.vars

DOTFILES=$(realpath $(dirname -- "${BASH_SOURCE[0]}"))
DRY_RUN=false

function link_file() {
	local path=$(realpath $(dirname -- ${BASH_SOURCE[1]}))
	local from=$path/$1
	local to=$2
	printf "Linking '%s' to '%s'\n" "$from" "$to"

	if [ ! -d $(dirname -- "$to") ]; then
		mkdir -p $(dirname -- "$to")
	fi

	if ! $DRY_RUN; then
		ln -sf "$from" "$to"
	fi
}

function insert_line() {
	local query=$1
	local line=$2
	local file=$3
	printf "Inserting '%s' into '%s'\n" "$line" "$file"
	if ! $DRY_RUN; then
		grep -q "$query" "$file" || echo "$line" >>"$file"
	fi

}

function command_exist() {
	command -v "$1" >/dev/null 2>&1
}

function require() {
	local cmd=$1
	command_exist "$cmd" || (printf "Command '%s' not found\n" "$cmd" && false)
}

function _install() {
	if ! $DRY_RUN; then
		echo "Installing/updating dotfiles..."
	else
		echo "Dry run, not installing/updating dotfiles..."
	fi
	echo

	for src in $DOTFILES/*/; do
		local src=${src%*/}
		local install="$src/install.sh"
		if [ -f "$install" ]; then
			echo "===== Installing" "$src" "dotfiles..."
			. "$install"
			echo
		fi

		case "$OSTYPE" in
		darwin*)
			local install="$src/install_darwin.sh"
			if [ -f "$install" ]; then
				echo "===== Installing" "$src" "dotfiles for darwin..."
				. "$install"
				echo
			fi
			;;
		linux*)
			local install="$src/install_linux.sh"
			if [ -f "$install" ]; then
				echo "===== Installing" "$src" "dotfiles for linux..."
				. "$install"
				echo
			fi
			;;
		esac
	done

	echo "Done installing/updating dotfiles"
	echo

	# Set shell
	. "$DOTFILES/scripts/set-shell.sh"
}

function _usage() {
	echo "Usage: $0 [options] [command]"
	echo
	echo "Commands:"
	echo "  install   Install dotfiles"
	echo "  packages  Install packages"
	echo "  bin       Install binaries"
	echo "  help      Show this help message and exit"
	echo
	echo "Options:"
	echo "  -h        Show this help message and exit"
	echo "  -d        Dry run"
}

function _main() {
	while getopts ":hd" opt; do
		case $opt in
		h)
			_usage
			exit 0
			;;
		d)
			DRY_RUN=true
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			_usage
			exit 1
			;;
		esac
	done

	shift $((OPTIND - 1))

	local cmd=$1
	case $cmd in
	install)
		_install
		;;
	packages)
		. "$DOTFILES/scripts/packages.sh"
		;;
	bin)
		. "$DOTFILES/scripts/bin.sh"
		;;
	help)
		_usage
		;;
	*)
		if [ -n "$cmd" ]; then
			echo "Invalid command: $cmd" >&2
		fi
		_usage
		exit 1
		;;
	esac
}

_main "$@"
