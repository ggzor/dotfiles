#!/bin/bash

set -euo pipefail

source './utils.sh'

# Link entire configuration folders
link_same        "$(pwd)/awesome"      "$HOME/.config/awesome"
link_same        "$(pwd)/bat"          "$HOME/.config/bat"
link_same        "$(pwd)/kitty"        "$HOME/.config/kitty"
link_same        "$(pwd)/rofi"         "$HOME/.config/rofi"
link_same        "$(pwd)/wallpapers"   "$HOME/Pictures/wallpapers"

# Link just files instead of entire folders to avoid
# polluting this dotfiles directory with generated files
link_same_files  "$(pwd)/nvim"         "$HOME/.config/nvim"
link_same_files  "$(pwd)/vscode"       "$HOME/.config/Code - Insiders/User"
link_same_files  "$(pwd)/xdg"          "$HOME/.config"

# Link just one file
link_same_single "$(pwd)" '.gitconfig' "$HOME"
link_same_single "$(pwd)" '.inputrc'   "$HOME"
link_same_single "$(pwd)" '.p10k.zsh'  "$HOME"
link_same_single "$(pwd)" '.theme.zsh' "$HOME"
link_same_single "$(pwd)" '.tmux.conf' "$HOME"
link_same_single "$(pwd)" '.xinitrc'   "$HOME"
link_same_single "$(pwd)" '.zinit.zsh' "$HOME"
link_same_single "$(pwd)" '.zshrc'     "$HOME"
link_same_single "$(pwd)" 'picom.conf' "$HOME/.config"
link_same_single "$(pwd)" 'zathurarc'  "$HOME/.config/zathura"

# Use same configuration file for neovim and vim
link_same "$(pwd)/nvim/init.vim" "$HOME/.vimrc"

echo -e "\033[0;32mLinked all configuration files\033[0m"

