vim.cmd [[syntax enable]]
vim.cmd [[syntax on]]

vim.g.nvcode_termcolors = 256
vim.o.termguicolors = true
vim.g.mapleader = " "
vim.o.hlsearch = true
vim.o.hidden = true
vim.o.updatetime = 50
vim.o.scrolloff = 5
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath "cache" .. "/undo"
vim.o.inccommand = "split"
vim.o.laststatus = 2
vim.o.cmdheight = 1
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.mouse = "a"
vim.o.errorbells = false
vim.o.title = true
vim.o.ruler = true
vim.o.showcmd = true
vim.o.startofline = false
vim.o.backspace = "indent,eol,start"
vim.o.diffopt = "filler,vertical"
vim.o.wildmenu = true
vim.wo.number = true
vim.o.numberwidth = 2
vim.g.signcolumn = "yes:1"

-- hide line numbers , statusline in specific buffers!
vim.api.nvim_exec(
    [[
        au BufEnter term://* setlocal nonumber
        au BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "NvimTree" | set laststatus=0 | else | set laststatus=2 | endif
        au BufEnter term://* set laststatus=0
    ]], false)

-- toggle relative line
vim.api.nvim_exec(
  [[
    au BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    au BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
  ]], false
)

-- remember last position
vim.api.nvim_exec(
  [[
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  ]], false
)
