#!/bin/sh

# pnpm keeps one content-addressed store and hard-links packages from it into
# each `node_modules`, so ten worktrees of the same repository cost one copy on
# disk. The store must sit on the same filesystem as the checkouts, or pnpm
# falls back to copying and the saving disappears.
#
# The path below is also pnpm's own default on Linux and macOS. Setting it
# explicitly pins it, so the store cannot move to a per-drive location and
# silently split into two.
#
# Use `pnpm config set --global` rather than linking an rc file: pnpm writes
# this file itself, and a link would fight it.
if command_exist pnpm; then
	echo "Setting pnpm store directory..."

	if ! $DRY_RUN; then
		pnpm config set --global store-dir "$HOME/.local/share/pnpm/store"
	fi
fi
