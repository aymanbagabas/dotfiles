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

    plugins = import ./plugins.nix { inherit pkgs; };

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
        dockerfile-language-server
        go-tools
        gofumpt
        golangci-lint
        golangci-lint-langserver
        gomodifytags
        gopls
        gotests
        gotools
        hadolint
        helm-ls
        impl
        jdt-language-server
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
        tflint
        typescript-language-server
        vscode-langservers-extracted
        yaml-language-server
        zls
      ];

    extraPython3Packages = ps: [ ps.python-lsp-server ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
