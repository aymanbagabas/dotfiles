{ config, pkgs, ... }:

let
  lib = pkgs.lib;
  pathJoin = builtins.concatStringsSep ":";
  secretSessionVariablesPath = ../secrets/sessionVariables.json;
in {
  programs.zsh = rec {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "pure-prompt";
        file = "async.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "sindresorhus";
          repo = "pure";
          rev = "v1.23.0";
          hash = "sha256-BmQO4xqd/3QnpLUitD2obVxL0UulpboT8jGNEh4ri8k=";
        };
      }
      {
        name = "pure-prompt";
        file = "pure.zsh";
        src = (builtins.elemAt plugins 0).src;
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
        src = pkgs.fetchFromGitHub {
            owner = "softmoth";
            repo = "zsh-vim-mode";
            rev = "1f9953b7d6f2f0a8d2cb8e8977baa48278a31eab"; # Mar 21, 2021
            hash = "sha256-a+6EWMRY1c1HQpNtJf5InCzU7/RphZjimLdXIXbO6cQ=";
        };
      }
      {
        name = "zsh-completions";
        file = "share/zsh-completions/zsh-completions.plugin.zsh";
        src = pkgs.zsh-completions;
      }
      {
        name = "base16-shell";
        file = "base16-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "tinted-theming";
          repo = "tinted-fzf";
          rev = "e9a7bd60a660c1686ab01c81aa6ec10de225c72b"; # Apr 7, 2024
          hash = "sha256-X89FsG9QICDw3jZvOCB/KsPBVOLUeE7xN3VCtf0DD3E=";
        };
      }
    ] ++ (pkgs.lib.optionals pkgs.stdenv.isLinux {
       name = "omzp-systemd";
       file = "share/oh-my-zsh/plugins/systemd/systemd.plugin.zsh";
       src = pkgs.oh-my-zsh;
    });

    sessionVariables = {
      PATH = pathJoin [
        "$HOME/.bin"
        "$PATH"
      ];

      BASE16_THEME = "onedark";

      KEYID = "593D6EEE7871708E329619322EBA00DFFCC63351"; # GPG key ID
      PAGER = "less";
      KEYTIMEOUT = "1"; # Fix vi-mode timeout

      LESS = "-R --mouse --wheel-lines=3";
      LESSOPEN="| $(command -v src-hilite-lesspipe.sh) %s";
      FZF_DEFAULT_COMMAND="rg --files --hidden --no-ignore-vcs --glob '!.git/*'";

      # https://gpanders.com/blog/the-definitive-guide-to-using-tmux-256color-on-macos/
      TERMINFO_DIRS="$TERMINFO_DIRS:$HOME/.local/share/terminfo";
      DOTNET_CLI_TELEMETRY_OPTOUT=1; # Disable dotnet telemetry

      # Disable vim-mode tracking
      # Pure prompt handles this
      VIM_MODE_TRACK_KEYMAP="no";

      # Disable vim-mode indicator
      MODE_INDICATOR = "";

      # pure prompt
      PURE_PROMPT_SYMBOL="›";
      PURE_PROMPT_VICMD_SYMBOL="›";
    } // (lib.optionalAttrs pkgs.stdenv.isDarwin {
      LSCOLORS = "exfxcxdxbxegedabagacad";
      CLICOLOR = "1";
    }) // lib.optionalAttrs (builtins.pathExists secretSessionVariablesPath)
      builtins.fromJSON (builtins.readFile secretSessionVariablesPath);

    shellAliases = {
      grep = "grep --color=auto";
      git = "hub";
      sudo = "sudo "; # Fix sudo + aliases https://askubuntu.com/a/22043
      tf = "terraform";
      watch = "watch --color ";
      gpg-reload-agent="gpg-connect-agent reloadagent /bye";
      gpg-other-card="gpg-connect-agent 'scd serialno' 'learn --force' /bye";
    } // (lib.optionalAttrs pkgs.stdenv.isLinux {
      open = "xdg-open";
    });

    history.size = 10000;
    history.save = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";

    initExtra = ''
      # Fix reset RPS1
      unset RPS1

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

      # Initial cursor style
      echo -ne "\e[5 q" # blinking line

      # Change cursor style on Vi mode change
      reset_vim_prompt_widget() {
      	echo -ne "\e[5 q" # blinking line
      }

      update_vim_prompt_widget() {
      	case $KEYMAP in
      	vicmd) echo -ne "\e[1 q" ;; # blinking block
      	*) echo -ne "\e[5 q" ;;     # blinking line
      	esac
      }

      add-zle-hook-widget zle-line-finish reset_vim_prompt_widget
      add-zle-hook-widget zle-keymap-select update_vim_prompt_widget

      # Set less colors
      export LESS_TERMCAP_mb=$'\E[01;31m'
      export LESS_TERMCAP_md=$'\E[01;31m'
      export LESS_TERMCAP_me=$'\E[0m'
      export LESS_TERMCAP_se=$'\E[0m'
      export LESS_TERMCAP_so=$'\E[01;44;32m'
      export LESS_TERMCAP_ue=$'\E[0m'
      export LESS_TERMCAP_us=$'\E[01;33m'
    '';
  };
}
