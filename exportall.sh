#!/usr/bin/env bash

set -euo pipefail

# Timestamp for the archive name
TIMESTAMP="$(date +"%Y-%m-%d_%H-%M-%S")"

# Output archive name
ARCHIVE="nvim-backup-${TIMESTAMP}.tar.gz"

# Paths to back up
NVIM_CONFIG="$HOME/.config/nvim"
NVIM_DATA="$HOME/.local/share/nvim"

# Verify paths exist
for path in "$NVIM_CONFIG" "$NVIM_DATA"; do
  if [ ! -d "$path" ]; then
    echo "Warning: $path does not exist, skipping"
  fi
done

# Create archive
tar -czvf "$ARCHIVE" \
  -C "$HOME" \
  .config/nvim \
  .local/share/nvim

echo "Neovim backup created: $ARCHIVE"
