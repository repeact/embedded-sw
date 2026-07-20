#!/bin/bash
# =============================================================================
# Source: Video streamer/feeder (external camera, computer, player...).
#         A "source being available" implies that an HDMI cable is connected
#         between device and any available AND working streamer/feeder.
# =============================================================================
# Source available deamon.
# Monitors source state and depending service:
# - source avail:   start
# - source unavail: stop
#
# NOTE: Near zero CPU load with script based on v4l2 event ("source changed").
#
# Documentation reference:
# https://www.kernel.org/doc/html/v4.9/media/uapi/v4l/vidioc-enuminput.html#input-status
# =============================================================================
set -euo pipefail

source "/etc/repeact/lib/errors"
source "/etc/repeact/lib/const"
source "/etc/repeact/lib/common"

declare -A CMD_MAP=(
    [wait_for_event]="wait_for_event"
    [manage_service]="manage_service"
)

wait_for_event() {
    log "info" "Waiting for source change event from $VIDEO_DEVICE"
    if ! v4l2 -d "$VIDEO_DEVICE" --wait-for-event=source_change=0; then
        log "err" "$VIDEO_DEVICE source changed event failed"
        exit "$ERR_SOURCE_CHANGED_EVENT_FAIL"
    fi

    exit "$ERR_OK"
}

get_signal_value() {
    local video_inputs
    local status_field
    local signal_bit_value

    log "info" "Getting signal value from $VIDEO_DEVICE"
    # Use v4l2-ctl instead of v4l2 wrapper to keep stdout
    if ! video_inputs=$(v4l2-ctl -d "$VIDEO_DEVICE" --list-input 2> /dev/null); then
        log "err" "Cannot access $VIDEO_DEVICE status"
        exit "$ERR_INPUT_STATUS_QUERY"
    fi

    # Extract status field which contains required flag
    status_field=$(awk '/Status/{print $3}' <<< "$video_inputs")

    if [[ -z "$status_field" ]]; then
        log "err" "Cannot access $VIDEO_DEVICE status data"
        exit "$ERR_INPUT_STATUS_NO_DATA"
    fi

    signal_bit_value=${status_field: -1}
    echo "$signal_bit_value"
}

manage_service() {
    local signal_bit_value
    signal_bit_value=$(get_signal_value)

    log "info" "Managing service depending on source avail/unavail for $VIDEO_DEVICE"
    if [[ "$signal_bit_value" -eq 0 ]]; then
        # systemctl start "$DAEMON_SERVICE_CALLEE"
        :
    else
        # systemctl stop "$DAEMON_SERVICE_CALLEE"
        :
    fi

    exit "$ERR_OK"
}

dispatch "$@"
