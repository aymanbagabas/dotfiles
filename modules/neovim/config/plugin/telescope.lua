local telescope = require("telescope")
local actions = require("telescope.actions")

local builtin = require("telescope.builtin")

local layout_config = {
  vertical = {
    width = function(_, max_columns)
      return math.floor(max_columns * 0.99)
    end,
    height = function(_, _, max_lines)
      return math.floor(max_lines * 0.99)
    end,
    prompt_position = "bottom",
    preview_cutoff = 0,
  },
}

-- Fall back to find_files if not in a git repo
local project_files = function(opt)
  local opts = opt or {
    show_untracked = true,
  }
  local ok = pcall(builtin.git_files, opts)
  if not ok then
    builtin.find_files(opts)
  end
end

local project_files_cwd = function()
  project_files({ cwd = false })
end

vim.keymap.set(
  "n",
  "<leader>,",
  "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
  { desc = "Switch Buffer" }
)
vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Grep (Root Dir)" })
vim.keymap.set("n", "<leader>:", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
vim.keymap.set("n", "<leader><space>", project_files, { desc = "Find Files (Root Dir)" })
-- find
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>ff", project_files, { desc = "Find Files (Root Dir)" })
vim.keymap.set("n", "<leader>fF", project_files_cwd, { desc = "Find Files (cwd)" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope git_files<cr>", { desc = "Find Files (git-files)" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent" })
vim.keymap.set("n", "<leader>fR", function()
  builtin.oldfiles({ cwd = vim.loop.cwd() })
end, { desc = "Recent (cwd)" })
-- git
vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Commits" })
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Status" })
-- search
vim.keymap.set("n", '<leader>s"', "<cmd>Telescope registers<cr>", { desc = "Registers" })
vim.keymap.set("n", "<leader>sa", "<cmd>Telescope autocommands<cr>", { desc = "Auto Commands" })
vim.keymap.set("n", "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Buffer" })
vim.keymap.set("n", "<leader>sc", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
vim.keymap.set("n", "<leader>sC", "<cmd>Telescope commands<cr>", { desc = "Commands" })
vim.keymap.set("n", "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Document Diagnostics" })
vim.keymap.set("n", "<leader>sD", "<cmd>Telescope diagnostics<cr>", { desc = "Workspace Diagnostics" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Grep (Root Dir)" })
vim.keymap.set("n", "<leader>sG", function()
  builtin.live_grep({ cwd = false })
end, { desc = "Grep (cwd)" })
vim.keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sH", "<cmd>Telescope highlights<cr>", { desc = "Search Highlight Groups" })
vim.keymap.set("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Key Maps" })
vim.keymap.set("n", "<leader>sl", "<cmd>Telescope loclist<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>sM", "<cmd>Telescope man_pages<cr>", { desc = "Man Pages" })
vim.keymap.set("n", "<leader>sm", "<cmd>Telescope marks<cr>", { desc = "Jump to Mark" })
vim.keymap.set("n", "<leader>so", "<cmd>Telescope vim_options<cr>", { desc = "Options" })
vim.keymap.set("n", "<leader>sR", "<cmd>Telescope resume<cr>", { desc = "Resume" })
vim.keymap.set("n", "<leader>sq", "<cmd>Telescope quickfix<cr>", { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>sw", function()
  builtin.grep_string({ word_match = "-w" })
end, { desc = "Word (Root Dir)" })
vim.keymap.set("n", "<leader>sW", function()
  builtin.grep_string({ cwd = false, word_match = "-w" })
end, { desc = "Word (cwd)" })
vim.keymap.set("v", "<leader>sw", builtin.grep_string, { desc = "Selection (Root Dir)" })
vim.keymap.set("v", "<leader>sW", function()
  builtin.grep_string({ cwd = false })
end, { desc = "Selection (cwd)" })
vim.keymap.set("n", "<leader>uC", function()
  builtin.colorscheme({ enable_preview = true })
end, { desc = "Colorscheme with Preview" })

local documentSymbols = function()
  builtin.lsp_document_symbols({
    symbols = require("kind_filter").get(),
  })
end
vim.keymap.set("n", "gO", documentSymbols, { desc = "Goto Symbol" })
vim.keymap.set("n", "<leader>ss", documentSymbols, { desc = "Goto Symbol" })
vim.keymap.set("n", "<leader>sS", function()
  builtin.lsp_dynamic_workspace_symbols({
    symbols = require("kind_filter").get(),
  })
end, {
  desc = "Goto Symbol (Workspace)",
})

local open_with_trouble = function(...)
  return require("trouble.providers.telescope").open_with_trouble(...)
end
local open_selected_with_trouble = function(...)
  return require("trouble.providers.telescope").open_selected_with_trouble(...)
end
local find_files_no_ignore = function()
  local action_state = require("telescope.actions.state")
  local line = action_state.get_current_line()
  project_files({ no_ignore = true, default_text = line })()
end
local find_files_with_hidden = function()
  local action_state = require("telescope.actions.state")
  local line = action_state.get_current_line()
  project_files({ hidden = true, default_text = line })()
end

telescope.setup({
  defaults = {
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    prompt_prefix = " ",
    selection_caret = " ",
    -- open files in the first window that is an actual file.
    -- use the current window if no other window is available.
    get_selection_window = function()
      local wins = vim.api.nvim_list_wins()
      table.insert(wins, 1, vim.api.nvim_get_current_win())
      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == "" then
          return win
        end
      end
      return 0
    end,
    mappings = {
      i = {
        ["<c-t>"] = open_with_trouble,
        ["<a-t>"] = open_selected_with_trouble,
        ["<a-i>"] = find_files_no_ignore,
        ["<a-h>"] = find_files_with_hidden,
        ["<C-Down>"] = actions.cycle_history_next,
        ["<C-Up>"] = actions.cycle_history_prev,
        ["<C-f>"] = actions.preview_scrolling_down,
        ["<C-b>"] = actions.preview_scrolling_up,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
      },
      n = {
        ["q"] = actions.close,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

telescope.load_extension("fzf")
telescope.load_extension("projects")
