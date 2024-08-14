local M = {}

---@class Root
---@field paths string[]
---@field spec RootSpec

---@alias RootFn fun(buf: number): (string|string[])

---@alias RootSpec string|string[]|RootFn

---@type RootSpec[]
M.spec = { "lsp", { ".git", "lua" }, "cwd" }

function M.is_win()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

---@return string
function M.norm(path)
  if path:sub(1, 1) == "~" then
    local home = vim.uv.os_homedir()
    if not home then
      return path
    end
    if home:sub(-1) == "\\" or home:sub(-1) == "/" then
      home = home:sub(1, -2)
    end
    path = home .. path:sub(2)
  end
  path = path:gsub("\\", "/"):gsub("/+", "/")
  return path:sub(-1) == "/" and path:sub(1, -2) or path
end

---@param opts? { buf?: number, spec?: RootSpec[], all?: boolean }
function M.detect(opts)
  opts = opts or {}
  opts.spec = opts.spec or type(vim.g.root_spec) == "table" and vim.g.root_spec or M.spec
  opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf

  local ret = {} ---@type Root[]
  for _, spec in ipairs(opts.spec) do
    local paths = M.resolve(spec)(opts.buf)
    paths = paths or {}
    paths = type(paths) == "table" and paths or { paths }
    local roots = {} ---@type string[]
    for _, p in ipairs(paths) do
      local pp = M.realpath(p)
      if pp and not vim.tbl_contains(roots, pp) then
        roots[#roots + 1] = pp
      end
    end
    table.sort(roots, function(a, b)
      return #a > #b
    end)
    if #roots > 0 then
      ret[#ret + 1] = { spec = spec, paths = roots }
      if opts.all == false then
        break
      end
    end
  end
  return ret
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@param opts? {normalize?:boolean, buf?:number}
---@return string
function M.get_root(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  local ret = M.cache[buf]
  if not ret then
    local roots = M.detect({ all = false, buf = buf })
    ret = roots[1] and roots[1].paths[1] or vim.uv.cwd()
    if not ret then
      return ""
    end
    M.cache[buf] = ret
  end
  if opts and opts.normalize then
    return ret or ""
  end
  return M.is_win() and ret:gsub("/", "\\") or ret
end

return M
