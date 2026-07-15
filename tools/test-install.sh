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

declare -r TOOLCHAIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$TOOLCHAIN_DIR/lib/errors"
source "$TOOLCHAIN_DIR/lib/const"
source "$TOOLCHAIN_DIR/lib/common"

declare -i PASS=0
declare -i FAIL=0

# =============================================================================
# Test report utility
# =============================================================================
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

# =============================================================================
# Ensure that packages scripts:
#   - are deployed in expected package location
#   - are executable (chmod +x)
#   - have a properly symlink assigned
# =============================================================================
check_executables() {
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
}

# =============================================================================
# Check packages sources (lib: common, const, errors) deployment (location)
# =============================================================================
check_sources() {
    log "info" "Checking sources"
    for F in "${SOURCES[@]}"; do
        TARGET="$INSTALL_DIR/$F"
        if [[ -f "$TARGET" ]]; then check "Deployed:   $TARGET" "ok"; else check "Deployed:   $TARGET" "fail"; fi
    done
}

# =============================================================================
# Check units (systemd services, udev rules) deployment (location)
# =============================================================================
check_units() {
    log "info" "Checking units"
    for F in "${SERVICES[@]}"; do
        TARGET="$SYSTEMD_DIR/$F"
        if [[ -f "$TARGET" ]]; then check "Deployed:   $TARGET" "ok"; else check "Deployed:   $TARGET" "fail"; fi
    done
    for F in "${RULES[@]}"; do
        TARGET="$UDEV_RULES_DIR/$F"
        if [[ -f "$TARGET" ]]; then check "Deployed:   $TARGET" "ok"; else check "Deployed:   $TARGET" "fail"; fi
    done
}

# =============================================================================
# Check edid deployment (location)
# =============================================================================
check_edid() {
    log "info" "Checking EDID"
    TARGET="$CONFIG_DIR/$EDID_FILE"
    if [[ -f "$TARGET" ]]; then check "Deployed: $TARGET" "ok"; else check "Deployed: $TARGET" "fail"; fi
}
# =============================================================================
# Check boot config has been properly modified (DTOs)
# =============================================================================
check_boot_config() {
    log "info" "Checking boot config"
    for LINE in "${SETTINGS[@]}"; do
        if grep -qxF "$LINE" "$HW_CONFIG_FILE"; then check "Boot config: $LINE" "ok"; else check "Boot config: $LINE" "fail"; fi
    done
}

report_test_results() {
    echo ""
    log "notice" "Results: $PASS passed, $FAIL failed."
    [[ "$FAIL" -eq 0 ]] && exit "$ERR_OK" || exit 1
}

main() {
    check_executables
    check_sources
    check_units
    check_edid
    check_boot_config
    report_test_results

    # Exit handled by report
    # Could be discussed
}

main
