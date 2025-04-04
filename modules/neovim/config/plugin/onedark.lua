local onedark = require("onedark")

onedark.setup({
  transparent = false,
  style = "dark",
  lualine = {
    transparent = true,
  },
})

onedark.load()

-- Load the colorscheme
vim.cmd.colorscheme("onedark")

-- Link WinBar and WinBarNC to Normal and NormalNC
vim.api.nvim_set_hl(0, "WinBar", { link = "Normal" })
vim.api.nvim_set_hl(0, "WinBarNC", { link = "NormalNC" })
