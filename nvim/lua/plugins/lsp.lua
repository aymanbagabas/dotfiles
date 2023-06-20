-- LSP
-- set log level
vim.lsp.set_log_level("error")

local logger = require("plenary.log").new({
  plugin = "lsp",
  level = "error",
})

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
  -- Ignore null-ls
  if client.name == "null-ls" then
    return
  end

  -- Attach organize imports to lsp
  -- If the organizeImports codeAction runs for lua files, depending on
  -- where the cursor is, it'll reorder the args and break stuff.
  -- This took me way too long to figure out.
  if client.supports_method("textDocument/codeAction") and vim.bo.filetype ~= "lua" then
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
  if client.supports_method("textDocument/codeLens") then
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      buffer = buffer,
      callback = function()
        if is_alive(client) then
          vim.lsp.codelens.refresh()
        end
      end,
      group = codelens_group,
    })

    vim.api.nvim_create_autocmd("LspDetach", {
      buffer = buffer,
      callback = function()
        if is_alive(client) then
          -- This function was only added in nvim-0.9
          vim.lsp.codelens.clear()
          -- pcall(vim.lsp.codelens.clear)
        end
      end,
      group = codelens_group,
    })
  end

  -- Add workspace/didChangeWatchedFiles notification capability
  -- if vim.fn.has("nvim-0.9") then
  --   if not client.server_capabilities.workspace then
  --     client.server_capabilities.workspace = {}
  --   end
  --   if not client.server_capabilities.workspace.didChangeWatchedFiles then
  --     client.server_capabilities.workspace.didChangeWatchedFiles = {
  --       dynamicRegistration = true,
  --     }
  --   end
  -- end
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
      keys[#keys + 1] = { "<leader>cR", "<cmd>echo 'Restarting LSP...'<cr><cmd>LspRestart<cr>", desc = "Restart LSP" }
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
    opts = {
      diagnostics = {
        virtual_text = false,
        float = {
          header = "",
          prefix = "",
          format = function(diagnostic)
            local msg = diagnostic.message
            if diagnostic.code then
              -- NVim 0.9 adds the code to the end of the message
              if not vim.fn.has("nvim-0.9") then
                msg = string.format("%s (%s)", msg, diagnostic.code)
              end
            end
            return msg
          end,
          style = "minimal",
          border = "rounded",
          source = "always",
        },
      },
      servers = {
        lua_ls = {
          mason = true,
          settings = {
            Lua = {
              hint = {
                enable = true,
              },
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
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
        eslint = {},
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
        -- C/C++
        clangd = {},
        -- Go
        golangci_lint_ls = {
          filetypes = { "go", "gomod" },
        },
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
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        eslint = function()
          require("lazyvim.util").on_attach(function(client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
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
        "prettier",
        -- yaml
        "yaml-language-server",
        -- golang
        "gopls",
        "delve",
        "gomodifytags",
        "goimports",
        "staticcheck",
        -- "golangci-lint",
        "golangci-lint-langserver",
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
        -- SQL
        "sqlls",
      })
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      -- opts.debug = true
      ---@diagnostic disable-next-line: missing-parameter
      vim.list_extend(opts.sources, {
        nls.builtins.formatting.prettier,
        -- nls.builtins.formatting.prettierd.with({
        --   generator_opts = {
        --     command = "prettierd",
        --     args = function(params)
        --       if params.method == methods.FORMATTING then
        --         return { "$FILENAME" }
        --       end
        --       --
        --       -- local row, end_row = params.range.row - 1, params.range.end_row - 1
        --       -- local col, end_col = params.range.col - 1, params.range.end_col - 1
        --       -- local start_offset = vim.api.nvim_buf_get_offset(params.bufnr, row) + col
        --       -- local end_offset = vim.api.nvim_buf_get_offset(params.bufnr, end_row) + end_col
        --       --
        --       -- return { "$FILENAME", "--range-start=" .. -1, "--range-end=" .. -1 }
        --     end,
        --   },
        -- }),
        -- Go
        nls.builtins.code_actions.gomodifytags,
        -- Shell
        nls.builtins.code_actions.shellcheck,
        -- GitHub Action
        nls.builtins.diagnostics.actionlint,
      })
    end,
  },
}
