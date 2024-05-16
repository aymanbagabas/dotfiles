local opts = {
  sources = { "filesystem", "buffers", "git_status", "document_symbols" },
  open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
  filesystem = {
    bind_to_cwd = false,
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
  },
  source_selector = {
    winbar = false,
    statusline = false,
  },
  close_if_last_window = true,
  window = {
    mappings = {
      ["<space>"] = "none",
      ["Y"] = {
        function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          vim.fn.setreg("+", path, "c")
        end,
        desc = "Copy Path to Clipboard",
      },
      ["O"] = {
        function(state)
          require("lazy.util").open(state.tree:get_node().path, { system = true })
        end,
        desc = "Open with System Application",
      },
    },
  },
  default_component_configs = {
    indent = {
      with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
  },
}

require("neo-tree").setup(opts)

vim.keymap.set('n', "<leader>fe", function() require("neo-tree.command").execute({ toggle = true, dir = require('project_nvim.project').get_project_root() }) end, { desc = "Explorer NeoTree (Root Dir)", })
vim.keymap.set('n', "<leader>fE", function() require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() }) end, { desc = "Explorer NeoTree (cwd)", })
vim.keymap.set('n', "<leader>e", "<leader>fe", { desc = "Explorer NeoTree (Root Dir)", remap = true })
vim.keymap.set('n', "<leader>E", "<leader>fE", { desc = "Explorer NeoTree (cwd)", remap = true })
vim.keymap.set('n', "<leader>ge", function() require("neo-tree.command").execute({ source = "git_status", toggle = true }) end, { desc = "Git Explorer", })
vim.keymap.set('n', "<leader>be", function() require("neo-tree.command").execute({ source = "buffers", toggle = true }) end, { desc = "Buffer Explorer", })
