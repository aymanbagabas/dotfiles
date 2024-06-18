require('ibl').setup({
  indent = {
    char = "▏",
    tab_char = "▏",
  },
  exclude = { filetypes = require('exclude_list') },
  scope = {
    enabled = false,
    show_start = false,
    show_end = false
  },
})
