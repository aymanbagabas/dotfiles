(ssh-add -A 2>/dev/null &)

if [ -e "$(which ruby)" ]; then
    export GEM_HOME=$(ruby -e 'print Gem.user_dir')
    export GEM_PATH=$GEM_HOME
    export PATH=$PATH:$GEM_PATH/bin
fi

if [ -e "$(which go)" ]; then
    export GOPATH=$HOME/.go
fi

export PATH="$HOME/.cargo/bin:$PATH"

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LESSOPEN="| $(which src-hilite-lesspipe.sh) %s"
export LESS=' -R '
export GROFF_NO_SGR=1		# for konsole and gnome-terminal
