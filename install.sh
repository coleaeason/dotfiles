#!/bin/bash

TYPE="work"

if [[ "$1" == "personal" ]]; then
	TYPE="personal"
fi

echo "Using type $TYPE"

DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"

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

echo "Done."
