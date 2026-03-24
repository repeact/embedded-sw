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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "/etc/repeact/repeact-lib/errors.sh"
source "/etc/repeact/repeact-lib/const.sh"
source "/etc/repeact/repeact-lib/common.sh"

PASS=0
FAIL=0

check() {
    local DESC="$1"
    local RESULT="$2"

    if [ "$RESULT" = "ok" ]; then
        log "info" "  PASS: $DESC"
        ((PASS++))
    else
        log "warning" "  FAIL: $DESC"
        ((FAIL++))
    fi
}

# Executables
log "info" "Checking executables"
for F in "${EXECUTABLES[@]}"; do
    NAME="${F%.sh}"
    TARGET="$REPEACT_DIR/$F"
    LINK="$BIN_DIR/$NAME"

    if [ -f "$TARGET" ]; then check "Deployed:   $TARGET" "ok"; else check "Deployed:   $TARGET" "fail"; fi
    if [ -x "$TARGET" ]; then check "Executable: $TARGET" "ok"; else check "Executable: $TARGET" "fail"; fi
    if [ -L "$LINK" ] && [ "$(readlink "$LINK")" = "$TARGET" ]; then
        check "Symlink:     $LINK → $TARGET" "ok"
    else
        check "Symlink:     $LINK → $TARGET" "fail"
    fi
done

# Sources
log "info" "Checking sources"
for F in "${SOURCES[@]}"; do
    TARGET="$REPEACT_DIR/$F"
    if [ -f "$TARGET" ]; then check "Deployed:   $TARGET" "ok"; else check "Deployed:   $TARGET" "fail"; fi
done

# EDID
log "info" "Checking EDID"
if [ -f "$REPEACT_DIR/edid.hex" ]; then check "Deployed:   $REPEACT_DIR/edid.hex" "ok"; else check "Deployed:   $REPEACT_DIR/edid.hex" "fail"; fi

# Boot config
log "info" "Checking boot config"
for LINE in "${SETTINGS[@]}"; do
    if grep -qxF "$LINE" "$HW_CONFIG_FILE"; then check "Boot config: $LINE" "ok"; else check "Boot config: $LINE" "fail"; fi
done

# Report
echo ""
log "notice" "Results: $PASS passed, $FAIL failed."
[ "$FAIL" -eq 0 ] && exit "$ERR_OK" || exit 1
