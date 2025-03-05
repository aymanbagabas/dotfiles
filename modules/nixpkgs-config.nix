{
  allowUnfree = true;

  # Package licenses
  input-fonts.acceptLicense = true;

  # Allow nix-shell to use the NUR
  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };
}
