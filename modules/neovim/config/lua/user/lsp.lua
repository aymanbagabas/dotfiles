---@mod user.lsp
---
---@brief [[
---LSP related functions
---@brief ]]

local ms = vim.lsp.protocol.Methods

-- Format code and organize imports (if supported).
--
---@param client vim.lsp.Client Client
---@param bufnr number Buffer number
---@param timeoutms number timeout in ms
local organize_imports = function(client, bufnr, timeoutms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  local result = client.request_sync(ms.textDocument_codeAction, params, timeoutms, bufnr) or {}
  for _, r in pairs(result.result or {}) do
    if r.edit then
      local enc = client.offset_encoding or "utf-16"
      vim.lsp.util.apply_workspace_edit(r.edit, enc)
    elseif r.command and r.command.command then
      vim.lsp.buf.execute_command(r.command)
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
  local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp and cmp_nvim_lsp.default_capabilities() or {}
  )
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

  if client.supports_method(ms.textDocument_definition) then
    keymap("n", "gd", function()
      require("telescope.builtin").lsp_definitions({ reuse_win = true })
    end, { desc = "Goto Definition" })
  end

  keymap("n", "gr", require("telescope.builtin").lsp_references, { desc = "References" })
  keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
  keymap("n", "gI", function()
    require("telescope.builtin").lsp_implementations({ reuse_win = true })
  end, { desc = "Goto Implementation" })
  keymap("n", "gy", function()
    require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
  end, { desc = "Goto T[y]pe Definition" })
  keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover" })

  if client.supports_method(ms.textDocument_signatureHelp) then
    keymap("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
    keymap("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  end

  keymap("n", "]d", M.diagnostic_goto(true), { desc = "Next Diagnostic" })
  keymap("n", "[d", M.diagnostic_goto(false), { desc = "Prev Diagnostic" })
  keymap("n", "]e", M.diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
  keymap("n", "[e", M.diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
  keymap("n", "]w", M.diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
  keymap("n", "[w", M.diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
  keymap("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })

  if client.supports_method(ms.textDocument_codeAction) then
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
  end

  if client.supports_method(ms.textDocument_codeLens) then
    keymap({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
    keymap("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })
  end

  if client.supports_method(ms.textDocument_inlayHint) then
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
  if client.supports_method(ms.textDocument_documentSymbol) then
    require("nvim-navic").attach(client, bufnr)
  end

  M.set_keymap(client, bufnr)

  -- Auto-refresh code lenses
  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    buffer = bufnr,
    group = vim.api.nvim_create_augroup("LspCodeLensReferesh", { clear = true }),
    callback = function(args)
      local buffer = args.buf or bufnr
      -- don't trigger on invalid buffers
      if not vim.api.nvim_buf_is_valid(buffer) then
        return
      end
      -- don't trigger on non-listed buffers
      if not vim.bo[buffer].buflisted then
        return
      end
      -- don't trigger on nofile buffers
      if vim.bo[buffer].buftype == "nofile" then
        return
      end
      if client.supports_method(ms.textDocument_codeLens) then
        vim.lsp.codelens.refresh({ bufnr = buffer })
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
      if vim.g.show_inlay_hint then
        if client.supports_method(ms.textDocument_inlayHint) then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end

      -- Organize imports before save
      if client.supports_method(ms.textDocument_codeAction) then
        if client.name ~= "lua_ls" then
          vim.api.nvim_create_autocmd({ "BufWritePre" }, {
            buffer = bufnr,
            callback = function()
              organize_imports(client, bufnr, 1000)
            end,
            group = group,
          })
        end
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

      -- don't trigger on invalid buffers
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      -- don't trigger on non-listed buffers
      if not vim.bo[bufnr].buflisted then
        return
      end
      -- don't trigger on nofile buffers
      if vim.bo[bufnr].buftype == "nofile" then
        return
      end

      if client.supports_method(ms.textDocument_codeLens) then
        vim.lsp.codelens.clear(client.id, bufnr)
      end
    end,
  })
end

return M