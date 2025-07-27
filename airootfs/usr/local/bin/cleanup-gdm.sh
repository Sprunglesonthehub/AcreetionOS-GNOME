#!/bin/bash

# Calamares passes the mount point of the target system as the first argument.
INSTALL_ROOT=$1

# The path to the GDM config on the system being installed.
GDM_CONFIG_FILE="${INSTALL_ROOT}/etc/gdm3/custom.conf"

# Check if the file exists before trying to modify it.
if [ -f "$GDM_CONFIG_FILE" ]; then
    # Use sed to find and comment out any autologin-related lines.
    # This makes the operation safe even if the lines don't exist.
    sed -i -e 's/^\s*AutomaticLoginEnable\s*=.*/#&/' "$GDM_CONFIG_FILE"
    sed -i -e 's/^\s*AutomaticLogin\s*=.*/#&/' "$GDM_CONFIG_FILE"
fi
```    Make sure this script is executable: `chmod +x /usr/local/bin/cleanup-gdm.sh`.
