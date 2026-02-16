{
  config,
  pkgs,
  tinted-shell,
  zsh-vim-mode,
  ...
}:

with pkgs.lib;

let
  inherit (pkgs.stdenv) isLinux;
in
{
  home.packages = with pkgs; [ pure-prompt ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = true;
    dotDir = config.home.homeDirectory;

    plugins =
      [
        {
          name = "pure-prompt";
          file = "share/zsh/site-functions/async";
          src = pkgs.pure-prompt;
        }
        {
          name = "pure-prompt";
          file = "share/zsh/site-functions/prompt_pure_setup";
          src = pkgs.pure-prompt;
        }
        {
          name = "omzl-key-bindings";
          file = "share/oh-my-zsh/lib/key-bindings.zsh";
          src = pkgs.oh-my-zsh;
        }
        {
          name = "omzl-completion";
          file = "share/oh-my-zsh/lib/completion.zsh";
          src = pkgs.oh-my-zsh;
        }
        {
          name = "omzl-theme-and-appearance";
          file = "share/oh-my-zsh/lib/theme-and-appearance.zsh";
          src = pkgs.oh-my-zsh;
        }
        {
          name = "omzp-git";
          file = "share/oh-my-zsh/plugins/git/git.plugin.zsh";
          src = pkgs.oh-my-zsh;
        }
        {
          name = "zsh-vim-mode";
          file = "zsh-vim-mode.plugin.zsh";
          src = zsh-vim-mode;
        }
        {
          name = "zsh-completions";
          file = "share/zsh-completions/zsh-completions.plugin.zsh";
          src = pkgs.zsh-completions;
        }
        {
          name = "tinted-shell";
          file = "base16-shell.plugin.zsh";
          src = tinted-shell;
        }
      ]
      ++ (optionals isLinux [
        {
          name = "omzp-systemd";
          file = "share/oh-my-zsh/plugins/systemd/systemd.plugin.zsh";
          src = pkgs.oh-my-zsh;
        }
      ]);

    sessionVariables = {
      # Set the base16 theme (needs tinted-shell).
      BASE16_THEME = "onedark";
      BASE24_THEME = "one-dark";

      # Fix vi-mode timeout
      KEYTIMEOUT = "1";

      # zsh-vim-mode settings
      MODE_INDICATOR = "";
      MODE_CURSOR_VIINS = "blinking bar";
      MODE_CURSOR_REPLACE = "$MODE_CURSOR_VIINS";
      MODE_CURSOR_VICMD = "block";
      MODE_CURSOR_SEARCH = "steady underline";
      MODE_CURSOR_VISUAL = "$MODE_CURSOR_VICMD steady bar";
      MODE_CURSOR_VLINE = "$MODE_CURSOR_VISUAL";

      # pure prompt
      PURE_PROMPT_SYMBOL = "›";
      PURE_PROMPT_VICMD_SYMBOL = "‹";
    };

    history.size = 10000;
    history.save = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";

    initContent =
      let
        extraBeforeCompInit = mkOrder 550 ''
          # Fixes https://github.com/nix-community/home-manager/issues/2562
          fpath+=("${config.home.profileDirectory}"/share/zsh/site-functions "${config.home.profileDirectory}"/share/zsh/$ZSH_VERSION/functions "${config.home.profileDirectory}"/share/zsh/vendor-completions)
        '';

        extra = ''
          # Load bashcompinit to enable Bash completion functions in Zsh
          autoload -Uz bashcompinit
          bashcompinit

          ## Load aws_cli completion if installed
          if [ -e "$(command -v aws_completer)" ]; then
            complete -C "$(command -v aws_completer)" aws
          fi

          # Pass arguments to command if pattern matching fails
          # This fixes using carrot (^) in git for example
          # https://stackoverflow.com/a/16864766/10913628
          setopt NO_NOMATCH

          # reclaim Ctrl-S
          stty stop undef
          # reclaim Ctrl-Q
          stty start undef
          # Disable Software Flow Control (XON/XOFF flow control)
          stty -ixon

          # Display fortune
          if [ -e "$(command -v fortune)" ]; then
          	echo "" && fortune -s && echo ""
          fi
        '';
      in
      mkMerge [
        extraBeforeCompInit
        extra
      ];

    profileExtra = ''
      # Set less colors
      export LESS_TERMCAP_mb=$'\E[01;31m'
      export LESS_TERMCAP_md=$'\E[01;31m'
      export LESS_TERMCAP_me=$'\E[0m'
      export LESS_TERMCAP_se=$'\E[0m'
      export LESS_TERMCAP_so=$'\E[01;44;32m'
      export LESS_TERMCAP_ue=$'\E[0m'
      export LESS_TERMCAP_us=$'\E[01;33m'

      # Add any local overrides
      if [ -f "$HOME/.zprofile.local" ]; then
              # shellcheck disable=SC1091
              source "$HOME/.zprofile.local"
      fi
    '';
  };
}
