#!/bin/bash
# =============================================================================
# dv-timings/timings: refers to framerate and resolution
# video-format      : refers to pixel format
# signal            : dv-timings/video-format
# =============================================================================
# Negociate video-format and expose source-signals to other scripts.
# Handshake based on device advertised capabilities (EDID) and source capabilities.
#
# WARNING: Source will always force (hence stream) its own dv-timings.
# Locking signal does not guarantee that the source will never change dv-timings
# format on the fly.
# Picture this device as a display: screen is always the slave of the source with a
# given format that can, at any time, change.
#
# NOTE: Locking signal only sets pixel format (to UYVY, usually from BGR).
# NOTE: Edid avertise a "prefered" format which is set to 1920/1080p 30fps.
# =============================================================================
set -euo pipefail

source "/etc/repeact/lib/errors"
source "/etc/repeact/lib/const"
source "/etc/repeact/lib/common"

# =============================================================================
# Source state
#
# Modified by
# - read_pixel_fmt
# - read_timings
# Consumed by
# - report_config
# - pixel_fmt_matches
#
# Kept as shared state so main() can do two read/report without threading values
# through return values.
# =============================================================================

declare -gA signal=([pix_fmt]="" [width]="" [height]="" [framerate]="")

# =============================================================================
# Helpers
# =============================================================================
report_config() {
    local stage="${1:-Configuration}"
    log "info" "$stage: ${signal[width]}x${signal[height]}p@${signal[framerate]}fps|${signal[pix_fmt]}"
}

# Check if signal[pix_fmt] is already up to date (matches required pixel format).
pixel_fmt_matches() {
    [[ "${signal[pix_fmt]}" == "$REQUIRED_PIX_FMT" ]]
}

# =============================================================================
# Getters
# =============================================================================
read_timings() {
    local dv_timings

    log "info" "Reading video configuration"
    # NOTE: no call to "v4l2" wrapper: stout is required for dv-timings settings parsing
    if ! dv_timings=$(v4l2-ctl -d "$VIDEO_DEVICE" --query-dv-timings 2> /dev/null); then
        log "err" "Could not query $VIDEO_DEVICE dv-timings"
        exit "$ERR_QUERY_TIMINGS"
    fi

    signal[framerate]="$(awk -F'(' '/frames per second/{split($2,a," "); print int(a[1])}' <<< "$dv_timings")"
    signal[width]="$(awk '/Active width/{print $NF}' <<< "$dv_timings")"
    signal[height]="$(awk '/Active height/{print $NF}' <<< "$dv_timings")"
}

read_pixel_fmt() {
    local fmt_video

    log "info" "Reading pixel format"
    # NOTE: no call to "v4l2" wrapper: stout is required for pixel settings parsing
    if ! fmt_video=$(v4l2-ctl -d "$VIDEO_DEVICE" --get-fmt-video 2> /dev/null); then
        log "err" "Could not read current pixel format on $VIDEO_DEVICE"
        exit "$ERR_READ_FMT_VIDEO"
    fi

    signal[pix_fmt]="$(awk -F"'" '/Pixel Format/{print $2}' <<< "$fmt_video")"
}

# =============================================================================
# Setters
# =============================================================================
update_pixel_fmt() {
    log "info" "Setting new pixel format: \"${REQUIRED_PIX_FMT}\""
    if ! v4l2 -d "$VIDEO_DEVICE" --set-fmt-video=pixelformat="$REQUIRED_PIX_FMT"; then
        log "err" "Could not set new pixel format: \"${REQUIRED_PIX_FMT}\""
        exit "$ERR_WRITE_PIXEL_FMT"
    fi
}

lock_timings() {
    log "info" "Locking video timings"
    if ! v4l2 -d "$VIDEO_DEVICE" --set-dv-bt-timings query; then
        log "err" "Could not lock video timings"
        exit "$ERR_LOCK_SIGNAL"
    fi
}

main() {
    read_pixel_fmt
    read_timings
    report_config "Initial configuration"

    if ! pixel_fmt_matches; then
        update_pixel_fmt
    fi
    lock_timings

    read_pixel_fmt
    read_timings
    report_config "Current configuration"

    exit "$ERR_OK"
}

main "$@"
