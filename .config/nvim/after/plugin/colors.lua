-- set diagnostic symbols
local signs = {
    Error = {
        text = "━ ",
        fg = "#e06c75"
    },
    Warning = {
        text = "━ ",
        fg = "#e5c07b"
    },
    Hint = {
        text = "━ ",
        fg = "#61afef"
    },
    Information = {
        text = "━ ",
        fg = "#c8ccd4"
    }
}

for type, sign in pairs(signs) do
    local hlsign = "LspDiagnosticsSign" .. type
    local hlul = "LspDiagnosticsUnderline" .. type
    local hlvt = "LspDiagnosticsVirtualText" .. type
    vim.fn.sign_define(hlsign, { text = sign.text, texthl = hlsign, numhl = "" })
    vim.cmd("highlight " .. hlsign .. " guifg=" .. sign.fg .. " guibg=none")
    vim.cmd("highlight " .. hlul .. " cterm=undercurl guisp=".. sign.fg .. " gui=undercurl")
    vim.cmd("highlight " .. hlvt .. " guifg=".. sign.fg)
end
