{ ... }:
{
  imports = [
    ./convertx.nix
    ./searcharr.nix
    ./watchtower.nix
  ];

  virtualisation.oci-containers = {
    # Use docker as a backend.
    backend = "docker";
  };
}
