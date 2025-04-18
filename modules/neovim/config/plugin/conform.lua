require("conform").setup({
  formatters_by_ft = {
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    json = { "jq" },
    lua = { "stylua" },
    markdown = { "prettier" },
    nix = { "nixpkgs_fmt" },
    sh = { "shfmt" },
    sql = { "pg_format", "sql_formatter" },
    tf = { "terraform_fmt" },
    typescript = { "prettier" },
    yaml = { "prettier" },
    ["_"] = { "trim_whitespace", "trim_newlines" },
  },
  format_on_save = function(bufnr)
    if not vim.g.autoformat or vim.b.autoformat == false then
      return
    end
    -- Run LSP formatter if we only have whitespace and newline formatters.
    local lsp_format = "last"
    local formatters = require("conform").list_formatters(bufnr)
    for _, f in ipairs(formatters) do
      if f.name ~= "trim_whitespace" and f.name ~= "trim_newlines" then
        lsp_format = "fallback"
        break
      end
    end
    return { lsp_format = lsp_format, timeout_ms = 500 }
  end,
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set("n", "<leader>uF", function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify("Auto Format (Global): " .. (vim.g.autoformat and "enabled" or "disabled"))
end, { desc = "Toggle Auto Format (Global)" })
vim.keymap.set("n", "<leader>uf", function()
  -- Toggle autoformat for the current buffer
  -- Treat nil as true
  vim.b.autoformat = not (vim.b.autoformat == nil or vim.b.autoformat)
  vim.notify("Auto Format (Buffer): " .. (vim.b.autoformat and "enabled" or "disabled"))
end, { desc = "Toggle Auto Format (Buffer)" })
