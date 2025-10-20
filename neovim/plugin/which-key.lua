local opts = {
  plugins = { spelling = true },
  spec = {
    {
      mode = { "n", "v" },

      { "<leader><tab>", group = "tabs" },
      { "<leader>c", group = "code" },
      { "<leader>f", group = "file/find" },
      { "<leader>g", group = "git" },
      { "<leader>gh", group = "hunks" },
      { "<leader>q", group = "quit/session" },
      { "<leader>s", group = "search" },
      { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
      { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
      { "[", group = "prev" },
      { "]", group = "next" },
      { "g", group = "goto" },
      { "gs", group = "surround" },
      { "z", group = "fold" },
      {
        "<leader>b",
        group = "buffer",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
      {
        "<leader>w",
        group = "windows",
        proxy = "<c-w>",
        expand = function()
          return require("which-key.extras").expand.win()
        end,
      },
      -- better descriptions
      { "gx", desc = "Open with system app" },

      { "<leader>l", group = "lsp" },
    },
  },
}

local wk = require("which-key")
wk.setup(opts)

vim.keymap.set("n", "<leader>?", function()
  wk.show({ global = false })
end, { noremap = true, silent = true, desc = "Buffer Keymaps (which-key)" })

vim.keymap.set("n", "<c-w><space>", function()
  wk.show({ keys = "<c-w>", loop = true })
end, { noremap = true, silent = true, desc = "Window Hydra Mode (which-key)" })
