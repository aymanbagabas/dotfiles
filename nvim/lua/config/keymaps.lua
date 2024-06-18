local Util = require("lazyvim.util")

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local unmap = vim.keymap.del

-- copy to clipboard
map({ "n", "x" }, "<leader>y", '"+y', { desc = "Copy to clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Copy line to clipboard" })

-- Move Lines
-- remap <C-j> and <C-k> to move lines up and down
-- and remap tmux keys
unmap({ "n", "t" }, "<C-h>")
unmap({ "n", "t" }, "<C-j>")
unmap({ "n", "t" }, "<C-k>")
unmap({ "n", "t" }, "<C-l>")
unmap({ "n", "i", "v" }, "<A-j>")
unmap({ "n", "i", "v" }, "<A-k>")

map("n", "<C-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<C-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<C-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<C-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<C-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<C-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

map({ "n", "i", "v" }, "<M-h>", "<cmd>TmuxNavigateLeft<cr>")
map({ "n", "i", "v" }, "<M-j>", "<cmd>TmuxNavigateDown<cr>")
map({ "n", "i", "v" }, "<M-k>", "<cmd>TmuxNavigateUp<cr>")
map({ "n", "i", "v" }, "<M-l>", "<cmd>TmuxNavigateRight<cr>")
map({ "n", "i", "v" }, "<M-\\>", "<cmd>TmuxNavigatePrevious<cr>")

-- search and center screen on search result
map({ "n", "x", "o" }, "n", "nzzzv", { desc = "Next search result" })
map({ "n", "x", "o" }, "N", "Nzzzv", { desc = "Prev search result" })

-- navigate quickfix/location list
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
map("n", "[q", "<cmd>cprev<cr>", { desc = "Prev quickfix" })
map("n", "]l", "<cmd>lnext<cr>", { desc = "Next location" })
map("n", "[l", "<cmd>lprev<cr>", { desc = "Prev location" })

-- tig
map("n", "<leader>gt", function()
  Util.float_term({ "tig" }, { cwd = Util.get_root() })
end, { desc = "Tig (root dir)" })
map("n", "<leader>gT", function()
  Util.float_term({ "tig" })
end, { desc = "Tig (cwd)" })

-- buffers
unmap("n", "<leader>wd")
unmap("n", "<leader>ww")
map("n", "<leader>ww", "<cmd>bd<cr>", { desc = "Close current buffer" })
map("n", "<leader>wo", "<C-W>p", { desc = "Other window" })
map("n", "<leader>wq", "<cmd>q<cr>", { desc = "Quit window" })
-- unmap H & L
unmap("n", "<S-h>")
unmap("n", "<S-l>")

-- Git
if Util.has("gitsigns.nvim") then
  map("n", "<leader>ub", function()
    -- toggle current line blame
    -- vim.g.blameline is defined in options
    vim.g.blameline = not vim.g.blameline
    require("gitsigns").toggle_current_line_blame(blameline)
  end, { desc = "Toggle Git Line Blame" })
end

-- diff
map("n", "gh", "<cmd>diffget //2<cr>", { desc = "Get from left" })
map("n", "gl", "<cmd>diffget //3<cr>", { desc = "Get from right" })
