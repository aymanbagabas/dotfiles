---@mod user.lsp
---
---@brief [[
---LSP related functions
---@brief ]]

-- Format code and organize imports (if supported).
--
---@param client vim.lsp.Client Client
---@param bufnr number Buffer number
---@param timeoutms number timeout in ms
local organize_imports = function(client, bufnr, timeoutms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, timeoutms)
  for cid, res in pairs(result or {}) do
    if cid == client.id then
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = client.offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        elseif r.command and r.command.command then
          vim.lsp.buf.execute_command(r.command)
        end
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
  end
  return capabilities
end

--- Set keymap
---@param client vim.lsp.Client LSP client
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

  if client.supports_method("textDocument/inlayHint") then
    keymap("n", "<space>uh", function()
      local current_setting = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
      vim.lsp.inlay_hint.enable(not current_setting, { bufnr = bufnr })
    end, { desc = "Toggle Inlay Hints" })
  end
end

--- On attach for key maps.
---@param client vim.lsp.Client LSP client
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
  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup(string.format("LspCodeLensReferesh-%s-%s", bufnr, client.id), {}),
    callback = function()
      if client.server_capabilities.codeLensProvider then
        vim.lsp.codelens.refresh({ bufnr = bufnr })
      end
    end,
  })
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

M.setup = function()
  local group = vim.api.nvim_create_augroup("LspAttachGroup", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client == nil then
        return
      end

      M.on_attach(client, bufnr)

      -- Enable inlay hints if option is set
      if vim.g.show_inlay_hints then
        if client.supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end

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

  vim.api.nvim_create_autocmd("LspDetach", {
    group = vim.api.nvim_create_augroup("LspDetachGroup", { clear = true }),
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client == nil then
        return
      end

      if client.supports_method("textDocument/codeLens") then
        vim.lsp.codelens.clear(client.id, bufnr)
      end
    end,
  })
end

return M
