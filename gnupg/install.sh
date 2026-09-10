#!/bin/sh

# gnupg/install_darwin.sh sets GPG_PINENTRY_PROGRAM before this script runs.
templatize gpg.conf.tmpl >/tmp/gnupg.$$.gpg.conf
templatize gpg-agent.conf.tmpl >/tmp/gnupg.$$.gpg-agent.conf

if $DRY_RUN; then
	rm -f /tmp/gnupg.$$.gpg.conf /tmp/gnupg.$$.gpg-agent.conf
else
	mkdir -p "$HOME/.gnupg"
	chmod 700 "$HOME/.gnupg"

	# The old layout symlinked these into the repository, and a redirection
	# follows a symlink, so it would write to the repository instead.
	rm -f "$HOME/.gnupg/gpg.conf" "$HOME/.gnupg/gpg-agent.conf"

	mv /tmp/gnupg.$$.gpg.conf "$HOME/.gnupg/gpg.conf"
	mv /tmp/gnupg.$$.gpg-agent.conf "$HOME/.gnupg/gpg-agent.conf"
	chmod 600 "$HOME/.gnupg/gpg.conf" "$HOME/.gnupg/gpg-agent.conf"

	echo "Wrote $HOME/.gnupg/gpg.conf and $HOME/.gnupg/gpg-agent.conf"
fi
