local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
local cmp = require("cmp")
local defaults = require("cmp.config.default")()
local luasnip = require("luasnip")
local copilot = require("copilot.suggestion")

require("copilot_cmp").setup()

-- Hide Copilot suggestions when menu is opened
-- https://github.com/zbirenbaum/copilot.lua#suggestion
cmp.event:on("menu_opened", function()
  vim.b.copilot_suggestion_hidden = true
end)

cmp.event:on("menu_closed", function()
  vim.b.copilot_suggestion_hidden = false
end)

local opts = {
  completion = {
    completeopt = "menu,menuone,noinsert",
    keyword_length = 3,
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      elseif luasnip.expand_or_jumpable() then
        -- TODO: use vim.snippet in nvim-0.10
        luasnip.expand_or_jump()
      elseif copilot.is_visible() then
        copilot.accept()
        cmp.close()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

    -- Show next Copilot suggestion
    ["<C-l>"] = cmp.mapping(function(fallback)
      if copilot.is_visible() then
        copilot.next()
      else
        fallback()
      end
    end, { "i" }),
    -- Show prev Copilot suggestion
    ["<C-h>"] = cmp.mapping(function(fallback)
      if copilot.is_visible() then
        copilot.prev()
      else
        fallback()
      end
    end, { "i" }),
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping(function()
      -- Dismiss Copilot
      if copilot.is_visible() then
        copilot.dismiss()
      end
      cmp.abort()
    end, { "i" }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<S-CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<C-CR>"] = function(fallback)
      cmp.abort()
      fallback()
    end,
  }),
  sources = cmp.config.sources({
    { name = "copilot", keyword_length = 3 },
    --{ name = 'nvim_lsp_signature_help', keyword_length = 3 },
    { name = "nvim_lsp", keyword_length = 3 },
    {
      name = "luasnip",
      keyword_length = 2,
      priority = 50,
    },
    { name = "path" },
  }, {
    { name = "buffer", keyword_length = 5 },
  }, {
    { name = "emoji", priority = 999 },
  }),
  formatting = {
    format = function(_, item)
      local icons = require("icons").kinds
      if icons[item.kind] then
        item.kind = icons[item.kind] .. item.kind
      end
      return item
    end,
  },
  experimental = {
    ghost_text = {
      hl_group = "CmpGhostText",
    },
  },
  sorting = defaults.sorting,
}

for _, source in ipairs(opts.sources) do
  source.group_index = source.group_index or 1
end

require("cmp").setup(opts)
