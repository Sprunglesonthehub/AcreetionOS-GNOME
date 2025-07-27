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

# Clear the cache
yes | pacman -Scc
