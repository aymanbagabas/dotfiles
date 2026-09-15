#!/bin/sh

# Bazel reads `~/.bazelrc` after the workspace rc, so this is where a
# machine-wide shared cache belongs. The file is templated because Bazel does
# not expand `~` or `$HOME` inside an rc file.
if ! $DRY_RUN; then
	templatize bazelrc.tmpl >~/.bazelrc
fi
