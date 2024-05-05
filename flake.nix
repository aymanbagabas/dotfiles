{
  description = "Ayman's Nix and NixOS dotfiles";

  inputs = {
    # We use the unstable nixpkgs repo
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # NOTE: This will require your git SSH access to the repo.
    #
    # WARNING: Do NOT pin the `nixpkgs` input, as that will
    # declare the cache useless. If you do, you will have
    # to compile LLVM, Zig and Ghostty itself on your machine,
    # which will take a very very long time.
    ghostty = {
      url = "git+ssh://git@github.com/mitchellh/ghostty";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, darwin, ... }:
    let
      overlays = [];

      mkSystem = import ./lib/mksystem.nix {
        inherit nixpkgs overlays inputs;
      };

      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix;
      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system overlays;
      });

    in {
      darwinConfigurations.Spaceship = mkSystem {
        system = "x86_64-darwin";
        hostname = "Spaceship";
        user = "ayman";
      };

      darwinConfigurations.Blackhole = mkSystem {
        system = "aarch64-darwin";
        hostname = "Blackhole";
        user = "ayman";
      };

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShellNoCC {
            buildInputs = with pkgs; [
              # (writeScriptBin "dot-release" ''
              #   git tag -m "$(date +%Y.%m.%d)" "$(date +%Y.%m.%d)"
              #   git push --tags
              #   goreleaser release --clean
              # '')
              (writeScriptBin "dot-sync" ''
                git pull --rebase origin main
                nix flake update
                dot-apply
                nix-collect-garbage -d
                dot-apply
              '')
              (writeScriptBin "dot-apply" ''
                if test $(uname -s) == "Linux"; then
                  sudo nixos-rebuild switch --flake .#
                fi
                if test $(uname -s) == "Darwin"; then
                  HOST=$(hostname | cut -f1 -d'.')
                  nix build ".#darwinConfigurations.$HOST.system"
                  ./result/sw/bin/darwin-rebuild switch --flake .#$HOST
                fi
              '')
            ];
          };
        });
    };
}
