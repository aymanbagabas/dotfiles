-- nvim-snippets
-- this needs to be set before cmp.setup()

require("snippets").setup({
  create_cmp_source = false,
  friendly_snippets = true,
  global_snippets = { "all", "global" },
})
