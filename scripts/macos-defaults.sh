#!/usr/bin/env sh
# Apply macOS system defaults
# Translated from hosts/darwin.nix system.defaults

set -e

# ── Dock ──────────────────────────────────────────────────────────────────────

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0.0
defaults write com.apple.dock orientation -string "bottom"

dock_app() {
  printf '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>%s</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' "$1"
}

defaults write com.apple.dock persistent-apps -array \
  "$(dock_app /System/Cryptexes/App/System/Applications/Safari.app)" \
  "$(dock_app /System/Applications/Messages.app)" \
  "$(dock_app /System/Applications/Mail.app)" \
  "$(dock_app /System/Applications/Calendar.app)" \
  "$(dock_app /System/Applications/Contacts.app)" \
  "$(dock_app /System/Applications/Reminders.app)" \
  "$(dock_app /System/Applications/Notes.app)" \
  "$(dock_app /Applications/Slack.app)" \
  "$(dock_app /Applications/Discord.app)" \
  "$(dock_app /Applications/Ghostty.app)" \
  "$(dock_app /Applications/rio.app)" \
  "$(dock_app /System/Applications/App\ Store.app)" \
  "$(dock_app /System/Applications/System\ Settings.app)"

# ── Trackpad ──────────────────────────────────────────────────────────────────

defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# ── Finder ────────────────────────────────────────────────────────────────────

defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" # list view
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true

# ── NSGlobalDomain ────────────────────────────────────────────────────────────

defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain AppleEnableMouseSwipeNavigateWithScrolls -bool true
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true

# ── Restart affected apps ─────────────────────────────────────────────────────

killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
