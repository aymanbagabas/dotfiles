# user colors
if [ $UID -eq 0 ]; then USERID="#"; else USERID="›"; fi

local return_status="%(?:%{$fg_bold[blue]%}%c%{$reset_color%}:%{$fg_bold[magenta]%}%c%{$reset_color%}%s)"

PROMPT='
 $(_user_host)$(_current_dir)
 %{$fg[white]%}$USERID%{$reset_color%} '
RPROMPT='$(_git_info)'

function _current_dir() {
  local _max_pwd_length="65"
  if [[ $(echo -n $PWD | wc -c) -gt ${_max_pwd_length} ]]; then
    dir="%-2~ ... %3~"
  else
    dir="%~"
  fi
  echo "%(?:%{$fg_bold[blue]%}$dir%{$reset_color%}:%{$fg_bold[magenta]%}$dir%{$reset_color%}%s)"
}

function _git_info() {
  echo "$(git_prompt_status)%{$reset_color%}$(git_prompt_info)%{$reset_color%}"
}

function _user_host() {
  if [[ -n $SSH_CONNECTION ]]; then
    me="%n@%m"
  elif [[ $LOGNAME != $USER ]]; then
    me="%n"
  fi
  if [[ -n $me ]]; then
    echo "%{$fg[yellow]%}$me%{$reset_color%} "
  fi
}

function _vi_mode() {
  cmd="%{$bg[blue]%} %{$reset_color%}"
  ins="%{$bg[green]%} %{$reset_color%}"

  echo "${${VI_KEYMAP/vicmd/$cmd}/(main|viins)/$ins}"
}

MODE_INDICATOR="%{$fg[blue]%}█%{$reset_color%}"
# VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} + "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} * "
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} x "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} → "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} = "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ¤ "
