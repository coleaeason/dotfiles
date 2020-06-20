#!/bin/bash

DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"

for item in $(ls -d .??* | grep -v -x .git | grep -v -x .vagrant.d); do
    ln -snf $DIR/$item ~
done

if [[ ! -d ~/.git/ ]]; then
	mkdir -p ~/.git/hooks
fi

for hook in hooks/*; do
    ln -snf $DIR/$hook ~/.git/hooks/
done

if [[ ! -d ~/.vagrant.d/ ]]; then
	mkdir -p ~/.vagrant.d
fi

for file in .vagrant.d/*; do
	ln -snf $DIR/$file ~/.vagrant.d/
done

echo "Done."
