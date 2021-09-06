local M = {}

M.setup = function ()

    -- lspkind-nvim
    local lspkind = require('lspkind')
    lspkind.init({
        -- enables text annotations
        --
        -- default: true
        with_text = true,

        -- default symbol map
        -- can be either 'default' (requires nerd-fonts font) or
        -- 'codicons' for codicon preset (requires vscode-codicons font)
        --
        -- default: 'default'
        preset = 'codicons',

        -- override preset symbols
        --
        -- default: {}
        symbol_map = {
            Text = "",
            Method = "",
            Function = "",
            Constructor = "",
            Field = "ﰠ",
            Variable = "",
            Class = "ﴯ",
            Interface = "",
            Module = "",
            Property = "ﰠ",
            Unit = "塞",
            Value = "",
            Enum = "",
            Keyword = "",
            Snippet = "",
            Color = "",
            File = "",
            Reference = "",
            Folder = "",
            EnumMember = "",
            Constant = "",
            Struct = "פּ",
            Event = "",
            Operator = "",
            TypeParameter = ""
        },
    })

    local cmp = require'cmp'

    local check_back_space = function()
        local col = vim.fn.col('.') - 1
        if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
            return true
        else
            return false
        end
    end

    cmp.setup({
        completion = {
            completeopt = 'menuone,noselect',
        },
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end,
        },
        mapping = {
            ['<C-y>'] = cmp.mapping.confirm({ select = true }),
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            }),
            ['<Tab>'] = cmp.mapping(function(fallback)
                if vim.fn.pumvisible() == 1 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
                elseif vim.fn['vsnip#available']() == 1 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-expand-or-jump)', true, true, true), '')
                elseif check_back_space() then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n')
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function()
                if vim.fn.pumvisible() == 1 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
                elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-jump-prev)', true, true, true), '')
                end
            end, { 'i', 's' }),
        },
        sources = {
            { name = 'path' },
            {
                name = "buffer",
                opts = {
                    get_bufnrs = function()
                        local bufs = {}
                        for _, win in ipairs(vim.api.nvim_list_wins()) do
                            bufs[vim.api.nvim_win_get_buf(win)] = true
                        end
                        return vim.tbl_keys(bufs)
                    end,
                },
            },
            { name = 'calc' },
            { name = 'vsnip' },
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'spell' },
            { name = 'tags' },
            { name = 'emoji' },
            { name = 'treesitter' }, -- todo install
            { name = 'snippets_nvim' }, -- todo install
        },
        formatting = {
            format = function(_, vim_item)
                vim_item.kind = lspkind.presets.default[vim_item.kind]
                return vim_item
            end
        }
    })

    -- local t = function(str)
        --   return vim.api.nvim_replace_termcodes(str, true, true, true)
        -- end

        -- -- Use (s-)tab to:
        -- --- move to prev/next item in completion menuone
        -- --- jump to prev/next snippet's placeholder
        -- _G.tab_complete = function()
            --   if vim.fn.pumvisible() == 1 then
            --     return t "<C-n>"
            --   elseif vim.fn['vsnip#available'](1) == 1 then
            --     return t "<Plug>(vsnip-expand-or-jump)"
            --   elseif check_back_space() then
            --     return t "<Tab>"
            --   else
            --     return vim.fn['compe#complete']()
            --   end
            -- end
            -- _G.s_tab_complete = function()
                --   if vim.fn.pumvisible() == 1 then
                --     return t "<C-p>"
                --   elseif vim.fn['vsnip#jumpable'](-1) == 1 then
                --     return t "<Plug>(vsnip-jump-prev)"
                --   else
                --     -- If <S-Tab> is not working in your terminal, change it to <C-h>
                --     return t "<S-Tab>"
                --   end
                -- end

                -- vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
                -- vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
                -- vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
                -- vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
            end

return M
