{ dotfiles, user, ... }:

{
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      smb-secrets = {
        sopsFile = "${dotfiles}/secrets/smb-secrets";
        owner = "${user}";
        group = "wheel";
      };
    };
  };
}
