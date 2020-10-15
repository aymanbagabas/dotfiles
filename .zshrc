export GEM_HOME=$(ruby -e 'print Gem.user_dir')
export GEM_PATH=$GEM_HOME
export PATH=$PATH:$GEM_PATH/bin

# Path to your oh-my-zsh installation.
ZSH=$HOME/.oh-my-zsh/

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=""

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/.oh-my-zsh.custom/

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git sudo compleat systemd zsh-completions zsh-syntax-highlighting docker python dnf tmuxinator vi-mode wd fzf git-flow tig iterm2)

# Auto rehash
zstyle ':completion:*' rehash true

autoload -U compinit && compinit

# User configuration

export KEYTIMEOUT=1				# fix vi-mode timeout
export VISUAL="nvim"
export PAGER="less"

source $ZSH/oh-my-zsh.sh        # oh-my-zsh
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
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# Color less
export LESSOPEN="| $(which src-hilite-lesspipe.sh) %s"
export LESS=' -R '
export GROFF_NO_SGR=1		# for konsole and gnome-terminal

# Display fortune
if [ -e "$( which fortune )" ]; then
    echo "" && fortune -s && echo ""
fi

# SSH agent
[ -z "$SSH_AUTH_SOCK" ] && eval "$(ssh-agent -s)"

# Vi-mode
# fix sudo plugin
bindkey -M vicmd "\e" sudo-command-line
# open in vim
bindkey -M vicmd '^V' edit-command-line
# ctrl-p & ctrl-n to behave like arrow keys
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search
# empty mode indicator
MODE_INDICATOR=

# pure prompt
PURE_PROMPT_SYMBOL="›"
PURE_PROMPT_VICMD_SYMBOL="‹"
fpath+=("$HOME/.oh-my-zsh/custom/themes/pure")
autoload -U promptinit; promptinit
prompt pure

# fzf
[ -f /usr/share/zsh/site-functions/fzf ] && source /usr/share/zsh/site-functions/fzf # when using Fedora fzf package
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

eval $(thefuck --alias)

#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# >>>> Vagrant command completion (start)
fpath=(/opt/vagrant/embedded/gems/2.2.10/gems/vagrant-2.2.10/contrib/zsh $fpath)
compinit
# <<<<  Vagrant command completion (end)
