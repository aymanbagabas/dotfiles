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
      -- Use nvim-cmp
      accept = false, -- "<M-l>",
      accept_word = false,
      accept_line = false,
      next = false, -- "<M-]>",
      prev = false, -- "<M-[>",
      dismiss = false, -- "<C-]>",
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
}

require("copilot").setup(opts)
