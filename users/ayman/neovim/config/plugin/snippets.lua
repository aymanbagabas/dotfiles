-- nvim-snippets
-- this needs to be set before cmp.setup()

local rtps = vim.api.nvim_list_runtime_paths()
local snippets_path = ""
for _, path in ipairs(rtps) do
  if string.match(path, "friendly.snippets") then
    snippets_path = path .. "/snippets"
  end
end

require("snippets").setup({
  create_cmp_source = true,
  friendly_snippets = true,
  global_snippets = { "all", "global" },
  search_paths = {
    snippets_path,
  },
})
