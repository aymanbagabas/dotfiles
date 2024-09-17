require("conform").setup({
  formatters_by_ft = {
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    json = { "jq" },
    lua = { "stylua" },
    markdown = { "prettier" },
    nix = { "nixpkgs_fmt" },
    rust = { "rustfmt" },
    sh = { "shfmt" },
    sql = { "pg_format", "sql_formatter" },
    tf = { "terraform_fmt" },
    typescript = { "prettier" },
    yaml = { "prettier" },
    zig = { "zigfmt" },
    ["_"] = { "trim_whitespace", "trim_newlines" },
  },
  format_on_save = function(bufnr)
    if not vim.g.autoformat and not vim.b[bufnr].autoformat then
      return
    end
    return { lsp_fallback = true, timeout_ms = 500 }
  end,
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set("n", "<leader>uF", function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify("Auto Format (Global): " .. (vim.g.autoformat and "enabled" or "disabled"))
end, { desc = "Toggle Auto Format (Global)" })
vim.keymap.set("n", "<leader>uf", function(bufnr)
  vim.b[bufnr].autoformat = not vim.b[bufnr].autoformat
  vim.notify("Auto Format (Buffer): " .. (vim.b[bufnr].autoformat and "enabled" or "disabled"))
end, { desc = "Toggle Auto Format (Buffer)" })
