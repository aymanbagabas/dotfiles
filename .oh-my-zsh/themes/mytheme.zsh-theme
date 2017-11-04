# user colors
if [ $UID -eq 0 ]; then USERID="#"; else USERID="›"; fi

local return_status="%(?:%{$fg_bold[blue]%}%c%{$reset_color%}:%{$fg_bold[magenta]%}%c%{$reset_color%}%s)"
local git_branch='$(git_prompt_status)%{$reset_color%}$(git_prompt_info)%{$reset_color%}'

PROMPT='${return_status} %{$fg[white]%}$USERID%{$reset_color%} '
RPROMPT="${git_branch}"


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
