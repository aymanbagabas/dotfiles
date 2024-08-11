local diffDeleted = vim.api.nvim_get_hl(0, { name = "DiffDeleted" })
local opts = {
  highlights = {
    close_button_selected = {
      fg = diffDeleted.fg,
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
    always_show_bufferline = false,
    diagnostics = "nvim_lsp",
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
        text = "Files",
        highlight = "Directory",
        text_align = "left",
      },
    },
  },
}

require("bufferline").setup(opts)

-- Fix bufferline when restoring a session
vim.api.nvim_create_autocmd("BufAdd", {
  callback = function()
    vim.schedule(function()
      pcall(nvim_bufferline)
    end)
  end,
})

vim.keymap.set("n", "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", { desc = "Close all to the left" })
vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseRight<cr>", { desc = "Close all to the right" })
vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOther<cr>", { desc = "Close all other" })
vim.keymap.set("n", "<BSlash>", "<cmd>BufferLinePick<CR>", { desc = "Pick Buffer" })
