local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "OneDark (base16)"
config.font = wezterm.font("JetBrains Mono")

config.enable_kitty_keyboard = true

return config
