local ms = vim.lsp.protocol.Methods
local userlsp = require("user.lsp")
userlsp.setup()

-- Requires Nerd fonts
for name, icon in pairs(require("icons").diagnostics) do
  name = "DiagnosticSign" .. name
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
end

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
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = float_config,
})

vim.lsp.handlers[ms.textDocument_hover] = vim.lsp.with(vim.lsp.handlers.hover, float_config)
vim.lsp.handlers[ms.textDocument_signatureHelp] = vim.lsp.with(vim.lsp.handlers.signature_help, float_config)

-- neoconf must come before lspconfig
require("neoconf").setup({})

local lspconfig = require("lspconfig")
local util = require("lspconfig.util")
local capabilities = userlsp.make_client_capabilities()

lspconfig.html.setup({
  capabilities = capabilities,
})

lspconfig.cssls.setup({
  capabilities = capabilities,
})

lspconfig.jsonls.setup({
  capabilities = capabilities,
  settings = {
    -- Use schemastore with json
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

lspconfig.eslint.setup({
  capabilities = capabilities,
})

lspconfig.dockerls.setup({
  capabilities = capabilities,
})

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
})

lspconfig.bashls.setup({
  capabilities = capabilities,
  filetypes = { "sh", "zsh", "bash" },
})

lspconfig.ltex.setup({
  capabilities = capabilities,
  filetypes = { "markdown", "text", "pandoc" },
  flags = { debounce_text_changes = 300 },
})

lspconfig.rust_analyzer.setup({
  capabilities = capabilities,
})

lspconfig.gopls.setup({
  capabilities = vim.tbl_extend("force", capabilities, {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true, -- needs fswatch on linux
        relativePatternSupport = true,
      },
    },
  }),
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

lspconfig.golangci_lint_ls.setup({
  capabilities = capabilities,
  filetypes = { "go", "gomod" },
})

lspconfig.nil_ls.setup({
  capabilities = capabilities,
  root_dir = util.root_pattern("flake.nix", "default.nix", "shell.nix", ".git"),
})

lspconfig.lua_ls.setup({
  capabilities = capabilities,
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

lspconfig.tsserver.setup({
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
})

lspconfig.clangd.setup({
  capabilities = vim.tbl_extend("force", capabilities, {
    offsetEncoding = { "utf-16" },
  }),
  on_attach = function(client, bufnr)
    if not package.loaded["clangd_extensions"] then
      require("clangd_extensions").setup({
        inlay_hints = {
          inline = false,
        },
      })
    end

    vim.api.nvim_buf_set_keymap(
      bufnr,
      "n",
      "<leader>ch",
      "<cmd>ClangdSwitchSourceHeader<cr>",
      { desc = "Switch Source/Header (C/C++)" }
    )
  end,
  root_dir = function(fname)
    return require("lspconfig.util").root_pattern(
      "Makefile",
      "configure.ac",
      "configure.in",
      "config.h.in",
      "meson.build",
      "meson_options.txt",
      "build.ninja"
    )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(fname) or require(
      "lspconfig.util"
    ).find_git_ancestor(fname)
  end,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
})