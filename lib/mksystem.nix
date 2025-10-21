{
  nixpkgs,
  overlays,
  inputs,
}:

{
  system,
  hostname,
  user ? "ayman",
  useGlobalPkgs ? true,
  useUserPkgs ? true,
  isHeadless ? false,
}:

let
  lib = nixpkgs.lib;
  isDarwin = lib.strings.hasInfix "darwin" system;
  isLinux = lib.strings.hasInfix "linux" system;
  systemFunc = if isDarwin then inputs.darwin.lib.darwinSystem else lib.nixosSystem;
  home-manager =
    if isDarwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
  vars = import ../vars;
in
systemFunc rec {
  inherit system;

  specialArgs = inputs // {
    inherit
      overlays
      hostname
      user
      isDarwin
      isLinux
      isHeadless
      vars
      ;
  };
  modules =
    [
      { nixpkgs.overlays = overlays; }
      ../hosts/${hostname}/configuration.nix
      home-manager.home-manager
      {
        home-manager.useGlobalPkgs = useGlobalPkgs;
        home-manager.useUserPackages = useUserPkgs;
        home-manager.users.${user} = import ../hosts/${hostname}/home.nix;
        home-manager.extraSpecialArgs = specialArgs;
      }
    ]
    ++ (lib.optionals isLinux [
      inputs.disko.nixosModules.disko
      inputs.sops-nix.nixosModules.sops # Darwin doesn't support sops-nix yet
      inputs.compose2nix.nixosModules.compose2nix
    ]);
}
