# Required project constants

# Install paths
REPEACT_DIR="/etc/repeact"
BIN_DIR="/usr/local/bin" # Symlinks
CONFIG_DIR="$SCRIPT_DIR/../config"
HW_CONFIG_FILE="/boot/firmware/config.txt"

# Pinned dependency
# Hardcoded intentionally: simplified bug tracking
PKG_V4L2_UTILS="v4l-utils=1.30.1*"
PKG_FFMPEG="ffmpeg=7.1*"

# Scripts deployed (to $REPEACT_DIR)
# w/ chmod +x
# w/ symlinks ($BIN_DIR)
EXECUTABLES=(
)

# Required dependencies files
SOURCES=(
    "common.sh"
    "const.sh"
    "errors.sh"
)

# Required hardware config (DTO, in HW_CONFIG_FILE)
SETTINGS=(
	"camera_auto_detect=0"
	"dtoverlay=tc358743"
	"dtoverlay=cma,cma-128"
	"gpu_mem=128"
	"enable_uart=1"
	"dtoverlay=disable-bt"
)
