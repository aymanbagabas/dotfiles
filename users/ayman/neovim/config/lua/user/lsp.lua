---@mod user.lsp
---
---@brief [[
---LSP related functions
---@brief ]]

-- Format code and organize imports (if supported).
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

-- Checks if the given buffer has any lsp clients that support the given method.
--
---@param bufnr number Buffer number
---@param method string Method name
---@return boolean
local has_clients_with_method = function(bufnr, method)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = method })
  return #clients > 0
end

---@param bufnr number
---@param method string
---@param fn function(client)
local on_clients = function(bufnr, method, fn)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = method })
  for _, client in ipairs(clients) do
    fn(client)
  end
end

local M = {}

---Gets a 'ClientCapabilities' object, describing the LSP client capabilities
---Extends the object with capabilities provided by plugins.
---@return lsp.ClientCapabilities
function M.make_client_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- Add com_nvim_lsp capabilities
  local cmp_lsp = require("cmp_nvim_lsp")
  local cmp_lsp_capabilities = cmp_lsp.default_capabilities()
  capabilities = vim.tbl_deep_extend("keep", capabilities, cmp_lsp_capabilities)
  -- Add any additional plugin capabilities here.
  -- Make sure to follow the instructions provided in the plugin's docs.
  if vim.fn.has("nvim-0.10.0") == 1 then
    capabilities = vim.tbl_deep_extend("force", capabilities, {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true, -- needs fswatch on linux
          relativePatternSupport = true,
        },
      },
    })
    return capabilities
  end
end

--- Set keymap
---@param client vim.api.client LSP client
---@param bufnr number Buffer number
M.set_keymap = function(client, bufnr)
  local keymap = function(modes, lhs, rhs, opts)
    if opts == nil then
      opts = {}
    end
    opts.noremap = true
    opts.silent = true
    opts.buffer = true
    vim.keymap.set(modes, lhs, rhs, opts)
  end

  keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
  keymap("n", "<leader>cI", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })
  keymap("n", "<leader>cl", vim.lsp.codelens.run, { desc = "CodeLens" })
  keymap("n", "<leader>xl", vim.diagnostic.setloclist, { desc = "Location List" })
  keymap("n", "<leader>xq", vim.diagnostic.setqflist, { desc = "Quickfix List" })
  keymap("n", "<leader>cR", "<cmd>echo 'Restarting LSP...'<cr><cmd>LspRestart<cr>", { desc = "Restart LSP" })
  keymap("n", "gd", function()
    require("telescope.builtin").lsp_definitions({ reuse_win = true })
  end, { desc = "Goto Definition" })
  keymap("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "References" })
  keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
  keymap("n", "gI", function()
    require("telescope.builtin").lsp_implementations({ reuse_win = true })
  end, { desc = "Goto Implementation" })
  keymap("n", "gy", function()
    require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
  end, { desc = "Goto T[y]pe Definition" })
  keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
  keymap("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  keymap("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  keymap("n", "]d", M.diagnostic_goto(true), { desc = "Next Diagnostic" })
  keymap("n", "[d", M.diagnostic_goto(false), { desc = "Prev Diagnostic" })
  keymap("n", "]e", M.diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
  keymap("n", "[e", M.diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
  keymap("n", "]w", M.diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
  keymap("n", "[w", M.diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
  keymap("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
  keymap({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
  keymap("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })
  keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
  keymap("n", "<leader>cA", function()
    vim.lsp.buf.code_action({
      context = {
        only = {
          "source",
        },
        diagnostics = {},
      },
    })
  end, { desc = "Source Action" })

  if client.server_capabilities.inlayHintProvider then
    keymap("n", "<space>ch", function()
      local current_setting = vim.lsp.inlay_hint.is_enabled(bufnr)
      vim.lsp.inlay_hint.enable(bufnr, not current_setting)
    end, { desc = "Toggle Inlay Hints" })
  end
end

--- On attach for key maps.
---@param client vim.api.client LSP client
---@param bufnr number Buffer number
M.on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Attach navic
  if client.supports_method("textDocument/documentSymbol") then
    require("nvim-navic").attach(client, bufnr)
  end

  M.set_keymap(client, bufnr)

  -- Auto-refresh code lenses
  if not client then
    return
  end
  local function buf_refresh_codeLens()
    vim.schedule(function()
      if client.server_capabilities.codeLensProvider then
        vim.lsp.codelens.refresh()
        return
      end
    end)
  end
  local group = vim.api.nvim_create_augroup(string.format("lsp-%s-%s", bufnr, client.id), {})
  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost", "TextChanged" }, {
      group = group,
      callback = buf_refresh_codeLens,
      buffer = bufnr,
    })
    buf_refresh_codeLens()
  end
  if vim.fn.has("nvim-0.10.0") == 1 then
    if client.server_capabilities.codeLensProvider then
      vim.lsp.inlay_hint.enable(true)
    end
  end
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

M.setup = function(opts)
  local group = vim.api.nvim_create_augroup("LspAttachGroup", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client == nil then
        return
      end

      M.on_attach(client, bufnr)

      vim.api.nvim_create_autocmd("LspDetach", {
        callback = function()
          if client.server_capabilities.codeLensProvider then
            vim.lsp.codelens.clear(client.id)
          end
        end,
        group = group,
      })

      -- Organize imports before save
      if client.name ~= "lua_ls" then
        vim.api.nvim_create_autocmd({ "BufWritePre" }, {
          callback = function()
            if client.supports_method("textDocument/codeAction") then
              organize_imports(client, bufnr, 1500)
            end
          end,
          group = group,
        })
      end
    end,
  })
end

return M
