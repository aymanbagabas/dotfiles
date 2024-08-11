local logo = {
  "  _  _             _        ",
  " | \\| |___ _____ _(_)_ __   ",
  " | .` / -_) _ \\ V / | '  \\  ",
  " |_|\\_\\___\\___/\\_/|_|_|_|_| ",
  "",
  "",
}

local opts = {
  theme = "doom",
  hide = {
    -- this is taken care of by lualine
    -- enabling this messes up the actual laststatus setting after loading a file
    statusline = false,
  },
  config = {
    header = logo,
    -- stylua: ignore
    center = {
      { action = "Telescope find_files",              desc = " Find file",       icon = " ", key = "f" },
      { action = "ene | startinsert",                 desc = " New file",        icon = " ", key = "n" },
      { action = "Telescope oldfiles",                desc = " Recent files",    icon = " ", key = "r" },
      { action = "Telescope live_grep",               desc = " Find text",       icon = " ", key = "g" },
      { action = "Telescope projects",                desc = " Projects",        icon = " ", key = "p" },
      { action = "qa",                                desc = " Quit",            icon = " ", key = "q" },
    },
    footer = {
      "Ayman Bagabas ™️",
    },
  },
}

for _, button in ipairs(opts.config.center) do
  button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
end

require("dashboard").setup(opts)
