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
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
