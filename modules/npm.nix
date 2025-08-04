{ config, ... }:

{
  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm-global
    //registry.npmjs.org/:_authToken=''${NPMJS_TOKEN}
  '';
}
