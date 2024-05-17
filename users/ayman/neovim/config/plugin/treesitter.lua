if vim.g.did_load_treesitter_plugin then
  return
end
vim.g.did_load_treesitter_plugin = true

local configs = require("nvim-treesitter.configs")
vim.g.skip_ts_context_comment_string_module = true

---@diagnostic disable-next-line: missing-fields
configs.setup({
  endwise = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
  highlight = {
    enable = true,
    disable = function(_, buf)
      local max_filesize = 100 * 1024 -- 100 KiB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
  textobjects = {
    move = {
      enable = true,
      goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
      goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
      goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
      goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
    },
  },
})

require("treesitter-context").setup({
  max_lines = 3,
})

require("ts_context_commentstring").setup()

require("nvim-ts-autotag").setup()

require("nvim-treesitter-textobjects")

-- Tree-sitter based folding
-- vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
