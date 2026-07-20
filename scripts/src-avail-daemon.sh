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
}

get_signal_value() {
}

manage_service() {
}

dispatch "$@"
