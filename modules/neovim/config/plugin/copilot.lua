local opts = {
  panel = {
    enabled = true,
    auto_refresh = true,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>",
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    hide_during_completion = false,
    debounce = 75,
    keymap = {
      -- We integrate with blink.cmp to hide the menu
      -- when suggestions are visible.
      accept = false, -- "<Tab>", -- see below
      accept_word = "<C-l>",
      accept_line = "<C-S-l>",
      next = "<C-k>",
      prev = "<C-j>",
      dismiss = "<C-e>",
    },
  },
  filetypes = {
    yaml = true,
    markdown = true,
    help = false,
    gitcommit = true,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  --copilot_node_command = "node", -- Node version must be < 18
  --plugin_manager_path = vim.fn.stdpath("data") .. "/lazy",
  server_opts_overrides = {},
  server = {
    type = "binary",
    -- Home Manager Neovim wrapper exports the LSP path, we just need to
    -- specify the name of the binary.
    custom_server_filepath = "copilot-language-server",
  },
}

require("copilot").setup(opts)

-- Fallback <Tab> when there are no suggestions
vim.keymap.set("i", "<Tab>", function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
  end
end, {
  silent = true,
})

-- Disable default keymaps
-- vim.g.copilot_no_maps = true
--
-- vim.keymap.set("i", "<Tab>", 'copilot#Accept("")', {
--   desc = "Accept Copilot suggestion",
--   expr = true,
--   replace_keycodes = false,
-- })
--
-- vim.keymap.set("i", "<C-l>", "<Plug>(copilot-accept-word)", {
--   desc = "Accept Copilot word",
-- })
--
-- vim.keymap.set("i", "<C-S-l>", "<Plug>(copilot-accept-word)", {
--   desc = "Accept Copilot line",
-- })
--
-- vim.keymap.set("i", "<C-k>", "<Plug>(copilot-next)", {
--   desc = "Show next Copilot suggestion",
-- })
--
-- vim.keymap.set("i", "<C-j>", "<Plug>(copilot-previous)", {
--   desc = "Show prev Copilot suggestion",
-- })
--
-- vim.keymap.set("i", "<C-e>", "<Plug>(copilot-dismiss)", {
--   desc = "Dismiss Copilot",
-- })
