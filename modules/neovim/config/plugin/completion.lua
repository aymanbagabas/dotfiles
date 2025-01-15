local suggestion = require("copilot.suggestion")

require("blink.cmp").setup({
  keymap = {
    preset = "enter",
    ["<C-y>"] = { "select_and_accept" },
    ["<C-e>"] = {
      function(cmp)
        suggestion.dismiss() -- Dismiss copilot suggestions
        return cmp.cancel()
      end,
      "fallback",
    },
    ["<Tab>"] = {
      "snippet_forward",
      function(cmp)
        if suggestion.is_visible() then
          return cmp.hide()
        end
      end,
      "fallback",
    },
  },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = "mono",
    kind_icons = require("icons").kinds,
  },
  signature = { enabled = true },
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "emoji" },
    cmdline = {},
    providers = {
      lsp = {
        min_keyword_length = function(ctx)
          -- Always show this provider when trigger is manual
          -- i.e. <C-space> is pressed.
          return ctx.trigger.kind == "manual" and 0 or 1
        end,
        score_offset = 0,
      },
      path = {
        min_keyword_length = 0,
      },
      snippets = {
        min_keyword_length = 2,
      },
      buffer = {
        min_keyword_length = 5,
        max_items = 5,
      },
      emoji = {
        module = "blink-emoji",
        name = "Emoji",
        score_offset = 15, -- Tune by preference
        opts = { insert = true }, -- Insert emoji (default) or complete its name
      },
    },
  },
  completion = {
    accept = { auto_brackets = { enabled = true } },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 250,
      treesitter_highlighting = true,
    },

    menu = {
      draw = {
        columns = {
          { "kind_icon", "label", gap = 1 },
          { "kind" },
        },
      },
    },
  },
})
