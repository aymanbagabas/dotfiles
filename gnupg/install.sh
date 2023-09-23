#!/bin/sh

# Create gnupg config directory
if ! $DRY_RUN; then
	mkdir -p ~/.gnupg
fi

##### gpg.conf

echo "Creating gpg.conf file..."
if ! $DRY_RUN; then
	gpgconf=$(templatize gpg.conf)
	echo "$gpgconf" >~/.gnupg/gpg.conf
fi

##### gpg-agent.conf

# set pinentry
PINENTRY_PROGRAM=""
case "$OSTYPE" in
darwin*)
	require "pinentry-mac"
	PINENTRY_PROGRAM=$(command -v pinentry-mac)
	;;
linux*)
	require "pinentry-tty"
	PINENTRY_PROGRAM=$(command -v pinentry-tty)
	;;
*)
	require "pinentry"
	PINENTRY_PROGRAM=$(command -v pinentry)
	;;
esac

echo "Creating gpg-agent.conf file..."
if ! $DRY_RUN; then
	gpgagentconf=$(templatize gpg-agent.conf)
	echo "$gpgagentconf" >~/.gnupg/gpg-agent.conf
fi

if command_exist gpp-connect-agent; then
	gpg-connect-agent reloadagent /bye
fi
