{
  description = "Ayman's Nix and NixOS dotfiles";

  inputs = {
    # We use the unstable nixpkgs repo
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Zsh Plugins
    tinted-shell = {
      url = "github:tinted-theming/tinted-shell";
      flake = false;
    };

    tinted-fzf = {
      url = "github:tinted-theming/tinted-fzf";
      flake = false;
    };

    zsh-vim-mode = {
      url = "github:softmoth/zsh-vim-mode";
      flake = false;
    };

    # NOTE: The following inputs will require your git SSH access to the repo.

    # Here we have my local dotfiles repo, which contains private
    # variables, configurations, and Sops secrets.
    # WARNING: You should remove or change this to your own dotfiles repo,
    # otherwise running this flake will not work.
    dotfiles = {
      url = "git+ssh://git@github.com/aymanbagabas/dotfiles.local?shallow=1";
      flake = false;
    };

    # WARNING: Do NOT pin the `nixpkgs` input, as that will
    # declare the cache useless. If you do, you will have
    # to compile LLVM, Zig and Ghostty itself on your machine,
    # which will take a very very long time.
    ghostty = {
      url = "git+ssh://git@github.com/mitchellh/ghostty";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, darwin, nur, ... }:
    let
      overlays = [
        nur.overlay
      ];

      mkSystem = import ./lib/mksystem.nix {
        inherit nixpkgs overlays inputs;
      };

      # Generate a list of systems based on their hostname
      mkSystems = list: builtins.listToAttrs (
        map (
          x: { name = x.hostname; value = mkSystem x; }
        ) list
      );

      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix;
      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system overlays;
      });

    in {
      nixosConfigurations = mkSystems [
        { hostname = "media"; system = "x86_64-linux"; isHeadless = true; }
        { hostname = "traffic"; system = "x86_64-linux"; isHeadless = true; }
        { hostname = "genericlxc"; system = "x86_64-linux"; isHeadless = true; }
      ];

      darwinConfigurations = mkSystems [
        { hostname = "spaceship"; system = "x86_64-darwin"; }
        { hostname = "blackhole"; system = "aarch64-darwin"; }
      ];

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShellNoCC {
            shellHook = ''
              # Use GitHub access tokens to avoid rate limiting
              export NIX_CONFIG="access-tokens = github=$(${pkgs.gh}/bin/gh auth token)"
            '';
            buildInputs = with pkgs; [
              (writeScriptBin "dot-release" ''
                git tag -m "$(date +%Y-%m-%d)" "$(date +%Y-%m-%d)"
                git push --tags
              '')
              (writeScriptBin "dot-update" ''
                nix flake update
                dot-apply
              '')
              (writeScriptBin "dot-sync" ''
                dot-update
                nix-collect-garbage -d
                dot-apply
              '')
              (writeScriptBin "dot-apply" ''
                case "$(uname -s)" in
                  Linux)
                    sudo nixos-rebuild switch --flake .#$HOST
                    ;;
                  Darwin)
                    HOST=$(hostname | cut -f1 -d'.')
                    nix run nix-darwin -- switch --flake .#$HOST
                    ;;
                  *)
                    echo "Unsupported OS"
                    exit 1
                    ;;
                esac
              '')
            ];
          };
        });
    };
}
