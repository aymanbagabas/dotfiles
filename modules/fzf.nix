{ tinted-fzf, ... }:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh.plugins = [{
    name = "tinted-fzf";
    file = "sh/base16-onedark.sh";
    src = tinted-fzf;
  }];

  home.sessionVariables = {
    FZF_DEFAULT_COMMAND =
      "rg --files --hidden --no-ignore-vcs --glob '!.git/*'";
  };
}
