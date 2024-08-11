local M = {}

---Open a uri with the system's default application.
---@param uri string The uri to open.
function M.open(uri)
  local cmd
  if vim.fn.has("win32") == 1 then
    cmd = { "explorer", uri }
  elseif vim.fn.has("macunix") == 1 then
    cmd = { "open", uri }
  else
    if vim.fn.executable("xdg-open") == 1 then
      cmd = { "xdg-open", uri }
    elseif vim.fn.executable("wslview") == 1 then
      cmd = { "wslview", uri }
    else
      cmd = { "open", uri }
    end
  end

  local ret = vim.fn.jobstart(cmd, { detach = true })
  if ret <= 0 then
    local msg = {
      "Failed to open uri",
      ret,
      vim.inspect(cmd),
    }
    vim.notify(table.concat(msg, "\n"), vim.log.levels.ERROR)
  end
end

return M
