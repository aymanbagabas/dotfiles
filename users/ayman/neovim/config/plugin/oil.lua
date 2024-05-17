require("oil").setup({
  default_file_explorer = false,
})

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
