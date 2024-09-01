{ dotfiles, ... }:

{
  programs.ssh = {
    enable = true;
    serverAliveInterval = 60;
    includes = [ "~/.ssh/config.local" ];
    addKeysToAgent = "yes";
    matchBlocks = {
      "*" = {
        identityFile = "~/.ssh/id";
        extraOptions = {
          UseKeyChain = "yes";
          IgnoreUnknown = "UseKeychain";
        };
      };
      "localhost" = {
        extraOptions = {
          UserKnownHostsFile = "/dev/null";
          StrictHostKeyChecking = "false";
        };
      };
    };
  };

  home.file."~/.ssh/config.local".source = "${dotfiles}/ssh/config";
}
