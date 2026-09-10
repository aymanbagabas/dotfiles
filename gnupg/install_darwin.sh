#!/bin/sh

# pinentry-mac gives a GUI prompt, so PIN entry works from editors and from
# non-interactive shells. gnupg/install.sh puts this into gpg-agent.conf, and
# leaves the line out when the program is absent.
GPG_PINENTRY_PROGRAM="$(command -v pinentry-mac || true)"
