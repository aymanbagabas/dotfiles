{ dotfiles, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [
      "~/.ssh/config.local"
      "~/.ssh/my_config"
    ];
    matchBlocks = {
      "*" = {
        serverAliveInterval = 60;
        addKeysToAgent = "yes";
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
