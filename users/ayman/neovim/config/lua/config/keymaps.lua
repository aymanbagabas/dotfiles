local api = vim.api
local fn = vim.fn
local keymap = vim.keymap
local diagnostic = vim.diagnostic

-- better up/down
keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Resize window using <ctrl> arrow keys
keymap.set("n", "<M-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
keymap.set("n", "<M-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
keymap.set("n", "<M-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
keymap.set("n", "<M-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines
keymap.set("n", "<C-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
keymap.set("n", "<C-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
keymap.set("i", "<C-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
keymap.set("i", "<C-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
keymap.set("v", "<C-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
keymap.set("v", "<C-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- buffers
keymap.set("n", "<Tab>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap.set("n", "<S-Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Clear search with <esc>
keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
keymap.set(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- Add undo break-points
keymap.set("i", ",", ",<c-g>u")
keymap.set("i", ".", ".<c-g>u")
keymap.set("i", ";", ";<c-g>u")

-- save file
keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

--keywordprg
keymap.set("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- new file
keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- stylua: ignore start

-- quit
keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- highlights under cursor
keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

-- Terminal Mappings
keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- windows
keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })

-- tabs
keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- copy to clipboard
keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "Copy to clipboard" })
keymap.set("n", "<leader>Y", '"+Y', { desc = "Copy line to clipboard" })

-- diff
keymap.set("n", "gh", "<cmd>diffget //2<cr>", { desc = "Get from left" })
keymap.set("n", "gl", "<cmd>diffget //3<cr>", { desc = "Get from right" })

-- search and center screen on search result
keymap.set({ "n", "x", "o" }, "n", "nzzzv", { desc = "Next search result" })
keymap.set({ "n", "x", "o" }, "N", "Nzzzv", { desc = "Prev search result" })

keymap.set("n", "<leader>us", function()
  vim.opt.spell = not(vim.opt.spell:get())
  vim.notify("Spell: " .. (vim.opt.spell:get() and "on" or "off"))
end, { desc = "Toggle Spelling" })

keymap.set("n", "<leader>ub", function()
  -- toggle current line blame
  -- vim.g.blameline is defined in options
  vim.g.blameline = not vim.g.blameline
  require("gitsigns").toggle_current_line_blame(blameline)
  vim.notify("Blame Line: " .. (vim.g.blameline and "on" or "off"))
end, { desc = "Toggle Git Line Blame" })

keymap.set("n", "<leader>uS", function()
  -- toggle smart relativeline
  vim.g.smart_relativenumber = not vim.g.smart_relativenumber
  vim.opt.relativenumber = false
  vim.notify("Smart Relative Line: " .. (vim.g.smart_relativenumber and "on" or "off"))
end, { desc = "Toggle Smart Relative Line" })
