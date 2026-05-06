#!/bin/sh

mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/direnv"
link_file direnv.toml "${XDG_CONFIG_HOME:-$HOME/.config}/direnv/direnv.toml"
