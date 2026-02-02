local ms = vim.lsp.protocol.Methods
local userlsp = require("user.lsp")
userlsp.setup()

local float_config = {
  focusable = false,
  style = "minimal",
  border = "rounded",
  source = "always",
  header = "",
  prefix = "",
}

-- setup diagnostics
vim.diagnostic.config({
  -- Requires Nerd fonts
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = require("icons").diagnostics.Error,
      [vim.diagnostic.severity.WARN] = require("icons").diagnostics.Warn,
      [vim.diagnostic.severity.INFO] = require("icons").diagnostics.Info,
      [vim.diagnostic.severity.HINT] = require("icons").diagnostics.Hint,
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = float_config,
  jump = {
    float = true,
  },
})

vim.lsp.handlers[ms.textDocument_hover] = vim.lsp.with(vim.lsp.handlers.hover, float_config)
vim.lsp.handlers[ms.textDocument_signatureHelp] = vim.lsp.with(vim.lsp.handlers.signature_help, float_config)

-- neoconf must come before lspconfig
require("neoconf").setup({})

local util = require("lspconfig.util")
local capabilities = userlsp.make_client_capabilities()

local lsps = {
  ["html"] = {
    capabilities = capabilities,
  },
  ["cssls"] = {
    capabilities = capabilities,
  },
  ["jsonls"] = {
    capabilities = capabilities,
    settings = {
      -- Use schemastore with json
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
  ["eslint"] = {
    capabilities = capabilities,
  },
  ["dockerls"] = {
    capabilities = capabilities,
  },
  ["yamlls"] = {
    on_attach = function(client, bufnr)
      -- Neovim < 0.10 does not have dynamic registration for formatting
      if vim.fn.has("nvim-0.10") == 0 then
        if client.name == "yamlls" then
          client.server_capabilities.documentFormattingProvider = true
        end
      end
    end,
    -- Have to add this for yamlls to understand that we support line folding
    capabilities = vim.tbl_deep_extend("keep", {
      textDocument = {
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    }, capabilities),
    settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = {
        keyOrdering = false,
        format = {
          enable = true,
        },
        validate = true,
        schemaStore = {
          -- Must disable built-in schemaStore support to use
          -- schemas from SchemaStore.nvim plugin
          enable = false,
          -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          url = "",
        },
        schemas = require("schemastore").yaml.schemas(),
      },
    },
  },
  ["helm_ls"] = {
    settings = {
      ["helm-ls"] = {
        yamlls = {
          path = "yaml-language-server",
        },
      },
    },
  },
  ["bashls"] = {
    capabilities = capabilities,
    filetypes = { "sh", "zsh", "bash" },
  },
  ["ltex"] = {
    capabilities = capabilities,
    filetypes = { "markdown", "text", "pandoc" },
    flags = { debounce_text_changes = 300 },
    settings = {
      ltex = {
        enabled = true,
        language = "en-US",
        additionalRules = {
          motherTongue = "ar",
        },
      },
    },
  },
  ["rust_analyzer"] = {
    capabilities = capabilities,
  },
  ["gopls"] = {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      -- workaround for gopls not supporting semanticTokensProvider
      -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
      if client.name == "gopls" then
        if not client.server_capabilities.semanticTokensProvider then
          local semantic = client.config.capabilities.textDocument.semanticTokens
          client.server_capabilities.semanticTokensProvider = {
            full = true,
            legend = {
              tokenTypes = semantic.tokenTypes,
              tokenModifiers = semantic.tokenModifiers,
            },
            range = true,
          }
        end
      end
    end,
    settings = {
      gopls = {
        gofumpt = true,
        codelenses = {
          gc_details = false,
          generate = true,
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
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
          fieldalignment = true,
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        usePlaceholders = false,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        semanticTokens = true,
      },
    },
    flags = {
      debounce_text_changes = 150,
    },
  },
  ["golangci_lint_ls"] = {
    capabilities = capabilities,
    filetypes = { "go", "gomod" },
  },
  ["nil_ls"] = {
    capabilities = capabilities,
    root_dir = util.root_pattern("flake.nix", "default.nix", "shell.nix", ".git"),
    settings = {
      ["nil"] = {
        formatting = {
          command = { "nixfmt" },
        },
      },
    },
  },
  ["lua_ls"] = {
    capabilities = capabilities,
    on_init = function(client)
      if #client.workspace_folders == 0 then
        return
      end

      local path = client.workspace_folders[1].name
      if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
        return
      end

      client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using
          -- (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          --library = {
          --vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
          --}
          -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
          library = vim.api.nvim_get_runtime_file("", true),
        },
      })
    end,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global, etc.
          globals = {
            "vim",
            "describe",
            "it",
            "assert",
            "stub",
          },
          disable = {
            "duplicate-set-field",
          },
        },
        workspace = {
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
        hint = { -- inlay hints (supported in Neovim >= 0.10)
          enable = true,
        },
      },
    },
  },
  ["ts_ls"] = {
    capabilities = capabilities,
    settings = {
      javascript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
      typescript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
    },
  },
  ["clangd"] = {
    on_attach = function(client, bufnr)
      vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>ch",
        "<cmd>ClangdSwitchSourceHeader<cr>",
        { desc = "Switch Source/Header (C/C++)" }
      )
    end,
  },
  ["zls"] = {},
  ["terraformls"] = {},
  ["jdtls"] = {},
  ["templ"] = {},
}

for lsp, config in pairs(lsps) do
  vim.lsp.config(lsp, config)
  vim.lsp.enable(lsp)
end
