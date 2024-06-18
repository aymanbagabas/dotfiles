-- PERF: schedule to prevent headlines slowing down opening a file
vim.schedule(function()
  require("headlines").setup()
  require("headlines").refresh()
end)
