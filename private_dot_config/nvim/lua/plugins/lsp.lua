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

-- attach organize imports to lsp
require("lazyvim.util").on_attach(function(client, buffer)
  -- If the organizeImports codeAction runs for lua files, depending on
  -- where the cursor is, it'll reorder the args and break stuff.
  -- This took me way too long to figure out.
  if client.server_capabilities.codeActionProvider and vim.bo.filetype ~= "lua" and client.name ~= "null-ls" then
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      buffer = buffer,
      callback = function()
        organize_imports(client, buffer, 1500)
      end,
      group = vim.api.nvim_create_augroup("LspOrganize", { clear = true }),
    })
  end
end)

return {
  {
    "neovim/nvim-lspconfig",
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
            require("inlay-hints").on_attach(client, buffer)
          end)
        end,
      },
    },
    opts = {
      servers = {
        -- Common
        grammarly = {},
        -- Web
        html = {},
        cssls = {},
        jsonls = {},
        -- Docker
        dockerls = {},
        -- YAML
        yamlls = {},
        -- Bash/Shell
        bashls = {},
        -- Terraform
        terraformls = {},
        -- Python
        jedi_language_server = {},
        -- Java
        jdtls = {},
        -- Rust
        rust_analyzer = {},
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
}
