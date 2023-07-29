local return_code="%(?..💥 %{$fg[red]%}%? ↵%{$reset_color%})"

if [[ $UID -eq 0 ]]; then
  local user_host='%{$fg[cyan]%}%n@%m%{$reset_color%}'
  local user_symbol='#'
else
  local user_host='%{$fg[magenta]%}%n@%m%{$reset_color%}'
  local user_symbol=''
fi

local current_dir='%{$fg[green]%}%~%{$reset_color%}'
local git_branch=' $(git_prompt_info)%{$reset_color%}'
local current_dir=$(echo -e "\e[4m${current_dir}\e[0m")
local current_dir=$(echo -e "\e[1m${current_dir}\e[0m")

PROMPT="
 ${current_dir}${git_branch}%{$reset_color%}
 %{$fg[cyan]%}❯%{$fg[green]%}❯%{$fg[yellow]%}❯ ${user_symbol}%{$reset_color%} "
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="$fg[yellow]» ᚶ %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" $fg[red]🚧$reset_color"
ZSH_THEME_GIT_PROMPT_CLEAN=" $fg[green]✔✔✔$reset_color"

# LS colors, made with http://geoff.greer.fm/lscolors/
export LSCOLORS="gxfxcxdxbxegedabagacad"
export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
export GREP_COLOR='1;33'
