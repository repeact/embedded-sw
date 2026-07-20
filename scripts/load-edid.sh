#!/bin/bash
# =============================================================================
# Bridge     : HDMI to CSI bridge based on toshiba TC358743 (=> continued as TC9590XBG).
# Device/sink: Device receiving video feed (current, alias "repeact").
# EDID       : "Extended Display Identification Data".
#              Sink video capabilities advertizer with some metadatas.
# =============================================================================
# Hardware bridge setup.
# Load edid file into HDMI bridge.
# 
# This script is triggered by udev+systemd units when bridge is available (v4l2 video0 node).
# EDID is loaded/stored into bridge memory without needing a source available (no cable connected).
#
# WARNING: This script@service failing is a fatal error and SHALL be handled carefully.
# A failure means that the bridge is not linked to the MCU (RPI here) which ALWAYS means
# that hardware is broken (PCB and/or flexible cable).
# This is why all of the package's script@services rely on this script@service success.
#
# Documentation reference:
# https://toshiba.semicon-storage.com/info/TC358743XBG_datasheet_en_20260511.pdf?did=35655&prodName=TC358743XBG
# https://ia801404.us.archive.org/3/items/CEA-861-B/CEA-861-B.pdf
#
# Tool references for building custom EDID:
# https://edid.build/
# https://thyge.github.io/edid-editor/
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

    if ! v4l2 -d "$VIDEO_DEVICE" --set-edid=file="$edid_path"; then
        log "err" "Video device not found: $VIDEO_DEVICE"
        exit "$ERR_VIDEO_DEVICE_NOT_FOUND"
    fi

    log "info" "EDID loaded successfully."
}

load_edid

exit "$ERR_OK"
