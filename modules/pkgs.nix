{
  pkgs,
  dotfiles,
  ghostty,
  isLinux,
  isHeadless,
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
      gnused
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
      awscli2
      graphviz
      gum
      mods
      nodejs
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
      terraform
      yarn

      # DevOps
      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    ]
    ++ (lib.optionals (!isHeadless && isLinux) [
      _1password-gui
      alacritty
      discord
      ghostty.packages.${lib.system}.default # Ghostty is only available on Linux
      kitty
      slack
      spotify
      tailscale # We use Homebrew for macOS
      telegram-desktop
      wezterm
    ]);

  home.sessionVariables = {
    # tz timezone list
    TZ_LIST = builtins.readFile "${dotfiles}/vars/tz_list";
  };

  home.shellAliases = {
    tf = "terraform";
  };
}
