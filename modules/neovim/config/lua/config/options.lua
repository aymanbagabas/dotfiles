-- <leader> key. Defaults to `\`. Some people prefer space.
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.smart_relativenumber = true
vim.g.blameline = false
vim.g.show_inlay_hint = false
vim.g.editorconfig = true
vim.opt.compatible = false

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Global autoformat value
vim.g.autoformat = true

-- Don't define default vim-tmux-navigator keybindings
vim.g.tmux_navigator_no_mappings = 1

-- Netrw settings, show [nu]mber
vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro"

-- Enable true colour support
if vim.fn.has("termguicolors") then
  vim.opt.termguicolors = true
end

-- See :h <option> to see what the options do

-- Search down into subfolders
vim.opt.path = vim.o.path .. "**"

vim.opt.autowrite = true -- Enable auto write
vim.opt.clipboard = ""
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.formatoptions = "jcroqlnt" -- tcqj
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.ignorecase = true -- Ignore case
vim.opt.inccommand = "nosplit" -- preview incremental substitute
vim.opt.laststatus = 3 -- global statusline
vim.opt.list = true -- Show some invisible characters (tabs...
-- Hide default tab symbol (handled by indent-Blankline)
vim.opt.listchars:append({ tab = "  " })
vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.number = true -- Print line number
vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.scrolloff = 4 -- Lines of context
vim.opt.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds"
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.showmode = false -- Dont show mode since we have a statusline
vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.spelllang = "en" -- TODO: add arabic
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitkeep = "screen"
vim.opt.splitright = true -- Put new windows right of current
vim.opt.tabstop = 4 -- Number of spaces tabs count for
vim.opt.termguicolors = true -- True color support
if not vim.g.vscode then
  vim.opt.timeoutlen = 300 -- Lower than default (1000) to quickly trigger which-key
end
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold
vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.wrap = true -- Enable line wrap
vim.opt.title = true -- Enable window title
-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append("<>[]hl")

vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  -- fold = "⸱",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

vim.opt.showmatch = true -- Highlight matching parentheses, etc
vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.spell = true

vim.opt.shiftwidth = 2
vim.opt.nrformats = "bin,hex" -- 'octal'

if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.smoothscroll = true
end

vim.opt.colorcolumn = "100"

-- Native plugins
vim.cmd.filetype("plugin", "indent", "on")
vim.cmd.packadd("cfilter") -- Allows filtering the quickfix list with :cfdo
