#!/usr/bin/env bash

set -euo pipefail
export USER_NAME=${USER_NAME:-$USER}

# Extra commands after installing AUR packages

# Set user shell
sudo chsh -s "$(which zsh)" "$USER_NAME"

# Install nodejs version and make the default
NODE_VERSION=16.12.0
eval "$(fnm env)"
fnm install "$NODE_VERSION" \
  && fnm use "$NODE_VERSION" \
  && fnm default "$NODE_VERSION"

