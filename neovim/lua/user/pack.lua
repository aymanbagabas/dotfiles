local M = {}

local telescope_fzf_name = "telescope-fzf-native.nvim"

local function is_windows()
  return vim.fn.has("win32") == 1
end

local function artifact_name()
  return is_windows() and "libfzf.dll" or "libfzf.so"
end

local function artifact_path(path)
  return vim.fs.joinpath(path, "build", artifact_name())
end

local function build_commands()
  if is_windows() then
    if vim.fn.executable("cmake") == 1 then
      return {
        { "cmake", "-S.", "-Bbuild", "-DCMAKE_BUILD_TYPE=Release" },
        { "cmake", "--build", "build", "--config", "Release", "--target", "install" },
      }
    end

    if vim.fn.executable("make") == 1 then
      return {
        { "make" },
      }
    end
  else
    if vim.fn.executable("make") == 1 then
      return {
        { "make" },
      }
    end

    if vim.fn.executable("cmake") == 1 then
      return {
        { "cmake", "-S.", "-Bbuild", "-DCMAKE_BUILD_TYPE=Release" },
        { "cmake", "--build", "build", "--config", "Release", "--target", "install" },
      }
    end
  end
end

local function notify(msg, level)
  vim.schedule(function()
    vim.notify(msg, level, { title = "vim.pack" })
  end)
end

function M.build_telescope_fzf_native(path, opts)
  opts = opts or {}

  local commands = build_commands()
  if not commands then
    notify(
      "Unable to build telescope-fzf-native.nvim: install CMake or make with a C compiler available in PATH.",
      vim.log.levels.ERROR
    )
    return false
  end

  for _, cmd in ipairs(commands) do
    local result = vim.system(cmd, { cwd = path, text = true }):wait()
    if result.code ~= 0 then
      local details = vim.trim((result.stdout or "") .. "\n" .. (result.stderr or ""))
      notify(
        ("Failed to build telescope-fzf-native.nvim with `%s`.\n%s"):format(table.concat(cmd, " "), details),
        vim.log.levels.ERROR
      )
      return false
    end
  end

  local artifact = artifact_path(path)
  if not vim.uv.fs_stat(artifact) then
    notify(
      ("telescope-fzf-native.nvim build completed without producing %s"):format(artifact),
      vim.log.levels.ERROR
    )
    return false
  end

  if not opts.silent_success then
    notify("Built telescope-fzf-native.nvim", vim.log.levels.INFO)
  end
  return true
end

function M.ensure_telescope_fzf_native()
  local plugin = vim.pack.get({ telescope_fzf_name }, { info = false })[1]
  if not plugin then
    return false
  end

  if vim.uv.fs_stat(artifact_path(plugin.path)) then
    return true
  end

  return M.build_telescope_fzf_native(plugin.path, { silent_success = true })
end

function M.setup_hooks()
  if vim.g.pack_hooks_initialized then
    return
  end
  vim.g.pack_hooks_initialized = true

  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      local data = ev.data
      if not data or not data.spec then
        return
      end

      if data.spec.name ~= telescope_fzf_name then
        return
      end

      if data.kind ~= "install" and data.kind ~= "update" then
        return
      end

      M.build_telescope_fzf_native(data.path, { silent_success = true })
    end,
  })
end

return M
