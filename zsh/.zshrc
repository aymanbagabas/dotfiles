# Run bicon at the beginning
#if [[ ( -z "$BICON" ) && ( -e "`which bicon.bin`" ) && ( "$TERM" == xterm* ) ]]; then
#    export BICON=true
#    bicon.bin
#    exit
#fi

# Tmux
# If not running interactively, do not do anything
#[[ $- != *i* ]] && return
#[[ -z "$TMUX" ]] && exec tmux

# If you come from bash you might have to change your $PATH.
#PATH="$HOME/.perl5/bin${PATH:+:${PATH}}"; export PATH;
#PERL5LIB="$HOME/.perl5/lib/.perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
#PERL_LOCAL_LIB_ROOT="$HOME/.perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
#PERL_MB_OPT="--install_base \"$HOME/.perl5\""; export PERL_MB_OPT;
#PERL_MM_OPT="INSTALL_BASE=$HOME/.perl5"; export PERL_MM_OPT;
export PY_USER_BIN=$(python -c 'import site; print(site.USER_BASE + "/bin")')
export PATH=$PY_USER_BIN:$PATH
export PATH=$PATH:$HOME/.local/bin:$HOME/bin:/usr/local/bin:$(ruby -e 'print Gem.dir')/bin
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export LD_LIBRARY_PATH=/usr/lib:/usr/lib64:/usr/local/lib:/usr/local/lib64:$LD_LIBRARY_PATH
export GI_TYPELIB_PATH=/usr/local/lib/girepository-1.0:/usr/local/lib64/girepository-1.0:$GI_TYPELIB_PATH
export PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/lib64/pkgconfig:/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH
export NPM_PACKAGES="$HOME/.npm-packages"
export npm_config_prefix=$NPM_PACKAGES
export PATH="$NPM_PACKAGES/bin:$PATH"
export MANPATH="$NPM_PACKAGES/share/man:$MANPATH"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
export GOPATH="$HOME/.go"
export PATH="$PATH:$GOPATH/bin"
export VALA_LSP="$HOME/Workstation/vala-language-server/build"
export PATH="$VALA_LSP:$PATH"

# Path to your oh-my-zsh installation.
ZSH=$HOME/.oh-my-zsh/

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="mytheme"

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
# ZSH_CUSTOM=$HOME/.oh-my-zsh/

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git sudo compleat systemd zsh-completions zsh-syntax-highlighting docker python dnf tmuxinator vi-mode)

# Auto rehash
zstyle ':completion:*' rehash true

autoload -U compinit && compinit

# User configuration

export KEYTIMEOUT=1				# fix vi-mode timeout
export VISUAL="nvim"
export PAGER="less"

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh        # oh-my-zsh
source $HOME/.aliases           # aliases
source $HOME/.zshkeys           # keybindings

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
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# Color less
export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
export LESS=' -R '
export GROFF_NO_SGR=1		# for konsole and gnome-terminal

# Display fortune
if [ -e "$( which fortune )" ]; then
    echo "" && fortune -s && echo ""
fi

# SSH agent
#if [ -n "$DESKTOP_SESSION" ];then
    #eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
    #export SSH_AUTH_SOCK
#fi
[ -z "$SSH_AUTH_SOCK" ] && eval "$(ssh-agent -s)"

export DISABLE_AUTO_TITLE=true

# use ctags as a back-end for GNU global gtags
export GTAGSLABEL=new-ctags

# Vi-mode sudo
bindkey -M vicmd "\e" sudo-command-line
bindkey -M vicmd '^V' edit-command-line
