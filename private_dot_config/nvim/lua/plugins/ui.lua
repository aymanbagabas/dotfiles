--  onedark.nvim dark colors
-- dark = {
-- 	black = "#181a1f",
-- 	bg0 = "#282c34",
-- 	bg1 = "#31353f",
-- 	bg2 = "#393f4a",
-- 	bg3 = "#3b3f4c",
-- 	bg_d = "#21252b",
-- 	bg_blue = "#73b8f1",
-- 	bg_yellow = "#ebd09c",
-- 	fg = "#abb2bf",
-- 	purple = "#c678dd",
-- 	green = "#98c379",
-- 	orange = "#d19a66",
-- 	blue = "#61afef",
-- 	yellow = "#e5c07b",
-- 	cyan = "#56b6c2",
-- 	red = "#e86671",
-- 	grey = "#5c6370",
-- 	light_grey = "#848b98",
-- 	dark_cyan = "#2b6f77",
-- 	dark_red = "#993939",
-- 	dark_yellow = "#93691d",
-- 	dark_purple = "#8a3fa0",
-- 	diff_add = "#31392b",
-- 	diff_delete = "#382b2c",
-- 	diff_change = "#1c3448",
-- 	diff_text = "#2c5372",
-- },

return {
  {
    "LazyVim/LazyVim",
    opts = {
      icons = {
        diagnostics = {
          Error = "E ",
          Warn = "W ",
          Hint = "H ",
          Info = "I ",
        },
        git = {
          added = "+",
          modified = "~",
          removed = "-",
        },
      },
    },
  },

  {
    "folke/noice.nvim",
    opts = {},
  },

  {
    "rcarriga/nvim-notify",
    opts = {},
  },

  -- {
  --   "j-hui/fidget.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     text = { spinner = "dots_pulse" },
  --   },
  -- },

  {
    "akinsho/bufferline.nvim",
    keys = {
      { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close all to the left" },
      { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close all to the right" },
      {
        "<BSlash>",
        "<cmd>BufferLinePick<CR>",
        desc = "Pick Buffer",
      },
    },
    opts = function(_, opts)
      -- onedark
      -- local colors = require("onedark.colors")
      -- onedarkpro
      -- local color = require("onedarkpro.helpers")
      -- local colors = color.get_preloaded_colors()
      local diffRemoved = string.format("#%06x", vim.api.nvim_get_hl_by_name("DiffRemoved", true).foreground)
      local override = {
        highlights = {
          close_button_selected = {
            fg = diffRemoved,
          },
          buffer_selected = {
            italic = false,
          },
          diagnostic_selected = {
            italic = false,
          },
          hint_selected = {
            italic = false,
          },
          info_selected = {
            italic = false,
          },
          info_diagnostic_selected = {
            italic = false,
          },
          warning_selected = {
            italic = false,
          },
          warning_diagnostic_selected = {
            italic = false,
          },
          error_selected = {
            italic = false,
          },
          error_diagnostic_selected = {
            italic = false,
          },
        },
        options = {
          right_mouse_command = "vertical sbuffer %d",
          middle_mouse_command = "bdelete! %d",
          indicator = {
            icon = "▎", -- this should be omitted if indicator style is not 'icon'
            style = "none", -- 'icon' | 'underline' | 'none',
          },
          separator_style = "thin",
          offsets = {
            {
              filetype = "neo-tree",
              text = "Browser",
              highlight = "Directory",
              text_align = "left",
            },
          },
        },
      }
      return vim.tbl_deep_extend("force", opts, override)
    end,
  },

  {
    "goolord/alpha-nvim",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local header = {
        "  _  _             _        ",
        " | \\| |___ _____ _(_)_ __   ",
        " | .` / -_) _ \\ V / | '  \\  ",
        " |_|\\_\\___\\___/\\_/|_|_|_|_| ",
      }

      dashboard.section.header.val = header
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
        -- use persisted instead of persistence
        dashboard.button("s", "勒" .. " Restore Session", [[:lua require("persisted").load() <cr>]]),
        dashboard.button("l", "鈴" .. " Lazy", ":Lazy<CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local icons = require("lazyvim.config").icons

      local function fg(name)
        return function()
          ---@type {foreground?:number}?
          local hl = vim.api.nvim_get_hl_by_name(name, true)
          return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
        end
      end

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
          -- Disable sections and component separators
          component_separators = "│",
          section_separators = "",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 0, symbols = { modified = "  ", readonly = "", unnamed = "" } },
          },
          lualine_c = {
            { "branch", separator = "" },
            {
              "diff",
              colored = true,
              diff_color = {
                added = fg("LineNr"),
                modified = fg("LineNr"),
                removed = fg("LineNr"),
              },
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              padding = { left = 0, right = 0 },
            },
            -- git line blame
            {
              function()
                local c = vim.b.gitsigns_blame_line_dict
                return require("gitsigns.util").expand_format("<author>, <author_time:%R>", c, false)
              end,
              cond = function()
                return package.loaded["gitsigns"] and vim.b.gitsigns_blame_line ~= nil
              end,
              color = fg("LineNr"),
            },
          },
          lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = fg("LineNr"),
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = fg("Normal"),
            },
            { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
          },
          lualine_y = {
            "encoding",
            "fileformat",
            {
              function()
                return vim.fn.SleuthIndicator()
                -- -- copied from https://github.com/tpope/vim-sleuth/blob/master/plugin/sleuth.vim#L640
                -- local opt = function(name)
                --   return vim.opt[name]:get()
                -- end
                -- local sw = opt("shiftwidth") ~= 0 and opt("shiftwidth") or opt("tabstop")
                -- local ind
                -- if opt("expandtab") then
                --   ind = "s:" .. sw
                -- elseif opt("tabstop") == sw then
                --   ind = "tabs:" .. opt("tabstop")
                -- else
                --   ind = "s:" .. sw .. " t:" .. vim.opt.tabstop
                -- end
                -- if opt("textwidth") ~= 0 then
                --   ind = ind .. " w:" .. opt("textwidth")
                -- end
                -- local feol = opt("fixendofline")
                -- if feol and feol ~= 0 and opt("endofline") ~= 0 then
                --   ind = ind .. " noeol"
                -- end
                -- return ind
              end,
            },
          },
          lualine_z = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
        },
        extensions = {
          "neo-tree",
          "symbols-outline",
          "quickfix",
          "fugitive",
        },
      }
    end,
  },

  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = function()
      return {
        ---whether to attach navic to language servers automatically
        ---@type boolean
        -- use on_attach below
        attach_navic = false,
        -- prevent barbecue from updating itself automatically
        -- use autocmd below
        create_autocmd = false,
        kinds = require("lazyvim.config").icons.kinds,
        exclude_filetypes = {
          "help",
          "startify",
          "dashboard",
          "lazy",
          "neo-tree",
          "neogitstatus",
          "NvimTree",
          "Trouble",
          "alpha",
          "lir",
          "Outline",
          "spectre_panel",
          "toggleterm",
          "DressingSelect",
          "Jaq",
          "harpoon",
          "dap-repl",
          "dap-terminal",
          "dapui_console",
          "dapui_hover",
          "lab",
          "notify",
          "noice",
          "gitcommit",
          "",
        },
      }
    end,
    config = function(_, opts)
      -- setup barbecue
      require("barbecue").setup(opts)
      -- attach navic
      require("lazyvim.util").on_attach(function(client, buffer)
        if client.server_capabilities["documentSymbolProvider"] then
          require("nvim-navic").attach(client, buffer)
        end
      end)
      local events = {
        "BufWinEnter",
        "CursorHold",
        "InsertLeave",
      }
      -- WinResized event was added in nvim-0.9
      if vim.fn.has("nvim-0.9") == 1 then
        ---@diagnostic disable-next-line: missing-parameter
        events = vim.list_extend(events, {
          "WinResized",
        })
      end
      vim.api.nvim_create_autocmd(events, {
        group = vim.api.nvim_create_augroup("barbecue.updater", {}),
        callback = function()
          require("barbecue.ui").update()
        end,
      })
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      char = "▏",
      context_char = "▏",
      space_char_blankline = " ",
      filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
      show_trailing_blankline_indent = false,
      show_current_context = false,
      show_current_context_start = false,
    },
  },

  {
    "echasnovski/mini.indentscope",
    opts = function()
      return {
        draw = {
          -- disable animation
          animation = require("mini.indentscope").gen_animation.none(),
        },
        -- symbol = "│",
        symbol = "▏",
        options = { try_as_border = true },
      }
    end,
  },
}
