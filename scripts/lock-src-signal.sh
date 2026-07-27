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
}

# Check if signal[pix_fmt] is already up to date (matches required pixel format).
pixel_fmt_matches() {
}

# =============================================================================
# Getters
# =============================================================================
read_timings() {
}

read_pixel_fmt() {
}

# =============================================================================
# Setters
# =============================================================================
update_pixel_fmt() {
}

lock_timings() {
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
