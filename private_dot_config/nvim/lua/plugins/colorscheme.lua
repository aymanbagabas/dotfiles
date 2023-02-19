return {
  -- add onedark
  {
    "aymanbagabas/onedark.nvim",
    -- dir = "~/Workspace/onedark.nvim",
    priority = 1000, -- Ensure it loads first
    lazy = true,
    config = function()
      require("onedark").setup({
        transparent = false,
        style = "dark",
        lualine = {
          transparent = true,
        },
      })
    end,
  },

  -- {
  --   "olimorris/onedarkpro.nvim",
  --   priority = 1000, -- Ensure it loads first
  --   opts = {
  --     colors = {},
  --     options = {
  --       transparency = false,
  --       cursorline = true,
  --     },
  --   },
  -- },

  {
    "RRethy/nvim-base16",
    -- lazy = true,
  },

  {
    "NvChad/base46",
    config = function()
      local ok, base46 = pcall(require, "base46")

      if ok then
        base46.load_theme()
      end
    end,
    -- lazy = true,
  },

  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    config = true,
  },

  -- Configure LazyVim to load onedark
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}

-- {
--   primary = {
--     background = "#171717";
--     foreground = "#C5C8C6";
--   };
--
--   normal = {
--     black = "#282a2e";
--     blue = "#8056FF";
--     cyan = "#04D7D7";
--     green = "#31BB71";
--     magenta = "#ED61D7";
--     red = "#D74E6F";
--     yellow = "#D3E561";
--     white = "#C5C8C6";
--   };
--
--   bright = {
--     black = "#4B4B4B";
--     red = "#FE5F86";
--     green = "#00D787";
--     blue = "#8F69FF";
--     yellow = "#EBFF71";
--     magenta = "#FF7AEA";
--     cyan = "#00FEFE";
--     white = "#FFFFFF";
--   };
-- }
