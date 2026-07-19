#!/bin/bash
# =============================================================================
# Hardware bridge setup: edid loader.
# This script will be triggered by systemd/udev when HDMI to CSI bridge is available.
# (TC358743, v4l2 video0 node)
#
# NOTE: This "script" failing is a fatal error and SHALL be handled (hence related service).
# Failure means that the bridge is not linked to MCU: device hardware issue only (not user end).
# =============================================================================
set -euo pipefail

source "/etc/repeact/lib/errors"
source "/etc/repeact/lib/const"
source "/etc/repeact/lib/common"

load_edid() {
    local edid_path="$CONFIG_DIR/$EDID_FILE"

    log "info" "Loading EDID from $EDID_FILE"
    if [[ ! -f $edid_path ]]; then
        log "err" "EDID file not found: $EDID_FILE"
        exit "$ERR_FILE_NOT_FOUND"
    fi

    if ! v4l2 -d "$VIDEO_DEVICE" --set-edid=file="$edid_path" > /dev/null; then
        log "err" "Video device not found: $VIDEO_DEVICE"
        exit "$ERR_VIDEO_DEVICE_NOT_FOUND"
    fi

    log "info" "EDID loaded successfully."
}

load_edid

exit "$ERR_OK"
