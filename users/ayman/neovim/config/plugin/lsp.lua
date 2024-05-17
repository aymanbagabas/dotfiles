require("user.lsp").setup()

-- neoconf must come before lspconfig
require("neoconf").setup({})

local lspconfig = require("lspconfig")
local userlsp = require("user.lsp")
local util = require("lspconfig.util")

lspconfig.html.setup({})

lspconfig.cssls.setup({})

lspconfig.jsonls.setup({
  settings = {
    -- Use schemastore with json
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

lspconfig.eslint.setup({})

lspconfig.dockerls.setup({})

lspconfig.yamlls.setup({
  on_attach = function(client, bufnr)
    -- Neovim < 0.10 does not have dynamic registration for formatting
    if vim.fn.has("nvim-0.10") == 0 then
      if client.name == "yamlls" then
        client.server_capabilities.documentFormattingProvider = true
      end
    end
  end,
  -- Have to add this for yamlls to understand that we support line folding
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  },
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
})

lspconfig.bashls.setup({
  filetypes = { "sh", "zsh", "bash" },
})

lspconfig.ltex.setup({
  filetypes = { "markdown", "text", "pandoc" },
  flags = { debounce_text_changes = 300 },
})

lspconfig.rust_analyzer.setup({})

lspconfig.gopls.setup({
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
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      semanticTokens = true,
    },
  },
  flags = {
    debounce_text_changes = 150,
  },
})

lspconfig.golangci_lint_ls.setup({})

lspconfig.nil_ls.setup({
  root_dir = util.root_pattern("flake.nix", "default.nix", "shell.nix", ".git"),
})

lspconfig.lua_ls.setup({
  on_init = function(client)
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
})
