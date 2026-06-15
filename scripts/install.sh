#!/bin/bash
# =============================================================================
# One-time system install for REPEACT package
#
# USAGE:
#   sudo install.sh [--pkg-update] [--pkg-upgrade]
#
# OPTIONS:
#   --pkg-update    Also run apt-get update before installing dependencies.
#                   Recommended on first install. Omit for faster re-runs.
#   --pkg-upgrade   Also run apt-get upgrade before installing dependencies.
#                   Recommended on first install. Omit for faster re-runs.
# =============================================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/repeact-lib/errors"
source "$SCRIPT_DIR/repeact-lib/const"
source "$SCRIPT_DIR/repeact-lib/common"

# =============================================================================
# Parse arguments
# =============================================================================
DO_UPGRADE=false
DO_UPDATE=false

for ARG in "$@"; do
    case "$ARG" in
        --pkg-upgrade)
            DO_UPGRADE=true
            ;;
        --pkg-update)
            DO_UPDATE=true
            ;;
        *)
            log "err" "Unknown option: $ARG"
            log "info" "Usage: sudo install.sh [--upgrade]"
            exit "$ERR_INVALID_ARG"
            ;;
    esac
done

sudo-check

# =============================================================================
# Deploy files
# =============================================================================
log "info" "Deploying files to $REPEACT_DIR"

mkdir -p "$REPEACT_DIR"
mkdir -p "$REPEACT_DIR/repeact-lib"

for F in "${EXECUTABLES[@]}" "${SOURCES[@]}"; do
    mv "$SCRIPT_DIR/$F" "$REPEACT_DIR/$F"
done

mv "$SCRIPT_DIR/$CONFIG_DIR/edid.hex" "$REPEACT_DIR/edid.hex"

# =============================================================================
# Set execute permissions
# =============================================================================
log "info" "Setting execute permissions"

for F in "${EXECUTABLES[@]}"; do
    if ! chmod +x "$REPEACT_DIR/$F"; then
        log "err" "chmod +x failed: $REPEACT_DIR/$F"
        exit "$ERR_EXECUTE_PERMISSION_DENIED"
    fi
done

# =============================================================================
# Create symlinks
# =============================================================================
log "info" "Creating symlinks in $BIN_DIR"

for F in "${EXECUTABLES[@]}"; do
    NAME="${F%.sh}"
    LINK="$BIN_DIR/$NAME"
    TARGET="$REPEACT_DIR/$F"

    if [[ -e "$LINK" ]] && [[ ! -L "$LINK" ]]; then
        log "err" "$LINK exists and is not a symlink — remove it manually and re-run."
        exit "$ERR_SYMLINK_DUPLICATE"
    fi

    if [[ ! -L "$LINK" ]]; then
        if ! ln -s "$TARGET" "$LINK"; then
            log "err" "Failed to create symlink: $LINK → $TARGET"
            exit "$ERR_SYMLINK_CREATE"
        fi
        log "debug" "Linked: $NAME → $TARGET"
    fi
done

# =============================================================================
# Refresh package index (optionnal, highly recommended for first install)
#
# Use "--pkg-update" flag to enable
# =============================================================================
if [[ "$DO_UPDATE" = true ]]; then
    log "info" "Refreshing package index"
    if ! apt-get update -q; then
        log "err" "apt-get update failed."
        exit "$ERR_SYS_UPDATE"
    fi
else
    log "info" "Skipping OS update (pass --pkg-update to enable)."
fi
# =============================================================================
# Upgrade OS packages (optional)
#
# Use --pkg-upgrade flag to enable)
# =============================================================================
if [[ "$DO_UPGRADE" = true ]]; then
    log "info" "Upgrading OS packages"
    if ! apt-get upgrade -y -q; then
        log "err" "apt-get upgrade failed."
        exit "$ERR_SYS_UPGRADE"
    fi
else
    log "info" "Skipping OS upgrade (pass --pkg-upgrade to enable)."
fi

# =============================================================================
# Install required dependencies
# =============================================================================
log "info" "Installing dependencies"

if ! apt-get install -y -q "$PKG_V4L2_UTILS" "$PKG_FFMPEG"; then
    log "err" "Dependency install failed."
    exit "$ERR_DEP_UPDATE"
fi

# =============================================================================
# Update boot config
# =============================================================================
log "info" "Checking $HW_CONFIG_FILE"

if [[ ! -f "$HW_CONFIG_FILE" ]]; then
    log "err" "Boot config not found: $HW_CONFIG_FILE"
    exit "$ERR_BOOT_CONF_NOT_FOUND"
fi

REBOOT_NEEDED=false

for LINE in "${SETTINGS[@]}"; do
    if ! grep -qxF "$LINE" "$HW_CONFIG_FILE"; then
        log "info" "Adding: $LINE"
        printf '%s\n' "$LINE" >> "$HW_CONFIG_FILE"
        REBOOT_NEEDED=true
    fi
done

# =============================================================================
# Report
# =============================================================================
echo ""

if [[ "$REBOOT_NEEDED" == true ]]; then
    log "notice" "Install complete. New boot settings added — reboot required."
    log "notice" "Run: sudo reboot"
else
    log "notice" "Install complete. No reboot needed."
fi

exit "$ERR_OK"
