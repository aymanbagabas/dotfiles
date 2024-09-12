require("config.options")
require("config.keymaps")

require("user.autocommands")
require("user.lsp")

-- Add local plugin rtp path.
vim.opt.runtimepath:append("~/.local/share/nvim/site/pack/*/start/*")
vim.opt.runtimepath:append("~/.local/share/nvim/site/plugin/*")
