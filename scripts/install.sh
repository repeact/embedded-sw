#!/bin/bash
# =============================================================================
# One-time system install for REPEACT package
#
# USAGE:
#   sudo install.sh [--pkg-update] [--pkg-upgrade]
#
# OPTIONS:
#   --update    Also run apt-get update before installing dependencies.
#               Recommended on first install. Omit for faster re-runs.
#   --upgrade   Also run apt-get upgrade before installing dependencies.
#               Recommended on first install. Omit for faster re-runs.
# =============================================================================
set -uo pipefail

declare -r DEPLOY_SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$DEPLOY_SRC/lib/errors"
source "$DEPLOY_SRC/lib/const"
source "$DEPLOY_SRC/lib/common"

# =============================================================================
# Parse arguments
# =============================================================================
declare DO_UPGRADE=false
declare DO_UPDATE=false

parse_args() {
    for ARG in "$@"; do
        case "$ARG" in
            --upgrade)
                DO_UPGRADE=true
                ;;
            --update)
                DO_UPDATE=true
                ;;
            *)
                log "err" "Unknown option: $ARG"
                log "info" "Usage: sudo install.sh [--upgrade]"
                exit "$ERR_INVALID_ARG"
                ;;
        esac
    done
}

# =============================================================================
# Deploy package files
# =============================================================================
deploy_files() {
    log "info" "Deploying files to $INSTALL_DIR"

    mkdir -p "$INSTALL_DIR"
    mkdir -p "$INSTALL_DIR/lib"
    mkdir -p "$CONFIG_DIR"

    for F in "${EXECUTABLES[@]}" "${SOURCES[@]}"; do
        mv "$DEPLOY_SRC/$F" "$INSTALL_DIR/$F"
    done

    mv "config/$EDID_FILE" "$CONFIG_DIR/$EDID_FILE"

}

# =============================================================================
# Set execute permissions
# =============================================================================
set_permission() {
    log "info" "Setting execute permissions"

    for F in "${EXECUTABLES[@]}"; do
        if ! chmod +x "$INSTALL_DIR/$F"; then
            log "err" "chmod +x failed: $INSTALL_DIR/$F"
            exit "$ERR_EXECUTE_PERMISSION_DENIED"
        fi
    done
}

# =============================================================================
# Create symlinks
# =============================================================================
create_symlinks() {
    log "info" "Creating symlinks in $SYMLINK_DIR"

    declare NAME LINK TARGET
    for F in "${EXECUTABLES[@]}"; do
        NAME="${F%.sh}"
        LINK="$SYMLINK_DIR/$NAME"
        TARGET="$INSTALL_DIR/$F"

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
}

# =============================================================================
# Refresh package index (optionnal, highly recommended for first install)
#
# Use "--pkg-update" flag to enable
# =============================================================================
update_packages() {
    if [[ "$DO_UPDATE" = true ]]; then
        log "info" "Refreshing package index"
        if ! apt-get update -q; then
            log "err" "apt-get update failed."
            exit "$ERR_SYS_UPDATE"
        fi
    else
        log "info" "Skipping OS update (pass --pkg-update to enable)."
    fi
}
# =============================================================================
# Upgrade OS packages (optional)
#
# Use --pkg-upgrade flag to enable)
# =============================================================================
upgrade_packages() {
    if [[ "$DO_UPGRADE" = true ]]; then
        log "info" "Upgrading OS packages"
        if ! apt-get upgrade -y -q; then
            log "err" "apt-get upgrade failed."
            exit "$ERR_SYS_UPGRADE"
        fi
    else
        log "info" "Skipping OS upgrade (pass --pkg-upgrade to enable)."
    fi
}

# =============================================================================
# Install required dependencies
# =============================================================================
install_req_dependencies() {
    log "info" "Installing dependencies"

    if ! apt-get install -y -q "$PKG_V4L2_UTILS" "$PKG_FFMPEG"; then
        log "err" "Dependency install failed."
        exit "$ERR_DEP_UPDATE"
    fi
}

# =============================================================================
# Update boot config
# =============================================================================
declare REBOOT_NEEDED=false
update_boot_config() {
    log "info" "Checking $HW_CONFIG_FILE"

    if [[ ! -f "$HW_CONFIG_FILE" ]]; then
        log "err" "Boot config not found: $HW_CONFIG_FILE"
        exit "$ERR_BOOT_CONF_NOT_FOUND"
    fi

    for LINE in "${SETTINGS[@]}"; do
        if ! grep -qxF "$LINE" "$HW_CONFIG_FILE"; then
            log "info" "Adding: $LINE"
            printf '%s\n' "$LINE" >> "$HW_CONFIG_FILE"
            REBOOT_NEEDED=true
        fi
    done
}

# =============================================================================
# Report
# =============================================================================
report() {
    echo ""

    if [[ "$REBOOT_NEEDED" == true ]]; then
        log "notice" "Install complete. New boot settings added — reboot required."
        log "notice" "Run: sudo reboot"
    else
        log "notice" "Install complete. No reboot needed."
    fi
}

main() {
    sudo_check
    parse_args "$@"
    deploy_files
    set_permission
    create_symlinks
    update_packages  # optionnal: use --update
    upgrade_packages # optionnal: use --upgrade
    install_req_dependencies
    update_boot_config
    report

    exit "$ERR_OK"
}

main "$@"
