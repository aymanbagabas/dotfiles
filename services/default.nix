{ ... }:

{
  disabledModules = [
    "services/web-apps/calibre-web.nix"
    "services/misc/bazarr.nix"
    "services/misc/calibre-server.nix"
    "services/misc/prowlarr.nix"
  ];

  imports =
    [ ./bazarr.nix ./calibre-server.nix ./calibre-web.nix ./prowlarr.nix ];
}
