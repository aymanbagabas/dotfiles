require('zen-mode').setup({
  plugins = {
    gitsigns = { enabled = true },
  },
})

vim.keymap.set('n', "<leader>uZ", "<cmd>ZenMode<cr>", { desc = "Toggle Zen Mode", })
