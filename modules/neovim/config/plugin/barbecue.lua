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

-- setup barbecue
require("barbecue").setup({
  ---whether to attach navic to language servers automatically
  ---@type boolean
  -- use on_attach below
  attach_navic = false, -- we do that manually on lsp on_attach
  -- prevent barbecue from updating itself automatically
  -- use autocmd above
  create_autocmd = false,
  kinds = require("icons").kinds,
  exclude_filetypes = vim.g.exclude_filetypes,
})

