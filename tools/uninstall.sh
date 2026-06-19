#!/bin/bash
# =============================================================================
# Uninstall REPEACT package
#
# USAGE:
#   sudo ./uninstall.sh
#
# NOTE: no arch made since "self explaining"
# =============================================================================
set -uo pipefail

declare -r UNINSTALL_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$UNINSTALL_SOURCE/lib/errors"
source "$UNINSTALL_SOURCE/lib/const"
source "$UNINSTALL_SOURCE/lib/common"

# Remove deployed executables

# Remove sources

# Remove symlinks

# Remove EDID

# Remove boot config
