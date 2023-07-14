return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        -- hijack_netrw_behavior = "open_default",
        hijack_netrw_behavior = "disabled",
        follow_current_file = true,
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    keys = {},
  },

  {
    "RRethy/vim-illuminate",
    opts = {
      filetypes_denylist = vim.g.exclude_filetypes,
    },
  },

  {
    "ggandor/flit.nvim",
    enabled = false,
  },

  {
    "ggandor/leap.nvim",
    enabled = false,
  },

  {
    "folke/flash.nvim",
    enabled = false,
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      return vim.tbl_extend("force", opts, {
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
        },
        current_line_blame_formatter = "    <author>, <author_time:%R> - <summary> ",
      })
    end,
  },

  {
    "tpope/vim-fugitive",
    keys = {
      {
        "<leader>go",
        "<cmd>GBrowse!<cr>",
        desc = "Copy Project URL",
        mode = { "n" },
      },
      {
        "<leader>gO",
        "<cmd>GBrowse<cr>",
        desc = "Open Project URL",
        mode = { "n" },
      },

      {
        "<leader>gb",
        "<cmd>.GBrowse!<cr>",
        desc = "Copy Line URL",
        mode = { "n", "x" },
      },
      {
        "<leader>gB",
        "<cmd>.GBrowse<cr>",
        desc = "Open Line URL",
        mode = { "n", "x" },
      },

      {
        "<leader>gS",
        "<cmd>G<cr>",
        desc = "Git Status",
        mode = { "n", "x" },
      },
    },
    cmd = {
      "G",
      "Gcd",
      "Glcd",
      "Gedit",
      "Gsplit",
      "Gvsplit",
      "Gtabedit",
      "Gpedit",
      "Gdrop",
      "Gread",
      "Gwrite",
      "Gwq",
      "Gdiffsplit",
      "Gvdiffsplit",
      "Ghdiffsplit",
      "GMove",
      "GRename",
      "GDelete",
      "GRemove",
      "GUnlink",
      "GBrowse",
    },
    dependencies = {
      -- GitHub
      "tpope/vim-rhubarb",
      -- GitLab
      "shumphrey/fugitive-gitlab.vim",
      -- Bitbucket
      "tommcdo/vim-fubitive",
      -- SourceHut
      "https://git.sr.ht/~willdurand/srht.vim",
    },
    config = function()
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
      end, {
        nargs = 1,
        desc = "Open",
      })
    end,
  },

  -- complementary pairs of mappings
  {
    "tpope/vim-unimpaired",
  },

  {
    -- use CTRL-A/CTRL-X to increment dates, times, and more
    "tpope/vim-speeddating",
    event = "BufEnter",
  },

  -- easily search for, substitute, and abbreviate multiple variants of a word
  -- Want to turn fooBar into foo_bar? Press crs (coerce to snake_case). MixedCase (crm), camelCase (crc), snake_case (crs), UPPER_CASE (cru), dash-case (cr-), dot.case (cr.), space case (cr<space>), and Title Case (crt) are all just 3 keystrokes away.
  -- :%Subvert/facilit{y,ies}/building{,s}/g
  -- You can abbreviate it as :S, and it accepts the full range of flags including things like c (confirm).
  { "tpope/vim-abolish", event = "BufEnter" },

  -- Heuristically set buffer options
  -- disabled in favor of `nmac427/guess-indent.nvim`
  {
    "tpope/vim-sleuth",
    name = "sleuth",
  },

  {
    "alexghergh/nvim-tmux-navigation",
    branch = "main",
    event = { "VimEnter" },
    keys = function()
      local ok, nav = pcall(require, "nvim-tmux-navigation")
      if not ok then
        return
      end
      return {
        {
          "<M-h>",
          nav.NvimTmuxNavigateLeft,
          desc = "Navigate Left",
        },
        { "<M-j>", nav.NvimTmuxNavigateDown, desc = "Navigate Down" },
        { "<M-k>", nav.NvimTmuxNavigateUp, desc = "Navigate Up" },
        { "<M-l>", nav.NvimTmuxNavigateRight, desc = "Navigate Right" },
        {
          "<M-\\>",
          nav.NvimTmuxNavigateLastActive,
          desc = "Navigate Last Active",
        },
        {
          "<M-Space>",
          nav.NvimTmuxNavigateNext,
          desc = "Navigate Next",
        },
      }
    end,
    opts = {
      disable_when_zoomed = true, -- defaults to false
    },
  },

  {
    -- Maintained fork of the fastest Neovim colorizer
    "NvChad/nvim-colorizer.lua",
    opts = {
      filetypes = {
        "*",
        html = {
          mode = "foreground",
        },
        css = {
          css = true,
          css_fn = true,
        },
      },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue or blue
        RRGGBBAA = false, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = false, -- CSS rgb() and rgba() functions
        hsl_fn = false, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "background", -- Set the display mode.
        -- Available methods are false / true / "normal" / "lsp" / "both"
        -- True is same as normal
        tailwind = false, -- Enable tailwind colors
        -- parsers can contain values used in |user_default_options|
        sass = { enable = false, parsers = { css } }, -- Enable sass colors
        virtualtext = "■",
      },
      -- all the sub-options of filetypes apply to buftypes
      buftypes = {},
    },
  },

  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>uu", ":UndotreeToggle<cr>", desc = "Toggle Undo Tree" },
    },
  },

  {
    "ojroques/nvim-osc52",
    -- Only load this plugin when we're in a remote session and not in a tmux session
    cond = function()
      return vim.env.SSH_CONNECTION ~= nil and vim.env.SSH_CONNECTION ~= "" and vim.env.TMUX == nil
    end,
    opts = {
      silent = true,
    },
    config = function(_, opts)
      local osc52 = require("osc52")
      osc52.setup(opts)

      local function copy(lines, _)
        osc52.copy(table.concat(lines, "\n"))
      end

      local function paste()
        return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
      end

      vim.g.clipboard = {
        name = "osc52",
        copy = { ["+"] = copy, ["*"] = copy },
        paste = { ["+"] = paste, ["*"] = paste },
      }
    end,
  },
}
