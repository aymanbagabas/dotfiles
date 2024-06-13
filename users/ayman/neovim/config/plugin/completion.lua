local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
local cmp = require("cmp")
local defaults = require("cmp.config.default")()
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

---Confirm selection or jump to the next snippet selection.
---@param opts cmp.ConfirmOption
---@return function(callback: function())
local confirmOrJump = function(opts)
  return function(fallback)
    if cmp.visible() then
      if vim.snippet.active({ direction = 1 }) then
        local entry = cmp.get_selected_entry()
        if not entry then
          cmp.select_next_item()
        end
        vim.schedule(function()
          vim.snippet.jump(1)
        end)
      else
        cmp.confirm(opts)
      end
    else
      fallback()
    end
  end
end

local opts = {
  auto_brackets = {}, -- configure any filetype to auto add brackets
  completion = {
    completeopt = "menu,menuone,noinsert,noselect",
    keyword_length = 3,
  },
  preselect = cmp.PreselectMode.None,
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item()
      elseif vim.snippet.active({ direction = 1 }) then
        vim.schedule(function()
          vim.snippet.jump(1)
        end)
      elseif copilot.is_visible() then
        copilot.accept()
        cmp.close()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_prev_item()
      elseif vim.snippet.active({ direction = -1 }) then
        vim.schedule(function()
          vim.snippet.jump(-1)
        end)
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
    ["<C-y>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }, { "i", "c" }),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-k>"] = cmp.mapping(function(fallback)
      if vim.snippet.active({ direction = 1 }) then
        vim.schedule(function()
          vim.snippet.jump(1)
        end)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-j>"] = cmp.mapping(function(fallback)
      if vim.snippet.active({ direction = -1 }) then
        vim.schedule(function()
          vim.snippet.jump(-1)
        end)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping(function()
      -- Dismiss Copilot
      if copilot.is_visible() then
        copilot.dismiss()
      end
      cmp.abort()
    end, { "i" }),
    ["<CR>"] = cmp.mapping(confirmOrJump({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })),
    ["<S-CR>"] = cmp.mapping(confirmOrJump({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    })),
    ["<C-CR>"] = function(fallback)
      cmp.abort()
      fallback()
    end,
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp_signature_help", keyword_length = 2 },
    { name = "nvim_lsp", keyword_length = 2 },
    { name = "copilot", keyword_length = 3 },
    {
      name = "snippets",
      keyword_length = 2,
      priority = 99,
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

-- clangd extensions
table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))

require("cmp").setup(opts)
