require("oil").setup({
  default_file_explorer = true,
  delete_to_trash = false,
  skip_confirm_for_simple_edits = true,
  watch_for_changes = false,
  use_default_keymaps = true,
  view_options = {
    show_hidden = true,
  },
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
