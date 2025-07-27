#!/bin/bash

# This script syncs the user's GTK theme (light/dark) to a Qt6 config file
# that Calamares (running as root) can read.

# Path for the temporary config file
CONF_DIR="/tmp/qt6ct"
CONF_FILE="$CONF_DIR/qt6ct.conf"

# Ensure the config directory exists
mkdir -p "$CONF_DIR"

# Detect the current GSettings color scheme
# 'prefer-dark' is the value for dark mode in GNOME
COLOR_SCHEME=$(gsettings get org.gnome.desktop.interface color-scheme)

# Default to light theme
QT_STYLE="Adwaita"

if [[ "$COLOR_SCHEME" == *'prefer-dark'* ]]; then
    QT_STYLE="Adwaita-Dark"
fi

# Write the configuration for qt6ct
# This sets the theme style for Qt applications
cat > "$CONF_FILE" << EOF
[Appearance]
style=$QT_STYLE
icon_theme=Adwaita

[General]
font_antialiasing=true
EOF

# Make the file readable by everyone (including the root process)
chmod 644 "$CONF_FILE"

echo "Qt theme synced to $QT_STYLE."
