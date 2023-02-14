return {
  -- add onedark
  {
    "aymanbagabas/onedark.nvim",
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
