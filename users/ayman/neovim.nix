{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      # LazyVim list of plugins (keep up-to-date!)
      LazyVim
      # luasnip
      SchemaStore-nvim
      aerial-nvim
      barbecue-nvim
      bufferline-nvim
      catppuccin-nvim
      clangd_extensions-nvim
      cmp-buffer
      cmp-emoji
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      conform-nvim
      copilot-cmp
      copilot-lua
      dashboard-nvim
      dressing-nvim
      flash-nvim
      friendly-snippets
      fugitive-gitlab-vim
      gitsigns-nvim
      headlines-nvim
      indent-blankline-nvim
      lazy-nvim
      lualine-nvim
      markdown-preview-nvim
      mason-lspconfig-nvim
      mason-nvim
      mini-nvim
      neo-tree-nvim
      neoconf-nvim
      neodev-nvim
      noice-nvim
      none-ls-nvim
      nui-nvim
      base16-nvim
      nvim-cmp
      nvim-colorizer-lua
      nvim-lint
      nvim-lspconfig
      nvim-navic
      nvim-notify
      vim-numbertoggle
      nvim-osc52
      nvim-spectre
      nvim-surround
      vim-tmux-navigator
      nvim-treesitter
      nvim-treesitter-context
      nvim-treesitter-endwise
      nvim-treesitter-textobjects
      nvim-ts-autotag
      nvim-ts-context-commentstring
      nvim-web-devicons
      oil-nvim
      onedark-nvim
      other-nvim
      persistence-nvim
      plenary-nvim
      project-nvim
      sleuth
      # srht-vim # TODO: install this
      telescope-fzf-native-nvim
      telescope-nvim
      # telescope-terraform-doc-nvim # TODO: install this
      # telescope-terraform-nvim
      todo-comments-nvim
      tokyonight-nvim
      trouble-nvim
      twilight-nvim
      undotree
      vim-abolish
      vim-fubitive
      vim-fugitive
      vim-gnupg
      vim-illuminate
      vim-rhubarb
      vim-speeddating
      vim-startuptime
      vim-unimpaired
      which-key-nvim
      zen-mode-nvim

      (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins:
        with plugins; [
          arduino
          awk
          bash
          c
          cpp
          css
          diff
          dockerfile
          git_config
          git_rebase
          gitattributes
          gitcommit
          gitignore
          go
          gomod
          gosum
          gowork
          hcl
          html
          ini
          javascript
          json
          jsonc
          lua
          nix
          python
          regex
          rust
          scss
          sql
          ssh_config
          terraform
          toml
          typescript
          vim
          vimdoc
          yaml
        ]
      ))
    ];
  };

  home.packages = with pkgs; with pkgs.nodePackages_latest; with pkgs.python311Packages; [
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
    hadolint
    impl
    jedi-language-server
    ltex-ls
    lua-language-server
    markdownlint-cli2
    marksman
    nixd
    prettier
    revive
    rust-analyzer
    shellcheck
    shfmt
    stylua
    terraform-ls
    typescript-language-server
    vscode-html-languageserver-bin
    vscode-json-languageserver-bin
    yaml-language-server
  ];

  xdg.configFile = {
    "nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim/lua";
    # "nvim/lazy-lock.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim/lazy-lock.json"; # Do we need to keep track of this?
    "nvim/neoconf.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim/neoconf.json";
    "nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim/init.lua";
  };
}
