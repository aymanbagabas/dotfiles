require("luasnip").setup({
  -- see: https://github.com/L3MON4D3/LuaSnip/issues/525
  region_check_events = "InsertEnter",
  delete_check_events = "InsertLeave",
})

require("luasnip.loaders.from_vscode").lazy_load()
