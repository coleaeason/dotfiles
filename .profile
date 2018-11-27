#Add key
ssh-add ~/.ssh/expensify > /dev/null 2>&1

# load secrets if any
if [ -f ~/.secrets ]; then
    source ~/.secrets
fi

# Set PATH
export PATH=$PATH:$HOME/go/bin

# Set CXX Variables
export CXXFLAGS="-std=gnu++14 -Wall -Werror"

#Aliases
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# git autocomplete
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

if [ -f ~/source/Expensify/Expensidev/Ops-Configs/fabric-completion/fabric-completion.bash ]; then
  . ~/source/Expensify/Expensidev/Ops-Configs/fabric-completion/fabric-completion.bash
fi

HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# check winsize and resize
shopt -s checkwinsize

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
        if [[ $dirty == '*' ]]
        then
            echo "\[\033[91m\]"
        else
            echo "\[\033[32m\]"
        fi
    fi
}
function twolastdirs {
tmp=${PWD%/*/*};
[ ${#tmp} -gt 0 -a "$tmp" != "$PWD" ] && echo ${PWD:${#tmp}+1} || echo $PWD;
}

# Determine active Python virtualenv details.
function set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="\[\033[0;32m\](`basename \"$VIRTUAL_ENV\"`) "
  fi
}

function color_my_prompt {
    history -a
    if [[ $OSTYPE == darwin* ]]; then
        local host="\[\033[01;36m\]\h"
    elif [[ -f /etc/vagrantbox ]]; then
        local host="\[\033[01;32m\]\h"
    else
        local host="\[\033[01;93m\]\h"
    fi
    local dircolor="\[\033[01;34m\]"
    local separatorcolor="\[\033[00;32m\]"
    local dir="\W"
    local twolastdirs="$(twolastdirs)"
    local branch_color=$(get_branch_color)
    local git_branch='`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`'
    local last_color="\[\033[00m\]"
    local prompt_symbol=">"
    set_virtualenv
    export PS1="${PYTHON_VIRTUALENV}$host$separatorcolor->$dircolor$twolastdirs $branch_color$git_branch$separatorcolor$prompt_symbol$last_color "
}
PROMPT_COMMAND=color_my_prompt
