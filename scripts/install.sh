#!/bin/bash
# =============================================================================
# pix-install.sh
# One-time system setup for the PIX capture pipeline
#
# Ref: "docs/archi/arch.drawio", "install-process" page.
# =============================================================================

# Ensure script will always fail (unsilently)
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/errors.sh"
source "$SCRIPT_DIR/const.sh"
source "$SCRIPT_DIR/pix-common.sh"

sudo-check

# Deploy files
log "info" "Deploying files to $PIX_DIR"
mkdir -p "$PIX_DIR"

for F in "${EXECUTABLES[@]}" "${SOURCES[@]}"; do
    mv "$SCRIPT_DIR/$F" "$PIX_DIR/$F"
done
# Set execute permissions
log "info" "Setting execute permissions"

for F in "${EXECUTABLES[@]}"; do
    if ! chmod +x "$PIX_DIR/$F"; then
        log "err" "chmod +x failed: $PIX_DIR/$F"
        exit "$ERR_EXECUTE_PERMISSION_DENIED"
    fi
done

# Create symlinks

# Upgrade OS

# Install pinned dependencies

# Update boot config

# Report
