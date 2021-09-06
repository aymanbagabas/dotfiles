local builtin = require "telescope.builtin"

local M = {}

M.find_files = function()
    builtin.find_files {
        find_command = {
            "rg",
            "--hidden",
            "--no-ignore",
            "--follow",
            "--files",
            "--smart-case",
        },
    }
end

M.git_files = function()
    builtin.git_files()
end

M.grep_string = function()
    local search = vim.fn.input "Grep >"
    if search then
        builtin.grep_string { only_sort_text = true, search = search }
    else
        builtin.live_grep()
    end
end


M.live_grep = function()
    builtin.live_grep()
end

M.oldfiles = function()
    builtin.oldfiles()
end

M.help_tags = function()
    builtin.help_tags()
end

M.buffers = function()
    builtin.buffers()
end

M.current_buffer_fuzzy_find = function()
    builtin.current_buffer_fuzzy_find()
end

M.bcommits = function()
    builtin.git_bcommits()
end

M.commits = function()
    builtin.git_commits()
end

M.modified_files = function()
    builtin.git_status()
end

M.code_actions = function()
    builtin.lsp_code_actions()
end

M.range_code_actions = function()
    builtin.lsp_range_code_actions()
end

M.document_diagnostics = function()
    builtin.lsp_document_diagnostics()
end

M.workspace_diagnostics = function()
    builtin.lsp_workspace_diagnostics()
end

M.definitions = function()
    builtin.lsp_definitions()
end

M.references = function()
    builtin.lsp_references()
end

M.workspace_symbols = function()
    local query = vim.fn.input "Query >"
    if query then
        vim.cmd("Telescope lsp_workspace_symbols query=" .. query)
    else
        builtin.lsp_workspace_symbols()
    end
end

M.document_symbols = function()
    builtin.lsp_document_symbols()
end

return M
