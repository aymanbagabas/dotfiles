{ config, pkgs, ... }:

let
  name = "Ayman Bagabas";
  email = "ayman.bagabas@gmail.com";
in
{
  home.packages = with pkgs; [
    gh
    git-crypt
    hub
    tig
  ];

  # Export GitHub token
  home.sessionVariables = {
    GITHUB_TOKEN = "$(${pkgs.gh}/bin/gh auth token)";
  };

  # Alias git to hub
  programs.zsh.shellAliases.git = "hub";

  programs.git = {
    enable = true;
    package = pkgs.git; # install git tools
    lfs.enable = true; # install git-lfs
    userName = "${name}";
    userEmail = "${email}";
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
    diff-highlight.enable = true;
    extraConfig = {
      core = {
        editor = "nvim";
        abbrev = 12;
        # quotePath = false; # Do I need this?
      };
      pull.rebase = false;
      init.defaultBranch = "master";
      format.signOff = true;
      rerere = {
        enabled = true;
        autoupdate = true;
      };
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
      column = {
        ui = "auto";
      };
      branch = {
        sort = "-committerdate";
      };
      tag = {
        sort = "version:refname";
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        renames = true;
        mnemonicPrefix = true;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      fetch = {
        prune = true;
        all = true;
      };
      help = {
        autocorrect = "prompt";
      };
      rebase = {
        autoStash = true;
        autoSquash = true;
      };
      # This uses git-credential-email from
      # https://github.com/AdityaGarg8/git-credential-email
      sendemail = {
        smtpServer = "smtp.gmail.com";
        smtpServerPort = "587";
        smtpEncryption = "tls";
        smtpUser = "${email}";
        smtpAuth = "OAUTHBEARER";
        from = "${name} <${email}>";
      };
      credential = {
        "smtp://smtp.gmail.com:587" = {
          helper = [
            ""
            "gmail"
          ];
        };
      };
    };
  };
}
