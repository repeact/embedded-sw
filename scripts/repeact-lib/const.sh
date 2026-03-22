# Required project constants

# Install paths
PIX_DIR="/etc/pix"
BIN_DIR="/usr/local/bin"
CONFIG_FILE="/boot/firmware/config.txt"

# Pinned dependency versions
# Hardcoded intentionally: simplified bug tracking
PKG_V4L2_UTILS="v4l-utils=1.30.1*"
PKG_FFMPEG="ffmpeg=7.1*"

# Scripts deployed (to $PIX_DIR)
# w/ chmod +x
# w/ symlinks ($BIN_DIR)
EXECUTABLES=(
)

# Required dependencies files
SOURCES=(
    "common.sh"
    "const.sh"
    "errors.sh"
    "edid.hex"
)

# Required hardware config (DTO, in DT$CONFIG_FILE)
SETTINGS=(
	"camera_auto_detect=0"
	"dtoverlay=tc358743"
	"dtoverlay=cma,cma-128"
	"gpu_mem=128"
	"enable_uart=1"
	"dtoverlay=disable-bt"
)
