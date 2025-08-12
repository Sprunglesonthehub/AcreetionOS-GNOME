#!/bin/bash

# Calamares passes the mount point of the target system as the first argument.
INSTALL_ROOT=$1


# The path to the GDM config on the system being installed (Arch uses /etc/gdm/custom.conf)
GDM_CONFIG_FILE="${INSTALL_ROOT}/etc/gdm/custom.conf"

# The path to the TTY autologin override
TTY_AUTOLOGIN_CONF="${INSTALL_ROOT}/etc/systemd/system/getty@tty1.service.d/autologin.conf"

if [ -f "$GDM_CONFIG_FILE" ]; then
    # Use sed to find and comment out any autologin-related lines.
    sed -i -e 's/^\s*AutomaticLoginEnable\s*=.*/#&/' "$GDM_CONFIG_FILE"
    sed -i -e 's/^\s*AutomaticLogin\s*=.*/#&/' "$GDM_CONFIG_FILE"
fi

# Remove TTY autologin override if it exists
if [ -f "$TTY_AUTOLOGIN_CONF" ]; then
    rm -f "$TTY_AUTOLOGIN_CONF"
fi
```    Make sure this script is executable: `chmod +x /usr/local/bin/cleanup-gdm.sh`.
