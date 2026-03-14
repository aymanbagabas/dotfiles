#!/bin/sh

templatize gitconfig.tmpl > ~/.gitconfig
link_file gitignore ~/.gitignore
