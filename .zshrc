#Add key

# load secrets if any
if [ -f ~/.secrets ]; then
    source ~/.secrets
fi

# Set PATH
export PATH="/usr/local/sbin:/usr/local/opt/terraform@0.11/bin:$PATH"

# Set colors to always be like linux
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

#Aliases
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# set functions path
fpath=(~/.zsh/functions $fpath)

# do not store duplications
setopt HIST_IGNORE_DUPS

# removes blank lines from history
setopt HIST_REDUCE_BLANKS

# append to the history file, don't overwrite it
setopt APPEND_HISTORY

# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY

# make globbing work like bash
setopt NO_NO_MATCH

# substitute variables and functions etc in the prompt command
setopt PROMPT_SUBST

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

function parse_git_dirty {
    if ! git ls-files >& /dev/null; then
        echo ""
    else
        [[ $(git diff --shortstat) ]] && echo "*"
    fi
}

function get_branch_color {
    if ! git ls-files >& /dev/null; then
        echo ""
    else
        local dirty=$(parse_git_dirty)
        if [[ $dirty == '*' ]]; then
            echo "%F{9}"
        else
            echo "%F{2}"
        fi
    fi
}

# Disable default venv PS1
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Determine active Python virtualenv details.
function set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      echo ""
  else
      echo "🐍%F{2}(`basename \"$VIRTUAL_ENV\"`)%f "
  fi
}

autoload -Uz vcs_info 
autoload -U compinit && compinit
precmd() { 
	vcs_info
	branch_color=$(get_branch_color)
	PYTHON_VIRTUALENV=$(set_virtualenv)
 }
zstyle ':vcs_info:git:*' formats '(%b) '

# %B starts bold
# %b stops bold
# %F{number} starts new color
# %f stops color
# %m for short hostname
# %2d for last 2 dirs

PROMPT='${PYTHON_VIRTUALENV}%B%F{14}%m%f%b%F{2}->%f%B%F{4}%2d%f%b %B${branch_color}${vcs_info_msg_0_}%f%b%F{2}>%f '
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

if `which rbenv > /dev/null`; then
	eval "$(rbenv init -)"
fi
