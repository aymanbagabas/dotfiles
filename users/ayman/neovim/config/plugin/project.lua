require('project_nvim').setup()

vim.keymap.set('n', "<leader>fp", "<Cmd>Telescope projects<CR>", { desc = "Projects" })
