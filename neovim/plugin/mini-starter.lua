local starter = require("mini.starter")

local logo = table.concat({
  "  _  _             _        ",
  " | \\| |___ _____ _(_)_ __   ",
  " | .` / -_) _ \\ V / | '  \\  ",
  " |_|\\_\\___\\___/\\_/|_|_|_|_| ",
}, "\n")

local items = {
  { name = "  Find file", action = "Telescope find_files", section = "Actions" },
  { name = "  New file", action = "ene | startinsert", section = "Actions" },
  { name = "  Recent files", action = "Telescope oldfiles", section = "Actions" },
  { name = "  Find text", action = "Telescope live_grep", section = "Actions" },
  { name = "  Projects", action = "Telescope project", section = "Actions" },
  { name = "  Quit", action = "qa", section = "Actions" },
}

starter.setup({
  evaluate_single = true,
  header = logo,
  footer = "Ayman Bagabas ™️",
  items = items,
  content_hooks = {
    starter.gen_hook.aligning("center", "center"),
    starter.gen_hook.padding(2, 2),
  },
})
