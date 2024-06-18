{ pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh.plugins = [
    {
      name = "base16-fzf";
      file = "sh/base16-onedark.sh";
      src = pkgs.fetchFromGitHub {
        owner = "tinted-theming";
        repo = "tinted-fzf";
        rev = "45180df6eb057c1891924a5145341ed1302c71ce"; # Apr, 7 2024
        hash = "sha256-AmvOZ+rtmxIDDndYPXXdgvP+l1sGmt/HYfyd88K8VXw=";
      };
    }
  ];
}
