#!/bin/bash
# =============================================================================
# pix-install.sh
# One-time system setup for the PIX capture pipeline
#
# Ref: "docs/archi/arch.drawio", "install-process" page.
# =============================================================================

# Ensure script will always fail (unsilently)
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/errors.sh"
source "$SCRIPT_DIR/const.sh"
source "$SCRIPT_DIR/pix-common.sh"

# Deploy files

# Set execute permissions

# Create symlinks

# Upgrade OS

# Install pinned dependencies

# Update boot config

# Report
