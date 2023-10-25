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
    "nvim-tree/nvim-web-devicons",
  },

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
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function()
      local logo = {
        "  _  _             _        ",
        " | \\| |___ _____ _(_)_ __   ",
        " | .` / -_) _ \\ V / | '  \\  ",
        " |_|\\_\\___\\___/\\_/|_|_|_|_| ",
        "",
        "",
      }

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = logo,
        -- stylua: ignore
        center = {
          { action = "Telescope find_files",              desc = " Find file",       icon = " ", key = "f" },
          { action = "ene | startinsert",                 desc = " New file",        icon = " ", key = "n" },
          { action = "Telescope oldfiles",                desc = " Recent files",    icon = " ", key = "r" },
          { action = "Telescope live_grep",               desc = " Find text",       icon = " ", key = "g" },
          { action = "e $MYVIMRC",                        desc = " Config",          icon = " ", key = "c" },
          { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
          { action = "LazyExtras",                        desc = " Lazy Extras",     icon = " ", key = "e" },
          { action = "Lazy",                              desc = " Lazy",            icon = "󰒲 ", key = "l" },
          { action = "qa",                                desc = " Quit",            icon = " ", key = "q" },
        },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      return opts
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
            { "filename", path = 0, symbols = { modified = " ± ", readonly = "", unnamed = "" } },
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
            { "fileformat", icons_enabled = false },
            function()
              -- return vim.fn.SleuthIndicator()
              -- copied from https://github.com/tpope/vim-sleuth/blob/master/plugin/sleuth.vim#L640
              local opt = function(name)
                return vim.opt[name]:get()
              end
              local ts = opt("tabstop")
              local sw = opt("shiftwidth")
              if sw == 0 then
                sw = ts
              end
              local ind
              if opt("expandtab") then
                ind = "spaces " .. sw
              elseif ts == sw then
                ind = "tabs " .. ts
              else
                ind = "spaces " .. sw .. " │ tabs " .. ts
              end
              local tw = opt("textwidth")
              if tw ~= 0 then
                ind = ind .. " │ textwidth " .. tw
              end
              if vim.fn.exists("&fixendofline") == 1 and not opt("fixendofline") and not opt("endofline") then
                ind = ind .. " │ noeol"
              end
              return ind
            end,
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
        exclude_filetypes = vim.g.exclude_filetypes,
      }
    end,
    config = function(_, opts)
      -- setup barbecue
      require("barbecue").setup(opts)
      -- attach navic
      require("lazyvim.util").lsp.on_attach(function(client, buffer)
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
      indent = {
        char = "▏",
        tab_char = "▏",
      },
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
      }
    end,
  },

  {
    "folke/zen-mode.nvim",
    opts = {
      plugins = {
        gitsigns = { enabled = true },
      },
    },
    keys = {
      {
        "<leader>uZ",
        "<cmd>ZenMode<cr>",
        desc = "Toggle Zen Mode",
        mode = { "n" },
      },
    },
  },

  {
    "folke/twilight.nvim",
    keys = {
      {
        "<leader>uD",
        "<cmd>Twilight<cr>",
        desc = "Toggle Dimming",
        mode = { "n" },
      },
    },
  },
}
