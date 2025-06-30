{ dotfiles, ... }:

{
  programs.ssh = {
    enable = true;
    serverAliveInterval = 60;
    includes = [
      "~/.ssh/config.local"
      "~/.ssh/my_config"
    ];
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

  home.file.".ssh/my_config".source = "${dotfiles}/ssh/config";
}
