#!/bin/bash

TYPE="work"

if [[ "$1" == "personal" ]]; then
	TYPE="personal"
fi

OS=$(uname -s)

echo "Using type $TYPE on $OS"

DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Ignore the warning about not using ls because we need to use it to list files that
# start with a dot. Globbing does not work for this.
# shellcheck disable=SC2010
for item in $(ls -d .??* | grep -v -x .git | grep -v -x .vagrant.d | grep -v .gitconfig); do
    ln -snf "$DIR"/"$item" ~
done

# Dynamic choose the right gitconfig file.
ln -snf "$DIR"/.gitconfig-$TYPE ~/.gitconfig

if [[ ! -d ~/.ssh/ ]]; then
	mkdir -p ~/.ssh
fi

ln -snf "$DIR"/ssh_config_$TYPE ~/.ssh/config

if [[ ! -d ~/.git/ ]]; then
	mkdir -p ~/.git/hooks
fi

for hook in hooks/*; do
    ln -snf "$DIR"/"$hook" ~/.git/hooks/
done

if [[ ! -d ~/.vagrant.d/ ]]; then
	mkdir -p ~/.vagrant.d
fi

for file in .vagrant.d/*; do
	ln -snf "$DIR"/"$file" ~/.vagrant.d/
done

# Link the oh-my-posh theme file.
ln -snf "$DIR"/theme.omp.json ~/theme.omp.json

# Linux doesn't have default set to zsh, so we need to set it.
if [[ "$OS" != "Darwin" ]]; then
	sudo chsh -s "$(which zsh)" "$USER"
fi

# Install oh-my-zsh if it's not already installed.
if [[ -z "$ZSH" ]]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
fi

# Only install oh-my-zsh plugins on non-Darwin systems, otherwise they are installed by brew.
if [[ "$OS" != "Darwin" ]]; then
	if ! command -v oh-my-posh 1>/dev/null 2>&1; then
		# Install oh-my-posh
		curl -s https://ohmyposh.dev/install.sh | bash -s

		# Install oh-my-posh font
		oh-my-posh font install meslo
	fi

	# Install oh-my-zsh plugins
	ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

	PLUGINS=(
		"zsh-autosuggestions"
		"zsh-syntax-highlighting"
	)

	for plugin in "${PLUGINS[@]}"; do
		if [[ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]]; then
			git clone "https://github.com/zsh-users/$plugin.git" "$ZSH_CUSTOM/plugins/$plugin"
		fi
	done
fi

echo "Done."
