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

    # Vim Plugins
    copilot-lua = {
      url = "github:zbirenbaum/copilot.lua";
      # url = "github:aymanbagabas/copilot.lua/bin-path-no-download";
      # url = "git+file:///Users/ayman/Source/zbirenbaum/copilot.lua";
      flake = false;
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
      url = "git+ssh://git@github.com/aymanbagabas/dotfiles.local";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      darwin,
      nur,
      ...
    }:
    let
      overlays = [
        nur.overlays.default
        # This overlay overrides Vim plugins.
        (self: super: {
          vimPlugins = super.vimPlugins // {
            copilot-lua = super.vimPlugins.copilot-lua.overrideAttrs (oldAttrs: {
              src = inputs.copilot-lua;
            });
          };
        })
      ];

      mkSystem = import ./lib/mksystem.nix { inherit nixpkgs overlays inputs; };

      # Generate a list of systems based on their hostname
      mkSystems =
        list:
        builtins.listToAttrs (
          map (x: {
            name = x.hostname;
            value = mkSystem x;
          }) list
        );

      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system overlays; });

    in
    {
      nixosConfigurations = mkSystems [
        {
          hostname = "media";
          system = "x86_64-linux";
          isHeadless = true;
        }
        {
          hostname = "traffic";
          system = "x86_64-linux";
          isHeadless = true;
        }
        {
          hostname = "genericlxc";
          system = "x86_64-linux";
          isHeadless = true;
        }
        {
          hostname = "blackvm";
          system = "aarch64-linux";
        }
      ];

      darwinConfigurations = mkSystems [
        {
          hostname = "spaceship";
          system = "x86_64-darwin";
        }
        {
          hostname = "blackhole";
          system = "aarch64-darwin";
        }
      ];

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          gpg = pkgs.mkShellNoCC {
            buildInputs =
              with pkgs;
              [
                gnupg
              ]
              ++ (if pkgs.stdenv.isDarwin then [ pinentry_mac ] else [ pinentry-tty ])
              ++ [
                (writeScriptBin "dot-gpg-agent-config" ''
                  cat <<EOF
                  grab
                  enable-ssh-support
                  default-cache-ttl 31536000
                  default-cache-ttl-ssh 31536000
                  max-cache-ttl 31536000
                  max-cache-ttl-ssh 31536000
                  pinentry-program ${if pkgs.stdenv.isDarwin then pinentry_mac else pinentry-tty}/bin/${
                    if pkgs.stdenv.isDarwin then "pinentry-mac" else "pinentry-tty"
                  }
                  verbose
                  log-file $HOME/.gnupg/gpg-agent.log
                  EOF
                '')
              ];
          };
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
                dot-apply "$@"
              '')
              (writeScriptBin "dot-sync" ''
                dot-update
                nix-collect-garbage -d
                dot-apply "$@"
              '')
              (writeScriptBin "dot-apply" ''
                case "$(uname -s)" in
                  Linux)
                    sudo -E nixos-rebuild switch --flake .#$HOST "$@"
                    ;;
                  Darwin)
                    HOST=$(hostname | cut -f1 -d'.')
                    sudo -E nix run nix-darwin -- switch --flake .#$HOST "$@"
                    ;;
                  *)
                    echo "Unsupported OS"
                    exit 1
                    ;;
                esac
              '')
              (writeScriptBin "generate-nvim-plugins" ''
                # This script outputs a list of Neovim plugin repository URLs
                # based on the list defined in modules/neovim/plugins.nix.
                PLUGINS=(${builtins.concatStringsSep " " (map (p: p.meta.homepage) (import ./modules/neovim/plugins.nix { inherit pkgs; })) })

                echo "vim.pack.add({"
                for p in ''${PLUGINS[@]}; do
                  echo "  { src = \"$p\" },"
                done
                echo "})"
              '')
              (writeScriptBin "generate-gitconfig" ''
                # This script generates git configuration based on modules/gitconfig.nix
                cat <<EOF
                ${lib.generators.toGitINI (import ./modules/gitconfig.nix {
                  vars = import ./vars/default.nix;
                  signByDefault = false;
                })}
                EOF
              '')
              (writeScriptBin "generate-gitignores" ''
                # This script generates gitignore patterns based on modules/gitignores.nix
                cat <<EOF
                ${builtins.concatStringsSep "\n" (import ./modules/gitignores.nix) + "\n"}
                EOF
              '')
            ];
          };
        }
      );
    };
}
