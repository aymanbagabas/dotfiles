if [ ! -e "$HOME/.zplug" ]; then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi
source ~/.zplug/init.zsh

# Manage zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Sane defaults from OMZ
zplug "lib/clipboard", from:oh-my-zsh
zplug "lib/key-bindings", from:oh-my-zsh
zplug "lib/completion.zsh", from:oh-my-zsh
zplug "lib/compfix.zsh", from:oh-my-zsh
zplug "lib/theme-and-appearance.zsh", from:oh-my-zsh

### Plugins
zplug "lukechilds/zsh-nvm"
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/compleat", from:oh-my-zsh
zplug "plugins/systemd", from:oh-my-zsh, if:"[[ $OSTYPE == linux* ]]"
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/python", from:oh-my-zsh
zplug "plugins/dnf", from:oh-my-zsh, if:"[[ $OSTYPE == linux* ]]"
zplug "plugins/tmuxinator", from:oh-my-zsh
zplug "plugins/wd", from:oh-my-zsh
zplug "plugins/fzf", from:oh-my-zsh
zplug "plugins/git-flow", from:oh-my-zsh
zplug "plugins/tig", from:oh-my-zsh
zplug "plugins/iterm2", from:oh-my-zsh, if:"[[ $OSTYPE == darwin* ]]"
zplug "plugins/vi-mode", from:oh-my-zsh
zplug "~/.zsh/plugins/yadm-plugin", from:local
# Defer after compinit
zplug "zsh-users/zsh-completions", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:2

### Theme
zplug "chriskempson/base16-shell", use:"scripts/base16-onedark.sh", defer:0
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load # --verbose

# User configuration
fpath+=("$HOME/.zsh/completions")
autoload -U compinit; compinit

export HISTSIZE=10000
export SAVEHIST=10000
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export KEYTIMEOUT=1				# fix vi-mode timeout
# source $ZSH/oh-my-zsh.sh        # oh-my-zsh
#source $HOME/.zshkeys           # keybindings
source $HOME/.aliases

# reclaim Ctrl-S
stty stop undef
# reclaim Ctrl-Q
stty start undef
# Disable Software Flow Control (XON/XOFF flow control)
stty -ixon

# Base16 shell
# Install from https://github.com/chriskempson/base16-shell
# Gnome-terminal
# Install from https://github.com/aaron-williamson/base16-gnome-terminal
# Tilix
# Install from https://github.com/karlding/base16-tilix
# BASE16_SHELL="$HOME/.config/base16-shell/"
# [ -n "$PS1" ] && \
#     [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
#         eval "$("$BASE16_SHELL/profile_helper.sh")"

# Display fortune
if [ -e "$( which fortune )" ]; then
    echo "" && fortune -s && echo ""
fi

# SSH agent
[ -z "$SSH_AUTH_SOCK" ] && eval "$(ssh-agent -s)"

# Vi-mode
# fix sudo plugin
if [ -z "$VIM" ]; then
  bindkey -M vicmd "\e" sudo-command-line
fi
# open in vim
bindkey -M vicmd '^V' edit-command-line
# ctrl-p & ctrl-n to behave like arrow keys
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search
# empty mode indicator
MODE_INDICATOR=
VI_MODE_SET_CURSOR=true
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true

# pure prompt
PURE_PROMPT_SYMBOL="›"
PURE_PROMPT_VICMD_SYMBOL="‹"
# fpath+=("$HOME/.oh-my-zsh.custom/themes/pure")
# autoload -U promptinit; promptinit
# prompt pure

# fzf
# [ -f /usr/share/zsh/site-functions/fzf ] && source /usr/share/zsh/site-functions/fzf # when using Fedora fzf package
# base16
_gen_fzf_default_opts() {
  local color00='#282c34'
  local color01='#353b45'
  local color02='#3e4451'
  local color03='#545862'
  local color04='#565c64'
  local color05='#abb2bf'
  local color06='#b6bdca'
  local color07='#c8ccd4'
  local color08='#e06c75'
  local color09='#d19a66'
  local color0A='#e5c07b'
  local color0B='#98c379'
  local color0C='#56b6c2'
  local color0D='#61afef'
  local color0E='#c678dd'
  local color0F='#be5046'

  # export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden"
  export FZF_DEFAULT_OPTS="
  --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D
  --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C
  --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D
  "
}

_gen_fzf_default_opts
# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS"--preview '(if [[ -f {} && '\$(file --dereference --mime {})' =~ binary ]]; then echo -n \"{} is a binary file\"; else (highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null; fi) | head -200'"

fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]] && [[ $(command -v tmux) ]]; then
  (tmux attach-session -t ssh || tmux new-session -s ssh) && exit
fi
