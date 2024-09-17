{ pkgs, ... }:

{
  home.packages = with pkgs; [ tmux ];

  # Home Manager inserts settings we don't want, so just symlink our config.
  home.file.".tmux.conf".source = ./tmux.conf;
}
