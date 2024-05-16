require("user.lsp").setup()

local lspconfig = require("lspconfig")
local userlsp = require("user.lsp")
local util = require("lspconfig.util")

---@param client vim.lsp.client LSP client
---@param bufnr number Buffer number
---@diagnostic disable: unused-local
local on_attach = function(client, bufnr)
  userlsp.on_attach(client, bufnr)
end

local servers = {
  html = {},
  cssls = {},
  jsonls = {},
  eslint = {},
  dockerls = {},
  yamlls = {},
  bashls = {
    filetypes = { "sh", "zsh", "bash" },
  },
  ltex = {
    filetypes = { "markdown", "text", "pandoc" },
    flags = { debounce_text_changes = 300 },
  },
  rust_analyzer = {},
}

servers.gopls = {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)

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
}

servers.nil_ls = {
  root_dir = util.root_pattern("flake.nix", "default.nix", "shell.nix", ".git"),
}

servers.lua_ls = {
  on_attach = on_attach,
  capabilities = userlsp.make_client_capabilities(),
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
}

servers.golangci_lint_ls = {
  filetypes = { "go", "gomod" },
}

for k, v in pairs(servers) do
  local opts = v or {}
  opts.on_attach = opts.on_attach or on_attach
  opts.capabilities = userlsp.make_client_capabilities()
  lspconfig[k].setup(opts)
end
