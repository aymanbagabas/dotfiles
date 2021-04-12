(ssh-add -A 2>/dev/null &)

# Add local sbin to path
export PATH=/usr/local/sbin:$PATH

if [ -e "$(which ruby)" ]; then
    export GEM_HOME=$(ruby -e 'print Gem.user_dir')
    export GEM_PATH=$GEM_HOME
    export PATH=$PATH:$GEM_PATH/bin
fi

if [ -e "$(which go)" ]; then
    export GOPATH=$HOME/.go
fi

if [ -d "$HOME/.dotnet" ]; then
    export PATH="$PATH:$HOME/.dotnet" # Add the directory where the dotnet executable lives
fi

if [ -d "$HOME/.cargo" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

if [ ! -d "$HOME/.nvm" ]; then
    mkdir $HOME/.nvm
fi

if [ -e "$(which python)" ]; then
  export PATH="$PATH:$(python3 -m site --user-base)/bin"
fi

export LESSOPEN="| $(which src-hilite-lesspipe.sh) %s"
export LESS=' -R '
export GROFF_NO_SGR=1		# for konsole and gnome-terminal
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
