return {
  {
    "folke/persistence.nvim",
    enabled = false,
    -- event = "BufReadPre",
    -- opts = {
    --   dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
    --   options = {
    --     -- "blank",
    --     "buffers",
    --     "curdir",
    --     "folds",
    --     "help",
    --     "tabpages",
    --     "winsize",
    --     "winpos",
    --     "terminal",
    --     "localoptions",
    --   },
    -- },
    -- -- stylua: ignore
    -- keys = {
    --   { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
    --   { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    --   { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    -- },
    -- config = function(_, opts)
    --   require("persistence").setup(opts)
    -- end,
  },

  {
    "olimorris/persisted.nvim",
    opts = {
      save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- directory where session files are saved
      command = "VimLeavePre", -- the autocommand for which the session is saved
      silent = false, -- silent nvim message when sourcing session file
      use_git_branch = false, -- create session files based on the branch of the git enabled repository
      autosave = true, -- automatically save session files when exiting Neovim
      should_autosave = nil, -- function to determine if a session should be autosaved
      autoload = false, -- automatically load the session for the cwd on Neovim startup
      on_autoload_no_session = function()
        -- create a new, empty buffer
        vim.cmd.enew()
        vim.cmd("Neotree")
      end, -- function to run when `autoload = true` but there is no session to load
      follow_cwd = true, -- change session file name to match current working directory if it changes
      allowed_dirs = nil, -- table of dirs that the plugin will auto-save and auto-load from
      ignored_dirs = nil, -- table of dirs that are ignored when auto-saving and auto-loading
      before_save = nil, -- function to run before the session is saved to disk
      after_save = nil, -- function to run after the session is saved to disk
      after_source = nil, -- function to run after the session is sourced
      telescope = { -- options for the telescope extension
        before_source = nil, -- function to run before the session is sourced via telescope
        after_source = nil, -- function to run after the session is sourced via telescope
        reset_prompt_after_deletion = true, -- whether to reset prompt after session deleted
      },
    },
    config = function(_, opts)
      require("persisted").setup(opts)
      require("telescope").load_extension("persisted") -- To load the telescope extension
    end,
  },

  {
    "ahmedkhalf/project.nvim",
    enabled = false,
    opts = {
      -- Manual mode doesn't automatically change your root directory, so you have
      -- the option to manually do so using `:ProjectRoot` command.
      manual_mode = false,
      -- Methods of detecting the root directory. **"lsp"** uses the native neovim
      -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
      -- order matters: if one is not detected, the other is used as fallback. You
      -- can also delete or rearangne the detection methods.
      detection_methods = { "lsp", "pattern" },
      -- All the patterns used to detect root dir, when **"pattern"** is in
      -- detection_methods
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
      -- Table of lsp clients to ignore by name
      -- eg: { "efm", ... }
      ignore_lsp = {},
      -- Don't calculate root dir on specific directories
      -- Ex: { "~/.cargo/*", ... }
      exclude_dirs = {},
      -- Show hidden files in telescope
      show_hidden = false,
      -- When set to false, you will get a message when project.nvim changes your
      -- directory.
      silent_chdir = true,
      -- What scope to change the directory, valid options are
      -- * global (default)
      -- * tab
      -- * win
      scope_chdir = "global",
      -- Path where project.nvim will store the project history for use in
      -- telescope
      datapath = ".nvim/workspace",
    },
  },

  -- {
  --   "rmagatti/auto-session",
  --   config = function()
  --     require("user.autosession")
  --   end,
  -- },

  {
    "natecraddock/sessions.nvim",
    opts = {
      events = { "VimLeavePre", "WinEnter" },
      session_filepath = ".nvim/session",
      absolute = false,
    },
  },

  {
    "natecraddock/workspaces.nvim",
    opts = {
      path = ".nvim/workspace",
      hooks = {
        open_pre = {
          "SessionsStop",
          "silent %bdelete!",
        },
        open = {
          function()
            require("sessions").load(nil, { silent = true })
          end,
        },
      },
    },
  },
}
