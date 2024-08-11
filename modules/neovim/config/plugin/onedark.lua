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
