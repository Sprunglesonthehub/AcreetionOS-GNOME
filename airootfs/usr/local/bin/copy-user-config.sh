#!/bin/bash

# This script copies the configuration from the live ISO's /root directory
# to the newly created user's home directory on the target system.

# Calamares provides the target system's mount point as the first argument.
INSTALL_ROOT=$1

# Calamares sets these environment variables for the shellprocess module.
# We need them to know where the new user's home is and who they are.
NEW_USERNAME="$username"
NEW_USER_HOME="$userHome"

# --- Safety Checks ---
if [ -z "$INSTALL_ROOT" ] || [ -z "$NEW_USERNAME" ] || [ -z "$NEW_USER_HOME" ]; then
    echo "Error: Calamares environment variables not set. Exiting." >&2
    exit 1
fi

if [ ! -d "$INSTALL_ROOT/$NEW_USER_HOME" ]; then
    echo "Error: New user's home directory does not exist. Exiting." >&2
    exit 2
fi

# --- Main Logic ---

# The source directory on the live ISO
SOURCE_DIR="/root/"

# The destination directory on the installed system
DEST_DIR="$INSTALL_ROOT/$NEW_USER_HOME/"

echo "Copying configuration from $SOURCE_DIR to $DEST_DIR..."

# Use rsync for a robust copy. It preserves permissions and handles links.
# -a (archive) is equivalent to -rlptgoD.
# We exclude the cache directory as a best practice. Add others as needed.
rsync -a --exclude=".cache" "$SOURCE_DIR" "$DEST_DIR"

echo "Setting correct ownership for new user '$NEW_USERNAME'..."

# THIS IS THE MOST CRITICAL STEP.
# After copying, all files are owned by root. We must change ownership
# to the new user and their primary group.
chown -R "$NEW_USERNAME:$NEW_USERNAME" "$DEST_DIR"

echo "User configuration copy complete."

exit 0
