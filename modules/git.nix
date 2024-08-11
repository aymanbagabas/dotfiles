{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gh
    git-crypt
    hub
    tig
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitFull; # install git tools
    lfs.enable = true; # install git-lfs
    userName = "Ayman Bagabas";
    userEmail = "ayman.bagabas@gmail.com";
    signing = {
      key = config.programs.gpg.settings.default-key;
      signByDefault = true;
    };
    ignores = [
      # Node
      ".node_modules"
      "npm-debug.log"
      # Mac
      ".DS_Store"
      # Windows
      "Thumbs.db"
      # WebStorm
      ".idea/"
      # vi
      "*~"
      # General
      "*.log"
      # VSCode
      ".vscode"
      # (Neo)vim
      ".nvim"
    ];
    aliases = {
      fixes = "log --pretty='format:Fixes: %h (%s)'";
      authors = "log --date='format:%Y' --pretty='format:%ad %an <%ae>'";
      graph = "log --graph --all --decorate --oneline";
      purge-tags = "!git tag -l | xargs git tag -d && git fetch -t";
    };
    extraConfig = {
      core = {
        editor = "nvim";
        abbrev = 12;
        # quotePath = false; # Do I need this?
      };
      pull.rebase = false;
      init.defaultBranch = "master";
      format.signOff = true;
      rerere.enabled = true;
      github = {
        user = "aymanbagabas";
      };
      hub = {
        protocol = "ssh";
      };
      color = {
        ui = true;
        diff = {
          meta = "yellow";
          frag = "magenta bold";
          old = "red bold";
          new = "green bold";
          whitespace = "red reverse";
        };
        diff-highlight = {
          oldNormal = "red bold";
          oldHighlight = "red bold 52";
          newNormal = "green bold";
          newHighlight = "green bold 22";
        };
      };
      tig = {
        mouse = true;
        mouse-wheel-cursor = true;
        color = {
          cursor = "black green bold";
          title-blur = "black blue";
          title-focus = "black blue bold";
        };
      };
      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };
    };
  };
}
