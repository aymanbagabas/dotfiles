-- LSP
-- set log level
vim.lsp.set_log_level("error")

-- Diagnostic Format
--
-- show diagnostic message, source and code
---@param diagnostic table Diabnostic object |diagnostic-structure|
local diagnostic_format = function(diagnostic)
  local msg = string.format("%s %s", diagnostic.message, diagnostic.source)
  if diagnostic.code then
    msg = string.format("%s (%s)", msg, diagnostic.code)
  end
  return msg
end

-- Organize imports.
--
-- https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-902680058
--
---@param client table Client object
---@param bufnr number Buffer number
---@param timeoutms number timeout in ms
local organize_imports = function(client, bufnr, timeoutms)
  local params = vim.lsp.util.make_range_params(nil, client.offset_encoding)
  params.context = { only = { "source.organizeImports" } }
  ---@diagnostic disable-next-line: param-type-mismatch
  local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, timeoutms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
      else
        -- ignore output
        pcall(vim.lsp.buf.execute_command, r.command)
      end
    end
  end
end

--- Checks if the given client is alive.
--
---@param client table Client object
---@return boolean
local is_alive = function(client)
  if client == nil then
    return false
  end
  if not client.initialized then
    return false
  end
  if client.is_stopped() then
    return false
  end
  return true
end

local organize_group = vim.api.nvim_create_augroup("LspOrganize", { clear = true })
local codelens_group = vim.api.nvim_create_augroup("LspCodeLens", { clear = true })
require("lazyvim.util").on_attach(function(client, buffer)
  -- Attach organize imports to lsp
  -- If the organizeImports codeAction runs for lua files, depending on
  -- where the cursor is, it'll reorder the args and break stuff.
  -- This took me way too long to figure out.
  if client.server_capabilities.codeActionProvider and vim.bo.filetype ~= "lua" and client.name ~= "null-ls" then
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      buffer = buffer,
      callback = function()
        organize_imports(client, buffer, 1500)
      end,
      group = organize_group,
    })
  end

  -- Attach codelens to lsp
  -- Refresh & clear autocmds
  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      buffer = bufnr,
      callback = function()
        if is_alive(client) then
          vim.lsp.codelens.refresh()
        end
      end,
      group = codelens_group,
    })

    vim.api.nvim_create_autocmd("LspDetach", {
      buffer = bufnr,
      callback = function()
        if is_alive(client) then
          -- This function was only added in nvim-0.9
          -- vim.lsp.codelens.clear()
          pcall(vim.lsp.codelens.clear)
        end
      end,
      group = codelens_group,
    })
  end
end)

return {
  {
    "neovim/nvim-lspconfig",
    -- The syntax for adding, deleting and changing LSP Keymaps, is the same as for plugin
    -- keymaps, but you need to configure it using the init() method.
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<leader>ci", "<cmd>LspInfo<cr>", desc = "Lsp Info" }
      keys[#keys + 1] = { "<leader>cl", vim.lsp.codelens.run, desc = "CodeLens" }
      keys[#keys + 1] = { "<leader>xl", vim.diagnostic.setloclist, desc = "Location List" }
      keys[#keys + 1] = { "<leader>xq", vim.diagnostic.setqflist, desc = "Quickfix List" }
      -- Populate diagnostics before opening trouble
      keys[#keys + 1] = {
        "<leader>xL",
        function()
          local ok, trouble = pcall(require, "trouble")
          if not ok then
            return
          end
          vim.diagnostic.setloclist({ open = false })
          trouble.toggle({ "loclist" })
        end,
        desc = "Location List (Trouble)",
      }
      keys[#keys + 1] = {
        "<leader>xQ",
        function()
          local ok, trouble = pcall(require, "trouble")
          if not ok then
            return
          end
          vim.diagnostic.setqflist({ open = false })
          trouble.toggle({ "quickfix" })
        end,
        desc = "Quickfix List (Trouble)",
      }
    end,
    dependencies = {
      {
        "simrat39/inlay-hints.nvim",
        config = function()
          require("inlay-hints").setup({
            renderer = "inlay-hints/render/eol",
            -- https://github.com/simrat39/inlay-hints.nvim/issues/3
            only_current_line = true,
            eol = {
              parameter = {
                format = function(hints)
                  return string.format(" <- (%s)", hints):gsub(":", "")
                end,
              },
              type = {
                format = function(hints)
                  return string.format(" » (%s)", hints):gsub(":", "")
                end,
              },
            },
          })
          require("lazyvim.util").on_attach(function(client, buffer)
            if client.server_capabilities.inlayHintProvider then
              require("inlay-hints").on_attach(client, buffer)
            end
          end)
        end,
      },
    },
    opts = {
      diagnostics = {
        virtual_text = {},
        float = {
          header = "",
          prefix = "",
          format = function(diagnostic)
            local msg = diagnostic.message
            if diagnostic.code then
              msg = string.format("%s (%s)", msg, diagnostic.code)
            end
            return msg
          end,
          style = "minimal",
          border = "rounded",
          source = "always",
        },
      },
      servers = {
        -- Markdown
        grammarly = {},
        ltex = {
          filetypes = { "markdown", "text", "pandoc" },
          flags = { debounce_text_changes = 300 },
        },
        -- Web
        html = {},
        cssls = {},
        jsonls = {},
        -- Docker
        dockerls = {},
        -- YAML
        yamlls = {},
        -- Bash/Shell
        bashls = {
          filetypes = { "sh", "zsh", "bash" },
        },
        -- Terraform
        terraformls = {},
        -- Python
        jedi_language_server = {},
        -- Java
        jdtls = {},
        -- Rust
        rust_analyzer = {},
        -- Go
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = false,
                staticcheck = true,
                unusedparams = true,
              },
              codelenses = {
                run_govulncheck = true,
              },
            },
            gofumpt = false,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
          flags = {
            debounce_text_changes = 150,
          },
        },
      },
      setup = {
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      ---@diagnostic disable-next-line: missing-parameter
      vim.list_extend(opts.ensure_installed, {
        -- markdown
        "ltex-ls",
        -- lua stuff
        "lua-language-server",
        "stylua",
        -- web dev stuff
        "css-lsp",
        "html-lsp",
        "typescript-language-server",
        -- yaml
        "yaml-language-server",
        -- golang
        "gopls",
        "delve",
        "gomodifytags",
        "goimports",
        "staticcheck",
        "golangci-lint",
        "revive",
        "gotests",
        -- shell
        "shfmt",
        "shellcheck",
        -- Github Action
        "actionlint",
        -- Dockerfile
        "dockerfile-language-server",
        -- Terraform
        "terraform-ls",
      })
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      ---@diagnostic disable-next-line: missing-parameter
      vim.list_extend(opts.sources, {
        -- Go
        nls.builtins.code_actions.gomodifytags,
        nls.builtins.diagnostics.golangci_lint,
        -- Shell
        nls.builtins.code_actions.shellcheck,
        -- GitHub Action
        nls.builtins.diagnostics.actionlint,
      })
    end,
  },
}
