#!/bin/bash
# =============================================================================
# Verify install script sanity
#
# AI written test, reviewed by developpers
#
# USAGE:
#   sudo ./test-install.sh
# =============================================================================
set -uo pipefail

declare -r INSTALL_DIR="/etc/repeact" # bootstrap — redefined by const.sh

source "$INSTALL_DIR/lib/errors"
source "$INSTALL_DIR/lib/const"
source "$INSTALL_DIR/lib/common"

declare -i PASS=0
declare -i FAIL=0

check() {
    declare -r DESC="$1"
    declare -r RESULT="$2"

    if [[ "$RESULT" == "ok" ]]; then
        log "info" "  PASS: $DESC"
        ((PASS++))
    else
        log "warning" "  FAIL: $DESC"
        ((FAIL++))
    fi
}

log "info" "Checking executables"
declare NAME TARGET LINK
for F in "${EXECUTABLES[@]}"; do
    NAME="${F%.sh}"
    TARGET="$INSTALL_DIR/$F"
    LINK="$SYMLINK_DIR/$NAME"
    if [[ -f "$TARGET" ]]; then check "Deployed:   $TARGET" "ok"; else check "Deployed:   $TARGET" "fail"; fi
    if [[ -x "$TARGET" ]]; then check "Executable: $TARGET" "ok"; else check "Executable: $TARGET" "fail"; fi
    if [[ -L "$LINK" ]] && [[ "$(readlink "$LINK")" == "$TARGET" ]]; then
        check "Symlink:     $LINK → $TARGET" "ok"
    else
        check "Symlink:     $LINK → $TARGET" "fail"
    fi
done

# Sources
log "info" "Checking sources"
for F in "${SOURCES[@]}"; do
    TARGET="$INSTALL_DIR/$F"
    if [[ -f "$TARGET" ]]; then check "Deployed:   $TARGET" "ok"; else check "Deployed:   $TARGET" "fail"; fi
done

# EDID
log "info" "Checking EDID"
TARGET="$CONFIG_DIR/$EDID_FILE"
if [[ -f "$TARGET" ]]; then check "Deployed: $TARGET" "ok"; else check "Deployed: $TARGET" "fail"; fi

# Boot config
log "info" "Checking boot config"
for LINE in "${SETTINGS[@]}"; do
    if grep -qxF "$LINE" "$HW_CONFIG_FILE"; then check "Boot config: $LINE" "ok"; else check "Boot config: $LINE" "fail"; fi
done

# Report
echo ""
log "notice" "Results: $PASS passed, $FAIL failed."
[[ "$FAIL" -eq 0 ]] && exit "$ERR_OK" || exit 1
