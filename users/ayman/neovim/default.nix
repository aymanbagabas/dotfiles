{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;

    plugins = with pkgs.vimPlugins; [

      # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins
      # plugins from nixpkgs go in here.
      SchemaStore-nvim
      barbecue-nvim
      bufferline-nvim
      clangd_extensions-nvim
      cmp-buffer # current buffer as completion source | https://github.com/hrsh7th/cmp-buffer/
      cmp-cmdline # cmp command line suggestions
      cmp-cmdline-history # cmp command line history suggestions
      cmp-emoji
      cmp-nvim-lsp # LSP as completion source | https://github.com/hrsh7th/cmp-nvim-lsp/
      cmp-nvim-lua # neovim lua API as completion source | https://github.com/hrsh7th/cmp-nvim-lua/
      cmp-path # file paths as completion source | https://github.com/hrsh7th/cmp-path/
      cmp_luasnip # snippets autocompletion extension for nvim-cmp | https://github.com/saadparwaiz1/cmp_luasnip/
      conform-nvim
      copilot-cmp
      copilot-lua
      dashboard-nvim
      dressing-nvim
      friendly-snippets
      fugitive-gitlab-vim
      gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/
      headlines-nvim
      hmts-nvim
      indent-blankline-nvim
      lspkind-nvim # vscode-like LSP pictograms | https://github.com/onsails/lspkind.nvim/
      lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/
      markdown-preview-nvim
      mini-nvim
      neo-tree-nvim
      neoconf-nvim
      neodev-nvim
      noice-nvim
      nui-nvim
      nvim-cmp # https://github.com/hrsh7th/nvim-cmp
      nvim-colorizer-lua
      nvim-lspconfig
      nvim-navic # Add LSP location to lualine | https://github.com/SmiteshP/nvim-navic
      nvim-notify
      nvim-snippets
      nvim-spectre
      nvim-surround # https://github.com/kylechui/nvim-surround/
      nvim-treesitter-context # nvim-treesitter-context
      nvim-treesitter-endwise
      nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
      nvim-treesitter.withAllGrammars
      nvim-ts-autotag
      nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/
      nvim-web-devicons
      onedark-nvim
      plenary-nvim
      project-nvim
      telescope-fzf-native-nvim
      telescope-nvim # https://github.com/nvim-telescope/telescope.nvim/
      todo-comments-nvim
      trouble-nvim
      ts-comments-nvim
      undotree
      vim-abolish
      vim-fubitive
      vim-fugitive # https://github.com/tpope/vim-fugitive/
      vim-gnupg
      vim-illuminate
      vim-repeat
      vim-rhubarb
      vim-sleuth
      vim-speeddating
      vim-startuptime
      vim-tmux-navigator
      vim-unimpaired # predefined ] and [ navigation keymaps | https://github.com/tpope/vim-unimpaired/
      vim-vinegar
      which-key-nvim
      zen-mode-nvim
    ];

    extraPackages = with pkgs; with pkgs.nodePackages_latest; [
      # Fixes nvim-spectre "gsed" error https://github.com/nvim-pack/nvim-spectre/issues/101
      gnused
      (writeShellScriptBin "gsed" "exec ${gnused}/bin/sed \"$@\"")

      actionlint
      bash-language-server
      clang-tools
      delve
      docker-compose-language-service
      dockerfile-language-server-nodejs
      go-tools
      gofumpt
      golangci-lint
      golangci-lint-langserver
      gomodifytags
      gopls
      gotests
      gotools
      hadolint
      impl
      ltex-ls
      lua-language-server
      markdownlint-cli2
      marksman
      nil # nix LSP
      nixd
      prettier
      revive
      rust-analyzer
      shellcheck
      shfmt
      stylua
      terraform-ls
      typescript-language-server
      vscode-langservers-extracted
      yaml-language-server
    ];

    extraPython3Packages = ps: [
      ps.python-lsp-server
    ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
