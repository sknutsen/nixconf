#!/usr/bin/env bash
# Idempotent Cloud Agent setup for this Nix flake configuration repo.
# Installs single-user Nix (no daemon; works without systemd), enables flakes,
# and warms the pinned flake inputs so evaluation is fast for the agent.
set -euo pipefail

NIX_PROFILE_SCRIPT="$HOME/.nix-profile/etc/profile.d/nix.sh"

if [ ! -e "$NIX_PROFILE_SCRIPT" ] && ! command -v nix >/dev/null 2>&1; then
  echo "Installing single-user Nix..."
  sh <(curl -L https://nixos.org/nix/install) --no-daemon
fi

if [ -e "$NIX_PROFILE_SCRIPT" ]; then
  # shellcheck disable=SC1090
  . "$NIX_PROFILE_SCRIPT"
fi

mkdir -p "$HOME/.config/nix"
if ! grep -qs "experimental-features" "$HOME/.config/nix/nix.conf"; then
  echo "experimental-features = nix-command flakes" >> "$HOME/.config/nix/nix.conf"
fi

nix --version

# Fetch the pinned flake inputs into the store (fast, no heavy builds).
nix flake metadata --no-write-lock-file >/dev/null

echo "Nix environment ready. Try: nix build .#nixosConfigurations.wsl.config.system.build.toplevel"
