#!/usr/bin/bash

set -eoux pipefail

# Get module configuration JSON
MODULE_CONFIG_JSON="$1"

# Parse configuration options using jq
export XDG_CURRENT_DESKTOP=$(echo "$MODULE_CONFIG_JSON" | jq -r '.options.xdg_current_desktop // "KDE"')
curl -fsSL https://pkgs.netbird.io/install.sh | sh