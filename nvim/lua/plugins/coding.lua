return {
  {
    -- use setup similar to 'tpope/vim-surround'~
    "echasnovski/mini.surround",
    enabled = false,
    keys = function(_, _)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        -- { opts.mappings.find, desc = "Find right surrounding" },
        -- { opts.mappings.find_left, desc = "Find left surrounding" },
        -- { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        -- { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
        -- Remap adding surrounding to Visual mode selection
        { "ys", false, mode = { "x" } },
        { "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], desc = "Add surrounding", mode = { "x" } },
        -- Make special mapping for "add surrounding for line"
        { "yss", "ys_", desc = "Add surrounding for line", mode = { "n" } },
      }
      return mappings
    end,
    opts = {
      mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        update_n_lines = "",
        -- Add this only if you don't want to use extended mappings
        suffix_last = "",
        suffix_next = "",
      },
    },
  },

  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },

  {
    "stevearc/aerial.nvim",
    config = true,
    opts = {
      layout = {
        width = 50,
      },
      -- Show box drawing characters for the tree hierarchy
      show_guides = true,

      -- Customize the characters used when show_guides = true
      guides = {
        -- When the child item has a sibling below it
        mid_item = "├─",
        -- When the child item is the last in the list
        last_item = "└─",
        -- When there are nested child guides to the right
        nested_top = "│ ",
        -- Raw indentation
        whitespace = "  ",
      },
    },
    keys = {
      { "<leader>cs", "<cmd>AerialToggle right<cr>", desc = "Symbols Outline" },
    },
  },

  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    opts = function(_, _)
      -- Hide Copilot suggestions when in a snippet
      -- https://github.com/zbirenbaum/copilot.lua#suggestion
      vim.api.nvim_create_autocmd("User", {
        pattern = "LuasnipPreExpand",
        callback = function()
          vim.b.copilot_suggestion_hidden = true
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "LuasnipCleanup",
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
    end,
  },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      -- "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      -- local log = require("plenary.log").new({
      --   plugin = "nvim-cmp",
      --   level = "debug",
      -- })

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      -- Don't select anything by default
      opts.preselect = cmp.PreselectMode.None

      ---@diagnostic disable-next-line: missing-parameter
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        {
          name = "path",
          keyword_length = 0,
          keyword_pattern = ".*?",
          trigger_characters = {},
        },
        -- {
        --   name = "copilot",
        --   -- keyword_length = 0,
        --   max_item_count = 3,
        --   trigger_characters = {
        --     {
        --       ".",
        --       ":",
        --       "(",
        --       "'",
        --       '"',
        --       "[",
        --       ",",
        --       "#",
        --       "*",
        --       "@",
        --       "|",
        --       "=",
        --       "-",
        --       "{",
        --       "/",
        --       "\\",
        --       "+",
        --       "?",
        --       -- " ",
        --       -- "\t",
        --       -- "\n",
        --     },
        --   },
        -- },
        -- { name = "nvim_lsp_signature_help" },
        { name = "emoji" },
      }))

      local copilot_ok, copilot = pcall(require, "copilot.suggestion")

      -- Hide Copilot suggestions when menu is opened
      -- https://github.com/zbirenbaum/copilot.lua#suggestion
      cmp.event:on("menu_opened", function()
        vim.b.copilot_suggestion_hidden = true
      end)

      cmp.event:on("menu_closed", function()
        vim.b.copilot_suggestion_hidden = false
      end)

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = false,
        }),
        -- Don't insert on <C-n> & <C-p>
        ["<C-n>"] = cmp.mapping({
          c = function()
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              vim.api.nvim_feedkeys("<Down>", "n", true)
            end
          end,
          i = function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end,
        }),
        ["<C-p>"] = cmp.mapping({
          c = function()
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            else
              vim.api.nvim_feedkeys("<Up>", "n", true)
            end
          end,
          i = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end,
        }),
        -- Show next Copilot suggestion
        ["<C-l>"] = cmp.mapping(function(fallback)
          if copilot_ok and copilot.is_visible() then
            copilot.next()
          else
            fallback()
          end
        end, { "i" }),
        -- Show prev Copilot suggestion
        ["<C-h>"] = cmp.mapping(function(fallback)
          if copilot_ok and copilot.is_visible() then
            copilot.prev()
          else
            fallback()
          end
        end, { "i" }),
        -- Dismiss Copilot
        ["<C-y>"] = cmp.mapping(function(fallback)
          if copilot_ok and copilot.is_visible() then
            copilot.dismiss()
          else
            fallback()
          end
        end, { "i" }),
        -- Supartab
        ["<Tab>"] = cmp.mapping(function(fallback)
          -- use tab to accept copilot suggestions
          -- https://github.com/zbirenbaum/copilot.lua/issues/91#issuecomment-1345190310
          if copilot_ok and copilot.is_visible() then
            copilot.accept()
          elseif cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    opts = {
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
        debounce = 75,
        keymap = {
          -- Use nvim-cmp
          accept = false,
          next = false,
          prev = false,
          dismiss = false,
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      copilot_node_command = "node", -- Node version must be < 18
      plugin_manager_path = vim.fn.stdpath("data") .. "/lazy",
      server_opts_overrides = {},
    },
  },

  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    -- opts = function()
    --   return {
    --     method = "getCompletionsCycling",
    --     formatters = {
    --       label = require("copilot_cmp.format").format_label_text,
    --       insert_text = require("copilot_cmp.format").format_insert_text,
    --       preview = require("copilot_cmp.format").deindent,
    --     },
    --   }
    -- end,
  },
}
