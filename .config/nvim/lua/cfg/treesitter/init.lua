local M = {}

M.setup = function ()
    local ts_config = require("nvim-treesitter.configs")

    ts_config.setup {
        ensure_installed = {
            "javascript",
            "html",
            "css",
            "bash",
            "cpp",
            "rust",
            "lua",
            "go"
        },
        highlight = {
            enable = true,
            use_languagetree = true
        },
        context_commentstring = {
            enable = true
        }
    }
end

return M
