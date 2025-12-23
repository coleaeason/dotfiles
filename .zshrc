# Uncomment this line and the last line in this file to profile zshrc start times.
#zmodload zsh/zprof

# Set PATH
# This keeps the path unique, so if you source this zshrc it won't add duplicates.
# zsh automatically exports `path` as $PATH
typeset -U path
path=($HOME/.local/bin /usr/local/sbin $path)

# If homebrew is installed, add its bin and sbin directories to the path.
if [[ -d /opt/homebrew/bin ]]; then
    path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
fi

# If Go is installed, add its bin directory to the path.
if command -v go 1>/dev/null 2>&1; then
	path=($path "$(go env GOPATH)/bin/")
fi

# Pyenv garbage
if command -v pyenv 1>/dev/null 2>&1; then
	# eval "$(pyenv init -)"
    # export PYENV_ROOT="$HOME/.pyenv"
    # path=("$PYENV_ROOT/shims" $path)
fi

# rbenv garbage
if command -v rbenv 1>/dev/null 2>&1; then
	eval "$(rbenv init -)"
   path=("$HOME/.rbenv/shims" $path)
fi

# configure rust
path=($path "$(brew --prefix rustup)/bin" "$HOME/.cargo/bin")

# Android tools
export ANDROID_HOME="$HOME/Library/Android/sdk"
path=($path "$ANDROID_HOME/tools" "$ANDROID_HOME/tools/bin" "$ANDROID_HOME/platform-tools")

# Ubuntu keychain similar to macos keychain behavior for ssh
eval $(keychain --eval id_ed25519)

# Java Tools
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"

# rust
if command -v brew 1>/dev/null 2>&1; then
    path=($path "$HOME/.cargo/bin" "$(brew --prefix rustup)/bin")
fi

# Oh-My-Zsh
export ZSH="$HOME/.oh-my-zsh"

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
    if command -v oh-my-posh 1>/dev/null 2>&1; then
        eval "$(oh-my-posh init zsh --config $HOME/theme.omp.json)"
    fi
fi

# load secrets if any
# DEPRECATED: Used 1Password env instead.
if [[ -f "$HOME"/.secrets ]]; then
    source "$HOME"/.secrets
fi

# load 1Password Plugins if inited
if [[ -f "$HOME"/.config/op/plugins.sh ]]; then
    source "$HOME"/.config/op/plugins.sh
fi

# bun completions
[ -s "/home/cole/.bun/_bun" ] && source "/home/cole/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export path=($path "$BUN_INSTALL/bin" )

# Work nonsense, add Warp certificate and set all of the env variables as required.
CA_CERT_PATH="$HOME/source/Expensify/Expensidev/Ops-Configs/cacert.pem"

if [[ -f "$CA_CERT_PATH" ]]; then
    export NODE_EXTRA_CA_CERTS="$CA_CERT_PATH"
    export AWS_CA_BUNDLE="$CA_CERT_PATH"
    export SSL_CERT_FILE="$CA_CERT_PATH"
    export CURL_CA_BUNDLE="$CA_CERT_PATH"
    export BUNDLE_SSL_CA_CERT="$CA_CERT_PATH"
    export REQUESTS_CA_BUNDLE="$CA_CERT_PATH"
fi

# Fixes UV with WARP
export UV_NATIVE_TLS=1

# Make GPG work in headless terminals
if [[ -z $GPG_TTY ]] && tty -s; then
	export GPG_TTY=$(tty)
fi
# nvm Plugin settings for oh-my-zsh
# This lazy loads the nvm plugin, so it doesn't slow down the shell startup time.
# it will load when you first execute npm, node, etc anything that might need it.
[ -d "$ZSH" ] && plugins=(nvm uv mise)

zstyle ':omz:plugins:nvm' lazy yes
zstyle ':omz:plugins:nvm' autoload yes
zstyle ':omz:update' mode reminder

# On macos this is in brew, otherwise it's in the oh-my-zsh plugins directory.
if command -v brew 1>/dev/null 2>&1; then
    [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
else
    [ -f "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Configure GAM
export GAMCFGDIR="$HOME/.gam"

# Set colors to always be like linux
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

#Aliases
if [ -f "$HOME"/.aliases ]; then
    source "$HOME"/.aliases
fi

if [ -f "$HOME"/.bash_aliases ]; then
    source "$HOME"/.bash_aliases
fi

if command -v nvim 1>/dev/null 2>&1; then
    alias vim='nvim'
fi

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

# Disable default venv PS1
export VIRTUAL_ENV_DISABLE_PROMPT=1

autoload -Uz vcs_info
autoload -U compinit && compinit

if ! command -v oh-my-posh 1>/dev/null 2>&1; then

    # Determine active Python virtualenv details.
    function set_virtualenv () {
        if test -z "$VIRTUAL_ENV" ; then
            echo ""
        else
            echo "🐍%F{2}(`basename \"$VIRTUAL_ENV\"`)%f "
        fi
    }

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

source $ZSH/oh-my-zsh.sh

# Uncomment this line and the first line in this file to profile zshrc start times.
# zprof

