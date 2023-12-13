-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local autocmd = vim.api.nvim_create_autocmd

-- Autotoggle relativenumber
if vim.g.smart_relativenumber then
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
end

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

local log = require("plenary.log").new({
  plugin = "autocmd",
  level = "debug",
})

-- Simple session management on directory open
autocmd("VimEnter", {
  callback = function(data)
    -- buffer is a directory
    local isdirectory = vim.fn.isdirectory(data.file) == 1
    if not isdirectory then
      return
    end

    -- save session before exit
    vim.g.save_session = false

    -- check if directory is a project directory
    for _, root in ipairs({
      ".git",
      ".hg",
      ".bzr",
      ".svn",
      "_darcs",
      "Makefile",
      "package.json",
      "go.mod",
    }) do
      if vim.fn.isdirectory(data.file .. "/" .. root) == 1 then
        vim.g.save_session = true
        break
      end
    end

    if vim.g.save_session then
      -- source session.vim if it exists
      local sessionfile = vim.fn.resolve(data.file .. "/.nvim/session.vim")
      if vim.fn.filereadable(sessionfile) == 1 then
        vim.cmd("silent! source " .. sessionfile)
      end
    end

    -- wipe the directory buffer
    vim.cmd("bw " .. data.buf)
  end,
  nested = true,
})

autocmd("VimLeave", {
  callback = function(data)
    -- only save session if vim started on a directory
    if not vim.g.save_session then
      return
    end

    -- sanitize bad sessionoptions
    local sessionopts = vim.opt.sessionoptions:get()
    vim.opt.sessionoptions:remove("blank")
    vim.opt.sessionoptions:remove("options")
    vim.opt.sessionoptions:append("tabpages")

    local sessionfile = ".nvim/session.vim"
    if vim.v.this_session ~= "" then
      sessionfile = vim.v.this_session
    end

    vim.fn.mkdir(".nvim", "p")
    vim.cmd("mksession! " .. sessionfile)

    -- restore sessionoptions
    vim.opt.sessionoptions = sessionopts
  end,
})
