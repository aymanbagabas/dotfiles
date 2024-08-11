local navic = require("nvim-navic")
navic.setup({})

local function fg(name)
  return function()
    ---@type {foreground?:number}?
    local hl = vim.api.nvim_get_hl(0, { name = name })
    return hl and hl.fg and { fg = string.format("#%06x", hl.fg) }
  end
end

local icons = require("icons")

require("lualine").setup({
  options = {
    theme = "auto",
    globalstatus = true,
    disabled_filetypes = { statusline = { "dashboard", "alpha" } },
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
          added = fg("DiffAdded"),
          modified = fg("DiffChanged"),
          removed = fg("DiffDeleted"),
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
    "fzf",
    "toggleterm",
  },
})
