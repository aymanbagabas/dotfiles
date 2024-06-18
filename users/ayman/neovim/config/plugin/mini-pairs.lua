require("mini.pairs").setup({
  mappings = {
    ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\`].", register = { cr = false } },
  },
})

vim.keymap.set("n", "<leader>up", function()
  vim.g.minipairs_disable = not vim.g.minipairs_disable
  if vim.g.minipairs_disable then
    vim.notify("Disabled auto pairs", { title = "Option" })
  else
    vim.notify("Enabled auto pairs", { title = "Option" })
  end
end, {
  desc = "Toggle Auto Pairs",
})
