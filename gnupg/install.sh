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
	PINENTRY_PROGRAM="/usr/local/bin/pinentry-mac"
	if command_exist pinentry-mac; then
		PINENTRY_PROGRAM=$(command -v pinentry-mac)
	fi
	;;
linux*)
	PINENTRY_PROGRAM="/usr/bin/pinentry-tty"
	if command_exist pinentry-tty; then
		PINENTRY_PROGRAM=$(command -v pinentry-tty)
	fi
	;;
*)
	PINENTRY_PROGRAM="/usr/bin/pinentry"
	if command_exist pinentry; then
		PINENTRY_PROGRAM=$(command -v pinentry)
	fi
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
