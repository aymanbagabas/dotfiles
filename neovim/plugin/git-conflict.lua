-- Disable default mappings
require("git-conflict").setup({
  default_mappings = false,
})

-- Set up key mappings
vim.keymap.set("n", "co", "<Plug>(git-conflict-ours)")
vim.keymap.set("n", "ct", "<Plug>(git-conflict-theirs)")
vim.keymap.set("n", "cb", "<Plug>(git-conflict-both)")
vim.keymap.set("n", "c0", "<Plug>(git-conflict-none)")
