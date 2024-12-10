-- Link CmpGhostText to Comment
vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

local cmp = require("cmp")
local defaults = require("cmp.config.default")()
local suggestion = require("copilot.suggestion")

local opts = {
  enabled = function()
    -- disable completion in comments
    local context = require("cmp.config.context")
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == "c" then
      return true
    else
      return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
    end
  end,
  performance = {
    debounce = 120,
  },
  auto_brackets = {}, -- configure any filetype to auto add brackets
  completion = {
    completeopt = "menu,menuone,noinsert,noselect",
    keyword_length = 3,
  },
  preselect = cmp.PreselectMode.Item,
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping(function(fallback)
      if vim.snippet.active({ direction = 1 }) then
        vim.schedule(function()
          vim.snippet.jump(1)
        end)
      elseif suggestion.is_visible() and cmp.visible() then
        cmp.close()
      elseif suggestion.is_visible() then
        -- Ignore TextChanged events to prevent triggering
        -- completion again after accepting a suggestion
        local origin = vim.o.eventignore
        vim.o.eventignore = "TextChangedI,TextChangedP"
        suggestion.accept()
        vim.defer_fn(function()
          vim.o.eventignore = origin
        end, 10)
        -- vim.schedule(function()
        --   -- We need to schedule this to close the completion menu after accepting the suggestion
        --   cmp.abort()
        -- end)
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if vim.snippet.active({ direction = -1 }) then
        vim.schedule(function()
          vim.snippet.jump(-1)
        end)
      else
        fallback()
      end
    end, { "i", "s" }),

    -- Show next Copilot suggestion
    ["<C-k>"] = cmp.mapping(function()
      suggestion.next()
    end, { "i" }),

    -- Show prev Copilot suggestion
    ["<C-j>"] = cmp.mapping(function()
      suggestion.prev()
    end, { "i" }),

    -- Accept next word
    ["<C-l>"] = cmp.mapping(function(fallback)
      if suggestion.is_visible() then
        suggestion.accept_word()
      else
        fallback()
      end
    end, { "i" }),

    -- Accept line
    ["<C-S-l>"] = cmp.mapping(function(fallback)
      if suggestion.is_visible() then
        suggestion.accept_line()
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
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping(function()
      -- Dismiss Copilot
      suggestion.dismiss()
      cmp.abort()
    end, { "i" }),
    ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert }),
    ["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp_signature_help", keyword_length = 1 },
    { name = "nvim_lsp", keyword_length = 1 },
    -- { name = "copilot", keyword_length = 3 },
    {
      name = "snippets",
      keyword_length = 2,
      priority = 99,
    },
    { name = "path" },
  }, {
    { name = "buffer", keyword_length = 3 },
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
    ghost_text = false, -- { hl_group = "CmpGhostText" },
  },
  sorting = defaults.sorting,
}

for _, source in ipairs(opts.sources) do
  source.group_index = source.group_index or 1
end

-- clangd extensions
table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))

cmp.setup(opts)
