#!/bin/bash

set -euo pipefail

source './utils.sh'

# Fresh install doesn't have this folder
mkdir -p "$HOME/.config"

# Link configuration files and folders using utils.sh
link_same        "$(pwd)/awesome"      "$HOME/.config/awesome"
link_same        "$(pwd)/kitty"        "$HOME/.config/kitty"
link_same        "$(pwd)/wallpapers"   "$HOME/Pictures/wallpapers"

link_same_files  "$(pwd)/nvim"         "$HOME/.config/nvim"
link_same_files  "$(pwd)/ulauncher"    "$HOME/.config/ulauncher"
link_same_files  "$(pwd)/vscode"       "$HOME/.config/Code - Insiders/User"

link_same_single "$(pwd)" '.gitconfig' "$HOME"
link_same_single "$(pwd)" '.p10k.zsh'  "$HOME"
link_same_single "$(pwd)" 'picom.conf' "$HOME/.config/picom"
link_same_single "$(pwd)" '.xinitrc'   "$HOME"
link_same_single "$(pwd)" 'zathurarc'  "$HOME/.config/zathura"
link_same_single "$(pwd)" '.zinit.zsh' "$HOME"
link_same_single "$(pwd)" '.zshrc'     "$HOME"

echo -e "\033[0;32mLinked all configuration files\033[0m"

