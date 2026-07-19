#!/bin/bash
# =============================================================================
# Uninstall REPEACT package
#
# USAGE:
#   sudo ./uninstall.sh
#
# NOTE: no arch made since "self explaining"
# =============================================================================
set -euo pipefail

declare -r UNINSTALL_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$UNINSTALL_SOURCE/lib/errors"
source "$UNINSTALL_SOURCE/lib/const"
source "$UNINSTALL_SOURCE/lib/common"

# Remove deployed:
# - executables (scripts)
# - sources     (lib)
# - config      (edid)
rm -rf "$INSTALL_DIR"

# Remove symlinks
rm "$SYMLINK_DIR"/*

# Stop and disable services before removing them
for F in "${SERVICES[@]}"; do
    systemctl stop "$F" 2> /dev/null
    systemctl disable "$F" 2> /dev/null
done

# Remove deployed:
# - services
# - udev rules
for F in "${SERVICES[@]}"; do
    rm -f "$SYSTEMD_DIR/$F"
done
for F in "${RULES[@]}"; do
    rm -f "$UDEV_RULES_DIR/$F"
done

systemctl daemon-reload
udevadm control --reload-rules

# Remove boot config
log "info" "Checking $HW_CONFIG_FILE"
if [[ ! -f "$HW_CONFIG_FILE" ]]; then
    log "err" "Boot config not found: $HW_CONFIG_FILE"
    exit "$ERR_BOOT_CONF_NOT_FOUND"
fi

# WARNING !!
# Kept for "debug" only.
# Backup shall NOT be stored in "/boot/firmware/": could temper OS integrity !
#
# cp "$HW_CONFIG_FILE" "${HW_CONFIG_FILE}.bak.$(date +%Y%m%d%H%M%S)"

# Iterate over file and remove lines
for LINE in "${SETTINGS[@]}"; do
    if grep -qxF "$LINE" "$HW_CONFIG_FILE"; then
        log "info" "Removing: $LINE"
        sed -i "\|^${LINE}$|d" "$HW_CONFIG_FILE"
    else
        log "info" "Not found, skipping: $LINE"
    fi
done
