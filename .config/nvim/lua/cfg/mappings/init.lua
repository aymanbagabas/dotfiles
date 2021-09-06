local M = {}

M.setup = function ()
    local function map(mode, lhs, rhs, opts)
        local options = {noremap = true}
        if opts then
            options = vim.tbl_extend("force", options, opts)
        end
        vim.api.nvim_set_keymap(mode, lhs, rhs, options)
    end

    local opt = {noremap = true, silent = true}

    -- keybind list
    map("", "<leader>c", '"+y')

    -- open terminals
    map("n", "<C-n>" , [[<Cmd> vnew term://zsh<CR>]] , opt) -- split term vertically , over the right
    map("n", "<C-x>" , [[<Cmd> split term://zsh | resize 10 <CR>]] , opt) -- split term vertically , over the right
    -- map esc to exit terminal mode
    map("t", "<ESC>", "<C-\\><C-n>")


    vim.api.nvim_set_keymap("n", "<D-/>", [[<Cmd>Commentary<CR>]], {noremap = true, silent = false})
    vim.api.nvim_set_keymap("v", "<D-/>", [[:'<,'>Commentary<CR>]], {noremap = true, silent = false})
    vim.api.nvim_set_keymap("n", "<D-s>", [[:w<CR>]], {noremap = true, silent = false})
    vim.api.nvim_set_keymap("n", "<D-f>", "/", {noremap = true, silent = false})
    vim.api.nvim_set_keymap("n", "<D-p>", [[<Cmd>lua require('cfg.telescope.builtin').find_files()<CR>]], {noremap = true, silent = false})
    vim.api.nvim_set_keymap("n", "<D-S-f>", [[<Cmd>lua require('cfg.telescope.builtin').live_grep()<CR>]], {noremap = true, silent = false})
    vim.api.nvim_set_keymap("n", "<D-b>", ":NvimTreeToggle<CR>", { noremap = true, silent = false })
    vim.api.nvim_set_keymap("v", "<D-c>", "\"+y", { noremap = true, silent = false })
    vim.api.nvim_set_keymap("v", "<D-c>", "\"+y", { noremap = true, silent = false })
    vim.api.nvim_set_keymap("n", "<D-h>", [[:KittyNavigateLeft<CR>]], { noremap = true, silent = false })
    vim.api.nvim_set_keymap("n", "<D-j>", [[:KittyNavigateDown<CR>]], { noremap = true, silent = false })
    vim.api.nvim_set_keymap("n", "<D-k>", [[:KittyNavigateUp<CR>]], { noremap = true, silent = false })
    vim.api.nvim_set_keymap("n", "<D-l>", [[:KittyNavigateRight<CR>]], { noremap = true, silent = false })

    vim.api.nvim_set_keymap("n", "<Char-0x10>/", "<D-/>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("v", "<Char-0x10>/", "<D-/>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("i", "<Char-0x10>/", "<C-o><D-/>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("n", "<Char-0x10>s", "<D-s>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("i", "<Char-0x10>s", "<C-o><D-s>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("n", "<Char-0x10>f", "<D-f>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("i", "<Char-0x10>f", "<C-o><D-f>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("n", "<Char-0x10>F", "<D-S-f>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("i", "<Char-0x10>F", "<C-o><D-S-f>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("n", "<Char-0x10>p", "<D-p>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("i", "<Char-0x10>p", "<C-o><D-p>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("n", "<Char-0x10>P", "<D-S-p>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("i", "<Char-0x10>P", "<C-o><D-S-p>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("n", "<Char-0x10>b", "<D-b>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("i", "<Char-0x10>b", "<C-o><D-b>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("v", "<Char-0x10>c", "<D-c>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("n", "<Char-0x10>h", "<D-h>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("i", "<Char-0x10>h", "<C-o><D-h>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("n", "<Char-0x10>j", "<D-j>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("i", "<Char-0x10>j", "<C-o><D-j>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("n", "<Char-0x10>k", "<D-k>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("i", "<Char-0x10>k", "<C-o><D-k>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("n", "<Char-0x10>l", "<D-l>", {noremap = false, silent = false})
    vim.api.nvim_set_keymap("i", "<Char-0x10>l", "<C-o><D-l>", {noremap = false, silent = false})
end

return M
