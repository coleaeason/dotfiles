# Set PATH
export PATH="/usr/local/sbin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
	if command -v oh-my-posh 1>/dev/null 2>&1; then
 		eval "$(oh-my-posh init zsh --config $HOME/source/dotfiles/theme.omp.json)"
	fi
fi

# load secrets if any
if [ -f "$HOME"/.secrets ]; then
    source "$HOME"/.secrets
fi

# load 1Password Plugins if inited
if [ -f "$HOME"/.config/op/plugins.sh ]; then
    source "$HOME"/.config/op/plugins.sh
fi

CA_CERT_PATH="/Users/cole/source/Expensify/Expensidev/Ops-Configs/saltfab/cacert.pem"

if [ -f "$CA_CERT_PATH" ]; then
    export NODE_EXTRA_CA_CERTS="$CA_CERT_PATH"
    export AWS_CA_BUNDLE="$CA_CERT_PATH"
    export SSL_CERT_FILE="$CA_CERT_PATH"
    export CURL_CA_BUNDLE="$CA_CERT_PATH"
    export BUNDLE_SSL_CA_CERT="$CA_CERT_PATH"
    export REQUESTS_CA_BUNDLE="$CA_CERT_PATH"
fi


if command -v go 1>/dev/null 2>&1; then
	export PATH="$PATH:$(go env GOPATH)/bin/"
fi

# Pyenv garbage
if command -v pyenv 1>/dev/null 2>&1; then
	eval "$(pyenv init -)"
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/shims:$PATH"
fi

#nvm garbage
if command -v nvm 1>/dev/null 2>&1; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

    # Add auto node version switching with nvm for any directory
    # that has an nvmrc in it. Will also install if the node version
    # requested is missing.
    autoload -U add-zsh-hook

    load-nvmrc() {
    local nvmrc_path
    nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
        local nvmrc_node_version
        nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

        if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
        elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
        nvm use
        fi
    elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
        echo "Reverting to nvm default version"
        nvm use default
    fi
    }

    add-zsh-hook chpwd load-nvmrc
    load-nvmrc
fi

# rbenv garbage
if command -v rbenv 1>/dev/null 2>&1; then
	eval "$(rbenv init -)"
    export PATH=$HOME/.rbenv/shims:$PATH
fi

# Set colors to always be like linux
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

#Aliases
if [ -f "$HOME"/.aliases ]; then
    source "$HOME"/.aliases
fi

if [ -f "$HOME"/.bash_aliases ]; then
    source "$HOME"/.bash_aliases
fi

function get_uuid() {
	echo "cole" > "$(uuidgen)".txt
}

# set functions path
fpath=("$HOME"/.zsh/functions $fpath)

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

if ! command -v oh-my-posh 1>/dev/null 2>&1; then

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
fi
