local M = {}

M.setup = function ()

    -- vim.cmd [[packadd nvim-lspconfig]]
    -- vim.cmd [[packadd nvim-cmp]]

    vim.cmd [[autocmd ColorScheme * highlight NormalFloat guibg=#1f2335]]
    vim.cmd [[autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]

    local border = {
        {"🭽", "FloatBorder"},
        {"▔", "FloatBorder"},
        {"🭾", "FloatBorder"},
        {"▕", "FloatBorder"},
        {"🭿", "FloatBorder"},
        {"▁", "FloatBorder"},
        {"🭼", "FloatBorder"},
        {"▏", "FloatBorder"},
    }

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
    -- Code actions
    capabilities.textDocument.codeAction = {
        dynamicRegistration = true,
        codeActionLiteralSupport = {
            codeActionKind = {
                valueSet = (function()
                    local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
                    table.sort(res)
                    return res
                end)()
            }
        }
    }

    capabilities.textDocument.completion.completionItem.snippetSupport = true;
    capabilities.textDocument.completion.completionItem.documentationFormat = { 'markdown', 'plaintext' }
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.preselectSupport = true
    capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
    capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
    capabilities.textDocument.completion.completionItem.deprecatedSupport = true
    capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
    capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
        },
    }

    local on_attach = function(client, bufnr)
        require'illuminate'.on_attach(client)
        require'lsp_signature'.on_attach(client)

        local function buf_set_keymap(...)
            vim.api.nvim_buf_set_keymap(bufnr, ...)
        end
        local function buf_set_option(...)
            vim.api.nvim_buf_set_option(bufnr, ...)
        end

        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        local opts = {noremap = true, silent = true}

        -- Mappings.
        buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
        buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        buf_set_keymap('n', '<leader>td', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
        buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        buf_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
        buf_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
        buf_set_keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
        buf_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
        buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        buf_set_keymap("n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
        buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
        buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
        buf_set_keymap("n", "<leader>ll", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

        -- Set some keybinds conditional on server capabilities
        if client.resolved_capabilities.document_formatting then
            buf_set_keymap("n", "<leader>fr", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        elseif client.resolved_capabilities.document_range_formatting then
            buf_set_keymap("n", "<leader>fr", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
        end

        -- Set autocommands conditional on server_capabilities
        if client.resolved_capabilities.document_highlight then
              vim.api.nvim_exec([[
                  hi LspReferenceRead cterm=bold ctermbg=red
                  hi LspReferenceText cterm=bold ctermbg=red
                  hi LspReferenceWrite cterm=bold ctermbg=red
                  augroup lsp_document_highlight
                  autocmd! * <buffer>
                  autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                  autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                  augroup END
                  ]], false)
        end

        vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border})
        vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border})
    end

    local function setup_servers()
        require'lspinstall'.setup()

        local servers = require'lspinstall'.installed_servers()

        for _, server in pairs(servers) do
            if server == "lua" then
                local luadev = require("lua-dev").setup({
                        library = {vimruntime = true, types = true, plugins = true},
                        lspconfig = {
                            capabilities = capabilities,
                            on_attach = on_attach,
                            settings = {
                                Lua = {
                                    runtime = {
                                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                                        version = 'LuaJIT',
                                        -- Setup your lua path
                                        path = vim.split(package.path, ';')
                                    },
                                    diagnostics = {
                                        globals = { 'vim' }
                                    },
                                    workspace = {
                                        -- Make the server aware of Neovim runtime files
                                        library = {
                                            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                                            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
                                        }
                                    }
                                }
                            },
                            flags = {
                                debounce_text_changes = 500,
                            },
                        },
                    })
                require'lspconfig'[server].setup(luadev)
            else
                require'lspconfig'[server].setup{
                    capabilities = capabilities,
                    on_attach = on_attach,
                }
            end
        end
    end

    setup_servers()

    -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
    require'lspinstall'.post_install_hook = function ()
        setup_servers() -- reload installed servers
        vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
    end

    -- symbols-outline.nvim
    vim.g.symbols_outline = {
        highlight_hovered_item = true,
        show_guides = true,
        auto_preview = false, -- experimental
        position = 'right',
        keymaps = {
            close = "<Esc>",
            goto_location = "<Cr>",
            focus_location = "o",
            hover_symbol = "<C-space>",
            rename_symbol = "r",
            code_actions = "a"
        },
        lsp_blacklist = {}
    }

    -- LSP Enable diagnostics
    vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = {
                prefix = "> ",
                spacing = 4,
            },
            underline = true,
            signs = false, -- rely on underlining
            update_in_insert = false,
        })

    -- Send diagnostics to quickfix list
    do
        local method = "textDocument/publishDiagnostics"
        local default_handler = vim.lsp.handlers[method]
        vim.lsp.handlers[method] = function(err, method, result, client_id, bufnr,
                config)
            default_handler(err, method, result, client_id, bufnr, config)
            local diagnostics = vim.lsp.diagnostic.get_all()
            local qflist = {}
            for bufnr, diagnostic in pairs(diagnostics) do
                for _, d in ipairs(diagnostic) do
                    d.bufnr = bufnr
                    d.lnum = d.range.start.line + 1
                    d.col = d.range.start.character + 1
                    d.text = d.message
                    table.insert(qflist, d)
                end
            end
            vim.lsp.util.set_qflist(qflist)
        end
    end
end

return M
