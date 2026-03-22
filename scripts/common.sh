#!/bin/bash
# =============================================================================
# common scripts functions
#
# Log levels :
#   debug    Verbose detail; only emitted when DEBUG=1        (white)
#   info     General operational messages                     (white)
#   notice   Significant but normal events                    (white)
#   warning  Unexpected condition; script continues           (orange)
#   err      Fatal failure; caller should exit immediately    (red)
#
# SWITCHING TO JOURNALD:
#   Replace the log() body below with the journald implementation at the
#   bottom of this file. No other script needs to change.
#
#   Useful journalctl commands:
#     journalctl -t pix-start              # logs for one script
#     journalctl -t pix-start -p warning   # filter by severity
#     journalctl -t pix-start -f           # follow live
# =============================================================================

# ANSI colours

# Debug messages, suppressed unless DEBUG=1.
log() {
	local LEVEL="$1"
	local MSG="$2"

	if [ "$LEVEL" = "debug" ] && [ "${DEBUG:-0}" != "1" ]; then
		return
	fi

	local COLOR
	case "$LEVEL" in
	info | notice) COLOR="$_COLOR_WHITE" ;;
	debug | warning) COLOR="$_COLOR_ORANGE" ;;
	err) COLOR="$_COLOR_RED" ;;
	*) COLOR="$_COLOR_RESET" ;;
	esac

	printf "${COLOR}[%-7s]${_COLOR_RESET} %s\n" "${LEVEL^^}" "$MSG" >&2
}

# Note: ensure that files is sourced after errors (since error dependencies)
sudo-check() {
	if [ "$EUID" -ne 0 ]; then
		log "err" "Must be run as root: sudo $(basename "$0")"
		exit "$ERR_SUDO"
	fi
}
