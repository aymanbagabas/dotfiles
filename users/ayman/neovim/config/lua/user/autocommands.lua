local tempdirgroup = vim.api.nvim_create_augroup("tempdir", { clear = true })
-- Do not set undofile for files in /tmp
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "/tmp/*",
  group = tempdirgroup,
  callback = function()
    vim.cmd.setlocal("noundofile")
  end,
})

-- Disable spell checking in terminal buffers
local nospell_group = vim.api.nvim_create_augroup("nospell", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
  group = nospell_group,
  callback = function()
    vim.wo[0].spell = false
  end,
})

--- Don't create a comment string when hitting <Enter> on a comment line
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("DisableNewLineAutoCommentString", {}),
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
  end,
})

-- Toggle between relative/absolute line numbers
-- Show relative line numbers in the current buffer,
-- absolute line numbers in inactive buffers
local numbertoggle = vim.api.nvim_create_augroup("numbertoggle", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  pattern = "*",
  group = numbertoggle,
  callback = function()
    if vim.g.smart_relativenumber and vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  pattern = "*",
  group = numbertoggle,
  callback = function()
    if vim.g.smart_relativenumber and vim.o.nu then
      vim.opt.relativenumber = false
      vim.cmd.redraw()
    end
  end,
})

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Set spell & wrap for certain files
vim.api.nvim_create_autocmd({ "FileType", "BufRead" }, {
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
vim.api.nvim_create_autocmd({ "FileType", "BufRead" }, {
  pattern = {
    "COMMIT_EDITMSG",
    "gitcommit",
    "NeogitCommitMessage",
  },
  command = "goto 1 | startinsert",
  group = vim.api.nvim_create_augroup("AutoInsert", { clear = true }),
})

-- Simple session management on directory open
vim.api.nvim_create_autocmd("VimEnter", {
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

    -- open the directory in Oil
    if not vim.g.save_session then
      require("oil").open(data.file)
    end
  end,
  nested = true,
})

vim.api.nvim_create_autocmd("VimLeave", {
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
