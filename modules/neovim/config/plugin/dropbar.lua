local dropbar_api = require("dropbar.api")

vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })

require("dropbar").setup({
  icons = {
    kinds = {
      -- Use our custom icons
      symbols = require("icons").kinds,
    },
  },
  bar = {
    -- Enable on Oil and Fugitive buffers and exclude certain filetypes
    enable = function(buf, win, _)
      if
        not vim.api.nvim_buf_is_valid(buf)
        or not vim.api.nvim_win_is_valid(win)
        or vim.fn.win_gettype(win) ~= ""
        or vim.wo[win].winbar ~= ""
      then
        return false
      end

      local exclude_list = require("exclude_list")
      for _, excluded in ipairs(exclude_list) do
        if vim.bo[buf].ft == excluded then
          return false
        end
      end

      local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
      if stat and stat.size > 1024 * 1024 then
        return false
      end

      return vim.bo[buf].ft == "markdown"
        or vim.bo[buf].ft == "oil" -- enable in oil buffers
        or vim.bo[buf].ft == "fugitive" -- enable in fugitive buffers
        or pcall(vim.treesitter.get_parser, buf)
        or not vim.tbl_isempty(vim.lsp.get_clients({
          bufnr = buf,
          method = "textDocument/documentSymbol",
        }))
    end,
    sources = function(buf, _)
      local sources = require("dropbar.sources")
      local utils = require("dropbar.utils")
      if vim.bo[buf].ft == "markdown" then
        return {
          sources.path,
          sources.markdown,
        }
      end
      if vim.bo[buf].buftype == "terminal" then
        return {
          sources.terminal,
        }
      end
      return {
        sources.path,
        utils.source.fallback({
          -- Prefer treesitter over LSP
          sources.treesitter,
          sources.lsp,
        }),
      }
    end,
  },
  sources = {
    path = {
      relative_to = function(buf, win)
        -- Show full path in oil or fugitive buffers
        local bufname = vim.api.nvim_buf_get_name(buf)
        if vim.startswith(bufname, "oil://") or vim.startswith(bufname, "fugitive://") then
          local root = bufname:gsub("^%S+://", "", 1)
          while root and root ~= vim.fs.dirname(root) do
            root = vim.fs.dirname(root)
          end
          return root
        end

        local ok, cwd = pcall(vim.fn.getcwd, win)
        return ok and cwd or vim.fn.getcwd()
      end,
    },
  },
})
