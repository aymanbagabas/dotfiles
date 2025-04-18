{
  config,
  pkgs,
  isDarwin,
  ...
}:

let
  lib = pkgs.lib;
in
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
      avante-nvim
      blink-cmp
      blink-emoji-nvim
      bufferline-nvim
      clangd_extensions-nvim
      conflict-marker-vim
      conform-nvim
      copilot-lua
      dashboard-nvim
      dressing-nvim
      dropbar-nvim
      friendly-snippets
      fugitive-gitlab-vim
      git-conflict-nvim
      gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/
      hmts-nvim
      img-clip-nvim
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
      nvim-colorizer-lua
      nvim-lspconfig
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
      render-markdown-nvim
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

    extraPackages =
      with pkgs;
      with pkgs.nodePackages_latest;
      [
        actionlint
        bash-language-server
        clang-tools
        copilot-language-server
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
        nixfmt-rfc-style
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
        zls
      ]
      ++ (lib.optionals isDarwin [
        # Fixes nvim-spectre "gsed" error https://github.com/nvim-pack/nvim-spectre/issues/101
        (writeShellScriptBin "gsed" ''exec ${gnused}/bin/sed "$@"'')
      ]);

    extraPython3Packages = ps: [ ps.python-lsp-server ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
