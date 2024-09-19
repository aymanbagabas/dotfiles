{
  ...
}:
{
  home.file.".wezterm.lua".text = ''
    local wezterm = require("wezterm");

    -- This will hold the configuration.
    local config = wezterm.config_builder()

    config.color_scheme = "OneDark (base16)"
    config.font = wezterm.font("Inconsolata LGC")

    -- Enable Kitty keyboard
    config.enable_kitty_keyboard = true

    return config
  '';
}
