-- Disable default mappings
vim.g.conflict_marker_enable_mappings = 0

-- Set up key mappings
vim.keymap.set("n", "co", "<Plug>(conflict-marker-ourselves)")
vim.keymap.set("n", "ct", "<Plug>(conflict-marker-themselves)")
vim.keymap.set("n", "cn", "<Plug>(conflict-marker-none)")
vim.keymap.set("n", "cb", "<Plug>(conflict-marker-both)")
vim.keymap.set("n", "cB", "<Plug>(conflict-marker-both-rev)")
