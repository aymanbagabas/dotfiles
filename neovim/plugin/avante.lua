require("avante_lib").load()
require("avante").setup({
  behaviour = {
    auto_suggestions = false,
  },
  hints = { enabled = true },
  windows = {
    width = 30,
    sidebar_header = {
      align = "left",
      rounded = false,
    },
  },
})
