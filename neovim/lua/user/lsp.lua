---@mod user.lsp
---
---@brief [[
---LSP related functions
---@brief ]]

local M = {}

local ms = vim.lsp.protocol.Methods
local Root = require("user.root")

-- Format code and organize imports (if supported).
--
---@param client vim.lsp.Client Client
---@param bufnr number Buffer number
---@param timeoutms number timeout in ms
local organize_imports = function(client, bufnr, timeoutms)
  local enc = client.offset_encoding or "utf-16"
  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_range_params(win, enc)
  params.context = { only = { "source.organizeImports" } }
  local result = client:request_sync(ms.textDocument_codeAction, params, timeoutms, bufnr) or {}
  for _, r in pairs(result.result or {}) do
    if r.edit then
      vim.lsp.util.apply_workspace_edit(r.edit, enc)
    elseif r.command and r.command.command then
      client:exec_cmd(r.command, { bufnr = bufnr })
    end
  end
end

local rename_file = function()
  local buf = vim.api.nvim_get_current_buf()
  local old = assert(Root.realpath(vim.api.nvim_buf_get_name(buf)))
  local root = assert(Root.realpath(Root.get_root({ normalize = true })))
  assert(old:find(root, 1, true) == 1, "File not in project root")

  local extra = old:sub(#root + 2)

  vim.ui.input({
    prompt = "New File Name: ",
    default = extra,
    completion = "file",
  }, function(new)
    if not new or new == "" or new == extra then
      return
    end
    new = Root.norm(root .. "/" .. new)
    vim.fn.mkdir(vim.fs.dirname(new), "p")
    M.on_rename(old, new, function()
      vim.fn.rename(old, new)
      vim.cmd.edit(new)
      vim.api.nvim_buf_delete(buf, { force = true })
      vim.fn.delete(old)
    end)
  end)
end

---@param from string
---@param to string
---@param rename? fun()
function M.on_rename(from, to, rename)
  local changes = { files = { {
    oldUri = vim.uri_from_fname(from),
    newUri = vim.uri_from_fname(to),
  } } }

  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client:supports_method("workspace/willRenameFiles") then
      local resp = client:request_sync("workspace/willRenameFiles", changes, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end

  if rename then
    rename()
  end

  for _, client in ipairs(clients) do
    if client:supports_method("workspace/didRenameFiles") then
      client:notify("workspace/didRenameFiles", changes)
    end
  end
end

---Gets a 'ClientCapabilities' object, describing the LSP client capabilities
---Extends the object with capabilities provided by plugins.
---@return lsp.ClientCapabilities
function M.make_client_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- enable lsp file watch support
  capabilities = vim.tbl_extend("force", capabilities, {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true, -- needs fswatch on linux
        relativePatternSupport = true,
      },
    },
  })
  return require("blink.cmp").get_lsp_capabilities(capabilities)
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

  keymap("n", "<leader>xl", vim.diagnostic.setloclist, { desc = "Location List" })
  keymap("n", "<leader>xq", vim.diagnostic.setqflist, { desc = "Quickfix List" })

  keymap("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })
  keymap("n", "<leader>lr", "<cmd>echo 'Restarting LSP...'<cr><cmd>LspRestart<cr>", { desc = "Restart LSP" })

  if client:supports_method(ms.textDocument_definition) then
    keymap("n", "gd", function()
      require("telescope.builtin").lsp_definitions({ reuse_win = true })
    end, { desc = "Goto Definition" })
  end

  keymap("n", "grr", "<cmd>Telescope lsp_references<cr>", { desc = "References" })
  keymap("n", "grd", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
  keymap("n", "gri", function()
    require("telescope.builtin").lsp_implementations({ reuse_win = true })
  end, { desc = "Goto Implementation" })
  keymap("n", "grD", function()
    require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
  end, { desc = "Goto Type Definition" })
  keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover" })

  if client:supports_method(ms.textDocument_signatureHelp) then
    keymap("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
    keymap({ "i", "s" }, "<c-s>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  end

  keymap("n", "]e", M.diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
  keymap("n", "[e", M.diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
  keymap("n", "]w", M.diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
  keymap("n", "[w", M.diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
  keymap("n", "grn", vim.lsp.buf.rename, { desc = "Rename" })

  if client:supports_method(ms.textDocument_codeAction) then
    keymap({ "n", "v" }, "gra", vim.lsp.buf.code_action, { desc = "Code Action" })
    keymap("n", "grA", function()
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

  if client:supports_method(ms.workspace_didRenameFiles) and client:supports_method(ms.workspace_willRenameFiles) then
    keymap("n", "grN", rename_file, { desc = "Rename File" })
  end

  if client:supports_method(ms.textDocument_codeLens) then
    keymap({ "n", "v" }, "grc", vim.lsp.codelens.run, { desc = "Run Codelens" })
    keymap("n", "grC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })
  end

  if client:supports_method(ms.textDocument_inlayHint) then
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
      if client:supports_method(ms.textDocument_codeLens) then
        vim.lsp.codelens.refresh({ bufnr = buffer })
      end
    end,
  })
end

function M.diagnostic_goto(next, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump({
      count = next and 1 or -1,
      severity = severity,
    })
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
        if client:supports_method(ms.textDocument_inlayHint) then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end

      -- Organize imports before save
      if client:supports_method(ms.textDocument_codeAction) then
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

      vim.schedule(function()
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

        vim.api.nvim_create_autocmd("LspDetach", {
          buffer = bufnr,
          group = vim.api.nvim_create_augroup("LspDetachGroup_" .. bufnr, { clear = true }),
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client == nil then
              return
            end

            if client:supports_method(ms.textDocument_codeLens) then
              vim.lsp.codelens.clear(client.id, bufnr)
            end
          end,
        })
      end)
    end,
  })
end

return M
