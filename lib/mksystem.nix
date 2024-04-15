{ nixpkgs, overlays, inputs }:

{
  system,
  hostname,
  user,
  useGlobalPkgs ? true,
  useUserPkgs ? true
}:


let
  isDarwin = nixpkgs.lib.strings.hasInfix "darwin" system;
  systemFunc = if isDarwin then inputs.darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
  home-manager = if isDarwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
in systemFunc {
    inherit system;

    specialArgs = {
      inherit inputs overlays hostname;
    };
    modules = [
      { nixpkgs.overlays = overlays; }
      ../hosts/${hostname}
      home-manager.home-manager {
        home-manager.useGlobalPkgs = useGlobalPkgs;
        home-manager.useUserPackages = useUserPkgs;
        home-manager.users.${user} = import ../users/${user}/home.nix;
        home-manager.extraSpecialArgs = {
            inherit inputs overlays hostname;
        };
      }
    ];
  }
