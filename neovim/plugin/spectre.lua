require('spectre').setup({
  open_cmd = "noswapfile vnew",
  replace_engine = {
    sed = {
      warn = false,
    },
  },
})

vim.keymap.set('n', "<leader>sr", function() require("spectre").open() end, { desc = "Replace in files (Spectre)" })
