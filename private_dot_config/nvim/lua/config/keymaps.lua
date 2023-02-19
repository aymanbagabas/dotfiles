-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local unmap = vim.keymap.del

-- copy to clipboard
map({ "n", "x" }, "<leader>y", '"+y', { desc = "Copy to clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Copy line to clipboard" })
-- restore gw to default
unmap("n", "gw")
unmap("x", "gw")

-- Move Lines
-- remap <C-j> and <C-k> to move lines up and down
map("n", "<C-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<C-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<C-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<C-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<C-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<C-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- search and center screen on search result
map({ "n", "x", "o" }, "n", "nzzzv", { desc = "Next search result" })
map({ "n", "x", "o" }, "N", "Nzzzv", { desc = "Prev search result" })

-- navigate quickfix/location list
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
map("n", "[q", "<cmd>cprev<cr>", { desc = "Prev quickfix" })
map("n", "]l", "<cmd>lnext<cr>", { desc = "Next location" })
map("n", "[l", "<cmd>lprev<cr>", { desc = "Prev location" })
