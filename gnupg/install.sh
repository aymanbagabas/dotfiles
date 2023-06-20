#!/bin/sh

# Create gnupg config directory
if ! $DRY_RUN; then
	mkdir -p ~/.gnupg
fi

##### gpg.conf

insert_line "default-key" "default-key $KEYID" ~/.gnupg/gpg.conf
insert_line "default-recipient-self" "default-recipient-self" ~/.gnupg/gpg.conf
# Use OpenPGP keyserver
insert_line "keyserver" "keyserver hkps://keys.openpgp.org" ~/.gnupg/gpg.conf

##### gpg-agent.conf

# set pinentry
_pinentry=""
case "$OSTYPE" in
darwin*)
	require "pinentry-mac"
	_pinentry=$(command -v pinentry-mac)
	;;
linux*)
	require "pinentry-tty"
	_pinentry=$(command -v pinentry-tty)
	;;
esac
if [ -n "$_pinentry" ]; then
	insert_line "pinentry-program" "pinentry-program $_pinentry" ~/.gnupg/gpg-agent.conf
fi

# ask passphrase once every day
insert_line "default-cache-ttl" "default-cache-ttl 86400" ~/.gnupg/gpg-agent.conf
insert_line "max-cache-ttl" "max-cache-ttl 86400" ~/.gnupg/gpg-agent.conf

# enable ssh support
insert_line "enable-ssh-support" "enable-ssh-support" ~/.gnupg/gpg-agent.conf

if command_exist gpp-connect-agent; then
	gpg-connect-agent reloadagent /bye
fi
