-- Browse
-- Needed to make GBrowse work
-- https://github.com/tpope/vim-fugitive/blob/2febbe1f00be04f16daa6464cb39214a8566ec4b/autoload/fugitive.vim#LL7280C18-L7280C29
vim.api.nvim_create_user_command("Browse", function(opts)
  local job = require("plenary.job")
  local sysname = vim.loop.os_uname().sysname
  local cmd
  if sysname == "Darwin" then
    cmd = "open"
  elseif sysname == "Linux" then
    cmd = "xdg-open"
  elseif sysname == "Windows" then
    cmd = "start"
  end
  job:new({ command = cmd, args = opts.fargs }):start()
end, { nargs = 1, desc = "Open", })

vim.keymap.set('n', "<leader>go", "<cmd>GBrowse!<cr>", { desc = "Copy Project URL", })
vim.keymap.set('n', "<leader>gO", "<cmd>GBrowse<cr>", { desc = "Open Project URL", })
vim.keymap.set({ "n", "x" }, "<leader>gb", "<cmd>.GBrowse!<cr>", { desc = "Copy Line URL", })
vim.keymap.set({ "n", "x" }, "<leader>gB", "<cmd>.GBrowse<cr>", { desc = "Open Line URL", })
vim.keymap.set({ "n", "x" }, "<leader>gS", "<cmd>G<cr>", { desc = "Git Status", })
