{ vars, signByDefault, ... }:
{
  alias = {
    fixes = "log --pretty='format:Fixes: %h (%s)'";
    authors = "log --date='format:%Y' --pretty='format:%ad %an <%ae>'";
    graph = "log --graph --all --decorate --oneline";
    purge-tags = "!git tag -l | xargs git tag -d && git fetch -t";
    wipeout = "!git branch | sed 's/^[*]* *//' | gum choose --no-limit --header 'Wipeout which branches?' | xargs git branch -D";
  };
  user = {
    name = vars.name;
    email = vars.email;
    signingkey = vars.pgp.defaultKey;
  };
  core = {
    editor = "nvim";
    abbrev = 12;
    autocrlf = false;
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
    user = vars.github.username;
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
  commit = {
    gpgSign = signByDefault;
  };
  tag = {
    sort = "version:refname";
    gpgSign = signByDefault;
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
    smtpUser = "${vars.email}";
    smtpAuth = "OAUTHBEARER";
    from = "${vars.name} <${vars.email}>";
  };
  credential = {
    "smtp://smtp.gmail.com:587" = {
      helper = [
        ""
        "gmail"
      ];
    };
  };
}
