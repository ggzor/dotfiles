#!/usr/bin/env bash

set -euo pipefail
export USER_NAME=${USER_NAME:-$SUDO_USER}

# Add user to docker group
usermod -aG docker "$USER_NAME"

# Systemd commands
systemctl enable --now \
	acpid.service \
	docker.service \
	firewalld.service \
	sshd.service

# Install stable and nightly rust toolchain
sudo -u "$USER_NAME" rustup install stable nightly

