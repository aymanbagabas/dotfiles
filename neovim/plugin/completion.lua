local suggestion = require("copilot.suggestion")

require("blink.cmp").setup({
  keymap = {
    preset = "enter",
    ["<C-p>"] = { "insert_prev", "fallback_to_mappings" },
    ["<C-n>"] = { "insert_next", "fallback_to_mappings" },
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
  signature = { enabled = false },
  cmdline = { enabled = false },
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "emoji" },
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
    list = {
      selection = {
        preselect = true,
        auto_insert = false,
      },
    },

    keyword = {
      range = "full",
    },

    trigger = {
      show_on_insert_on_trigger_character = true,
      show_on_trigger_character = true,
      show_on_keyword = true,
    },

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
