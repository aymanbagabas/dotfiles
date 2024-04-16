{ nixpkgs, overlays, inputs }:

{
  system,
  hostname,
  user,
  useGlobalPkgs ? true,
  useUserPkgs ? true,
  isHeadless ? false
}:


let
  isDarwin = nixpkgs.lib.strings.hasInfix "darwin" system;
  isLinux = nixpkgs.lib.strings.hasInfix "linux" system;
  systemFunc = if isDarwin then inputs.darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
  home-manager = if isDarwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
in systemFunc rec {
    inherit system;

    specialArgs = {
      inherit inputs overlays hostname isDarwin isLinux isHeadless;
      currentSystem = system;
    };
    modules = [
      { nixpkgs.overlays = overlays; }
      ../hosts/${hostname}
      home-manager.home-manager {
        home-manager.useGlobalPkgs = useGlobalPkgs;
        home-manager.useUserPackages = useUserPkgs;
        home-manager.users.${user} = import ../users/${user}/home.nix;
        home-manager.extraSpecialArgs = specialArgs;
      }
    ];
  }
