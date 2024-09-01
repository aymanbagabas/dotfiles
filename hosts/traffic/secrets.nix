{ dotfiles, user, ... }:

{
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      cert = {
        sopsFile = "${dotfiles}/secrets/cert.env";
        format = "dotenv";
        owner = "${user}";
        group = "wheel";
      };
    };
  };
}
