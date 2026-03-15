defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$(abspath "${BASH_SOURCE[0]}")"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
