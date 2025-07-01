#!/bin/bash

set -e -u

# Set a password for the root user.
# You can leave this commented out if you don't need root login on the live iso.
# sed -i 's/^root:!/root:$6$VAnSj7p2s4y9uYOF$l5sE03l1QLvi223zC1OStp3hX3uU2SST1UWFPt1p56qtqcL73LRgqjR441M1issBGj5n1wuc3I.rSTsXyL9s0\//' /etc/shadow

# Enable GDM (GNOME Display Manager) service
systemctl enable gdm.service

# Enable NetworkManager for live environment
systemctl enable NetworkManager.service

# Set the clock
timedatectl set-ntp true

# Refresh repos
pacman-key --init
pacman-key --populate archlinux

# Clear the cache
yes | pacman -Scc


# --- NEW SECTION: Move Calamares autostart file into place ---
# This runs *after* packages are installed, so the directory exists.
# The -p flag ensures the directory exists without causing an error if it's already there.
#!/bin/bash
set -e

# Clean up any broken or old kernel references
rm -rf /lib/modules/6.12.35-1-lts || true

# Disable hostonly mode for dracut
mkdir -p /etc/dracut.conf.d
echo 'hostonly="no"' > /etc/dracut.conf.d/disable-hostonly.conf

# Install required packages without triggering auto initramfs
DRACUT_NO_IMAGE="yes" pacman -Sy --noconfirm linux-lts linux-lts-headers dracut broadcom-wl

# Get the current kernel version
KVER=$(ls /lib/modules | grep lts | head -n1)

# Remove DKMS builds for old kernels if needed
dkms remove broadcom-wl/6.30.223.271 --all || true

# Install DKMS module for the LTS kernel
dkms install broadcom-wl/6.30.223.271 -k "$KVER"

# Generate initramfs with dracut
dracut --force --no-hostonly "/boot/initramfs-linux-lts.img" "$KVER"

# Manually copy kernel image to /boot
cp "/usr/lib/modules/${KVER}/vmlinuz" "/boot/vmlinuz-linux-lts"

