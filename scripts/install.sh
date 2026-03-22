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
log "info" "Creating symlinks in $BIN_DIR"

for F in "${EXECUTABLES[@]}"; do
    NAME="${F%.sh}"
    LINK="$BIN_DIR/$NAME"
    TARGET="$PIX_DIR/$F"

    if [ -e "$LINK" ] && [ ! -L "$LINK" ]; then
        log "err" "$LINK exists and is not a symlink — remove it manually and re-run."
        exit "$ERR_SYMLINK_DUPLICATE"
    fi

    if [ ! -L "$LINK" ]; then
        if ! ln -s "$TARGET" "$LINK"; then
            log "err" "Failed to create symlink: $LINK → $TARGET"
            exit "$ERR_SYMLINK_CREATE"
        fi
        log "debug" "Linked: $NAME → $TARGET"
    fi
done

# Upgrade OS
log "info" "Upgrading OS packages"

if ! apt-get update -q; then
    log "err" "apt-get update failed."
    exit "$ERR_SYS_UPDATE"
fi

if ! apt-get upgrade -y -q; then
    log "err" "apt-get upgrade failed."
    exit "$ERR_SYS_UPDATE"
fi

# Install packages dependencies
log "info" "Installing dependencies"

if ! apt-get install -y -q "$PKG_V4L2_UTILS" "$PKG_FFMPEG"; then
    log "err" "Dependency install failed."
    exit "$ERR_DEP_UPDATE"
fi

# Update boot config

# Report
