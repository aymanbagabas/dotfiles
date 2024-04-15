{ ... }:

{
  programs.eza = {
    enable = true;
  };

  programs.zsh.shellAliases = {
    ls = "eza";
    ll = "eza -lh";
    la = "eza -lah";
    tree = "eza --tree";
  };
}
