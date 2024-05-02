{ ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  xdg.configFile = {
    "nvim/lua" = {
      source = ../../nvim/lua;
      recursive = true;
    };
    "nvim/lazy-lock.json".source = ../../nvim/lazy-lock.json;
    "nvim/neoconf.json".source = ../../nvim/neoconf.json;
    "nvim/init.lua".source = ../../nvim/init.lua;
  };
}
