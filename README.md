# Dotfiles

## How to use
Note: These instructions assume your `cwd` is this repo.

1. Install all dot files with, where `<type>` is either `work` or `personal`. If left blank it assumes `work`:
```
./install.sh <type>
```

2. Install brew packages (requires brew first):
```
brew bundle
```
This will install the brew bundle package and will use the Brewfile in this repo to install the packages in it.

3. Import the iterm2.json profile in iterm2's Preferences pane and restart iTerm2

4. In Alfred, go to `Advanced > Set Preference Folder` and select the Alfred folder in this repo.

## Updating Brewfile
You can update the brewfile with `brew bundle dump --force` in this folder.

## TODO
1. Add support for ubuntu
2. Remove support for non-zsh shells
