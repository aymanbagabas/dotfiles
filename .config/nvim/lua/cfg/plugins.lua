local fn = vim.fn

local install_path = ("%s/site/pack/packer-lib/opt/packer.nvim"):format(fn.stdpath "data")

local function install_packer()
    vim.fn.termopen(("git clone https://github.com/wbthomason/packer.nvim %q"):format(install_path))
end

if fn.empty(fn.glob(install_path)) > 0 then
    install_packer()
end

vim.cmd [[packadd packer.nvim]]
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

function _G.packer_upgrade()
    vim.fn.delete(install_path, "rf")
    install_packer()
end

vim.cmd [[command! PackerUpgrade :call v:lua.packer_upgrade()]]

return require("packer").startup(function(use, _)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- tpope
    use "tpope/vim-surround"
    use "tpope/vim-repeat"
    use "tpope/vim-commentary"
    use "tpope/vim-unimpaired"
    use "tpope/vim-rsi"
    use {
        "tpope/vim-sleuth",
        setup = function ()
            vim.g.sleuth_automatic = 0
        end
    }
    use {
        "tpope/vim-dispatch",
        requires = { "radenling/vim-dispatch-neovim" },
    }
    use { 'tpope/vim-fugitive' }
    use "tpope/vim-characterize"

    -- extensions
    use {
        "907th/vim-auto-save",
        config = function ()
            vim.g.auto_save = 1
        end
    }
    use {
        "windwp/nvim-autopairs",
        config = function ()
            require("cfg.autopairs").setup()
        end
    }
    use "simrat39/symbols-outline.nvim"
    use "alvan/vim-closetag"
    use "tweekmonster/startuptime.vim"
    use "rhysd/git-messenger.vim"
    use "mhinz/vim-startify"
    use "editorconfig/editorconfig-vim"
    use {
        "kyazdani42/nvim-tree.lua",
        config = function ()
            require("cfg.tree").setup()
        end
    }
    -- statusline and ui
    use {
        "glepnir/galaxyline.nvim",
        requires = {
            "ryanoasis/vim-devicons",
            "kyazdani42/nvim-web-devicons",
        },
        config = function ()
            require("cfg.statusline").setup()
        end

    }
    use {
        "akinsho/nvim-bufferline.lua",
        config = function ()
            require("cfg.bufferline").setup()
        end
    }
    use {
        "christianchiarulli/nvcode-color-schemes.vim",
    }
    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            vim.g.indent_blankline_use_treesitter = true
            vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
            vim.g.indent_blankline_filetype_exclude = { "help", "packer" }
            vim.g.indent_blankline_char = "▏"
            vim.cmd [[set colorcolumn=99999]]
        end,
    }
    use {
        "sheerun/vim-polyglot",
        setup = function()
            vim.g.polyglot_disabled = { "autoindent", "sensible" }
        end,
    }

    -- telescope
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/popup.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-media-files.nvim",
        },
        config = function ()
            require("cfg.telescope").setup()
        end
    }

    -- lsp and comp
    use {
        "sbdchd/neoformat",
        config = function ()
            vim.api.nvim_set_keymap("n", "<Leader>fm", [[<Cmd> Neoformat<CR>]], {noremap = true, silent = true})
        end
    }
    use "folke/lua-dev.nvim"
    use {
        "kabouzeid/nvim-lspinstall",
        requires = {
            "neovim/nvim-lspconfig",
        }
    }
    use "ray-x/lsp_signature.nvim"
    use "RRethy/vim-illuminate"
    use "onsails/lspkind-nvim"
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/vim-vsnip",
            "hrsh7th/vim-vsnip-integ",
            "hrsh7th/cmp-vsnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-calc",
            "hrsh7th/cmp-emoji",
            "f3fora/cmp-spell",
            "quangnguyen30192/cmp-nvim-tags",
        },
        config = function ()
            require("cfg.comp").setup()
        end,
    }

    -- signcolumn
    use {
        "lewis6991/gitsigns.nvim",
        requires = {
            "nvim-lua/plenary.nvim"
        },
        config = function ()
            require("cfg.gitsigns").setup()
        end
    }

    -- which key?
    use {
        'folke/which-key.nvim',
        config = function ()
            require("cfg.whichkey").setup()
        end
    }

    -- colorizer
    use {
        "norcalli/nvim-colorizer.lua",
        config = function ()
            require("cfg.nvim-colorizer").setup()
        end
    }

    -- treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function ()
            require("cfg.treesitter").setup()
        end,
    }
    use {
        "windwp/nvim-ts-autotag",
        ft = { "html", "javascript", "javascriptreact", "typescriptreact", "svelte", "vue" },
    }
    use 'JoosepAlviste/nvim-ts-context-commentstring'

    -- kitty
    use "fladson/vim-kitty"
    use {
        'knubie/vim-kitty-navigator',
        run = 'cp ./*.py ~/.config/kitty/',
        setup = function ()
            vim.g.kitty_navigator_no_mappings = 1
        end
    }
end)
