{
  pkgs,
  dotfiles,
  isLinux,
  isHeadless,
  isDarwin,
  ...
}:

let
  inherit (pkgs) lib;
in
{
  home.packages =
    with pkgs;
    with pkgs.nodePackages_latest;
    [
      _1password-cli
      age
      curl
      fd
      fortune
      htop
      jq
      p7zip
      ripgrep
      tz
      wget
      yarn
      zoxide

      # Fonts
      inconsolata-lgc
      input-fonts
      jetbrains-mono
      nerd-fonts.symbols-only

      # Dev tools
      (pkgs.writeScriptBin "svu" ''
        #!/usr/bin/env bash
        root=$(git rev-parse --show-toplevel)
        if [ "$PWD" != "$root" ]; then
          prefix=$(echo -n "$PWD" | sed "s|$root/||g")
          ${pkgs.svu}/bin/svu --tag.prefix="$prefix/v" --tag.pattern="$prefix/*" "$@"
        else
          ${pkgs.svu}/bin/svu "$@"
        fi
      '')

      actionlint
      awscli2
      bash-language-server
      cargo
      clang-tools
      cmake
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
      graphviz
      gum
      hadolint
      helm-ls
      impl
      jdt-language-server
      ltex-ls
      lua-language-server
      markdownlint-cli2
      marksman
      mods
      nil # nix LSP
      nixfmt-rfc-style
      nodejs
      prettier
      python313Packages.python-lsp-server
      revive
      rust-analyzer
      rustc
      rustfmt
      shellcheck
      shfmt
      stylua
      templ
      terraform
      terraform-ls
      tflint
      typescript-language-server
      vscode-langservers-extracted
      yaml-language-server
      yarn
      zls

      # DevOps
      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    ]
      ++ (lib.optionals isDarwin [
        # Fixes nvim-spectre "gsed" error https://github.com/nvim-pack/nvim-spectre/issues/101
        (writeShellScriptBin "gsed" ''exec ${gnused}/bin/sed "$@"'')
      ])
    ++ (
      lib.optionals (!isHeadless && isLinux) [
        _1password-gui
        alacritty
        ghostty
        kitty
        spotify
        tailscale # We use Homebrew for macOS
        telegram-desktop
        wezterm
      ]
      ++ (lib.optionals (!lib.strings.hasPrefix "aarch64" pkgs.system) [
        # GUI apps that don't work on arm64
        discord
        slack
      ])
    );

  home.sessionVariables = {
    # tz timezone list
    TZ_LIST = builtins.readFile "${dotfiles}/vars/tz_list";
  };

  home.shellAliases = {
    tf = "terraform";
  };
}
