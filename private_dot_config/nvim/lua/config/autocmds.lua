-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local autocmd = vim.api.nvim_create_autocmd

-- Autotoggle relativenumber
autocmd({
  "BufEnter",
  "FocusGained",
  "InsertLeave",
  "WinEnter",
}, {
  pattern = { "*" },
  callback = function()
    vim.cmd([[if &nu && mode() != "i" | set rnu | endif]])
  end,
})
autocmd({
  "BufLeave",
  "FocusLost",
  "InsertEnter",
  "WinLeave",
}, {
  pattern = { "*" },
  callback = function()
    vim.cmd([[if &nu | set nornu | endif]])
  end,
})

-- Restore cursor last position
-- see also :help last-position-jump
-- autocmd(
--   { "BufReadPost" },
--   {
--     pattern = { "*" },
--     callback = function()
--       vim.cmd [[autocmd FileType <buffer> ++once
--       \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif]]
--     end
--   }
-- )
-- go to last loc when opening a buffer
autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Set spell & wrap for certain files
autocmd({ "FileType", "BufRead" }, {
  pattern = {
    "*.txt",
    "*.md",
    "*.tex",
    "COMMIT_EDITMSG",
    "gitcommit",
    "gitrebase",
    "markdown",
    "NeogitCommitMessage",
  },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
  group = vim.api.nvim_create_augroup("Spell", { clear = true }),
})

-- Auto insert mode for certain files
autocmd({ "FileType", "BufRead" }, {
  pattern = {
    "COMMIT_EDITMSG",
    "gitcommit",
    "NeogitCommitMessage",
  },
  command = "goto 1 | startinsert",
  group = vim.api.nvim_create_augroup("AutoInsert", { clear = true }),
})

-- close some filetypes with <q>
autocmd("FileType", {
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    -- buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1
    if not directory then
      return
    end
    -- create a new, empty buffer
    vim.cmd.enew()
    -- wipe the directory buffer
    vim.cmd.bw(data.buf)
    -- change to the directory
    vim.cmd.cd(data.file)
    -- open the tree
    -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":NvimTreeFocus<CR>", true, false, true), "n", true)
    -- require("nvim-tree.api").tree.open()
    -- load session
    -- require("persistence").load()
    require("persisted").load()
  end,
})
