#!/bin/sh

mkdir -p ~/.gnupg
chmod 700 ~/.gnupg

templatize gpg.conf.tmpl > ~/.gnupg/gpg.conf
link_file gpg-agent.conf ~/.gnupg/gpg-agent.conf

# Import key from keyserver
if command -v gpg >/dev/null 2>&1 && [ -n "$KEYID" ]; then
	gpg --keyserver hkps://keys.openpgp.org --recv-keys "$KEYID"
fi
