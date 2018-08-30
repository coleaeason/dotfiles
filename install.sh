#!/bin/bash

DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"

for item in $(ls -d .??*); do
    ln -snf $DIR/$item ~
done

for hook in hooks/*; do
    ln -snf $DIR/$hook ~/.git/hooks/
done

echo "Done."
