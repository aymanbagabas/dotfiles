local opts = {
  -- symbol = "│",
  symbol = "▏",
  options = { try_as_border = true },
  draw = {
    -- disable animation
    animation = require("mini.indentscope").gen_animation.none(),
  },
}

require('mini.indentscope').setup(opts)

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "help",
    "alpha",
    "dashboard",
    "neo-tree",
    "Trouble",
    "lazy",
    "mason",
    "notify",
    "toggleterm",
    "lazyterm",
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})
