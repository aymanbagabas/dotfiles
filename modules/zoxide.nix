{ ... }:

{
  programs.zoxide = {
    enable = true;
    # Fixes https://github.com/ajeetdsouza/zoxide/issues/565
    options = [ "--no-cmd" ];
  };

  programs.zsh = {
    initContent = ''
      # Fixes https://github.com/ajeetdsouza/zoxide/issues/565
      function z() {
          __zoxide_z "$@"
      }
    '';
    shellAliases = {
      cd = "z";
    };
  };
}
