-- Spectre is a search and replace UI, so nothing needs it until the mapping
-- runs. Requiring it at startup cost about 15ms for a window that most
-- sessions never open.
local configured = false

local function open()
  if not configured then
    configured = true
    require("spectre").setup({
      open_cmd = "noswapfile vnew",
      replace_engine = {
        sed = {
          warn = false,
        },
      },
    })
  end

  require("spectre").open()
end

vim.keymap.set("n", "<leader>sr", open, { desc = "Replace in files (Spectre)" })
