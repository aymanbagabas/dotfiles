-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

-- separate vim registers from clipboard
opt.clipboard = ""
opt.tabstop = 4
opt.wrap = true
-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")
opt.title = true
-- enable undofil
opt.undofile = true
-- set scroll offset to 8
opt.scrolloff = 8
-- Hide default tab symbol (handled by indent-Blankline)
opt.listchars:append({ tab = "  " })
-- Enable spell checking
opt.spell = true
-- Set completeopt
opt.completeopt = "menu,menuone,noinsert"
-- Set sessionoptions
opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Global options
local g = vim.g
g.blameline = false