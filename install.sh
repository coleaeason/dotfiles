#!/bin/bash

DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"

for item in .profile .gitconfig .gitignore .vimrc iterm2.profile .git-completion.bash; do
    ln -snf $DIR/$item ~
done

for hook in hooks/*; do
    ln -snf $DIR/$hook ~/.git/hooks/
done
