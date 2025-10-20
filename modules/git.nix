{ config, pkgs, vars, ... }:

let
  name = vars.name;
  email = vars.email;
in
{
  home.packages = with pkgs; [
    gh
    git-crypt
    hub
    tig
  ];

  # Export GitHub token
  home.sessionVariables = {
    GITHUB_TOKEN = "$(${pkgs.gh}/bin/gh auth token)";
  };

  # Alias git to hub
  programs.zsh.shellAliases.git = "hub";

  programs.git = {
    enable = true;
    package = pkgs.git; # install git tools
    lfs.enable = true; # install git-lfs
    ignores = import ./gitignores.nix;
    diff-highlight.enable = true;
    extraConfig = (import ./gitconfig.nix {
      inherit vars;
      signByDefault = true;
    });
  };
}
