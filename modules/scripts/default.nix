{ pkgs, ... }:

let
  inherit (builtins) readDir;
  inherit (pkgs.lib) filterAttrs mapAttrs' nameValuePair hasSuffix;

  files = filterAttrs (name: value: value == "regular" && ! hasSuffix ".nix" name)
  (readDir ./.);

  scripts = mapAttrs' (name: _:
      nameValuePair ".local/bin/${name}" { source = ./${name}; }
  ) files;
in
{
    home.file = scripts;
}
