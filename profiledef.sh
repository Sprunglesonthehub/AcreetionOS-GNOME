#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="AcreetionOS-GNOME"
iso_label="Acreetionos-GNOME-1.0"
iso_publisher="AcreetionOS <Nataile Spiva>"
iso_application="AcreetionOS Live/Rescue DVD"
iso_version="1.0"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito'
           'uefi-ia32.systemd-boot.esp' 'uefi-x64.systemd-boot.esp'
           'uefi-ia32.systemd-boot.eltorito' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/local/bin/Installation_guide"]="0:0:755"
  ["/usr/local/bin/livecd-sound"]="0:0:755"
)

# Dracut boot function

### Custom build function to use dracut instead of mkinitcpio ###
# This function is automatically called by the archiso build script.
# It runs inside the chroot environment after packages are installed.
# See: https://wiki.archlinux.org/title/Archiso#Customizing_the_live_system

build_custom_airootfs() {
  # Get the installed kernel version to pass to dracut
  # This finds the directory in /usr/lib/modules/ for the installed kernel
  local _kernel
  _kernel="$(basename "$(find /usr/lib/modules -maxdepth 1 -type d -name '*-arch*')")"

  # Log what we are doing
  echo ">>> Running dracut to generate initramfs for kernel: ${_kernel}"

  # Generate the main initramfs.
  # We explicitly name the output file to what mkarchiso expects.
  # The "archiso" module is a dracut module for live systems.
  dracut --force --no-hostonly --add "archiso" \
         "/boot/initramfs-linux.img" "${_kernel}"

  # Check if the file was created. If not, fail the build.
  if [[ ! -f "/boot/initramfs-linux.img" ]]; then
    echo "!!! Dracut failed to create /boot/initramfs-linux.img. Aborting."
    return 1
  fi

  echo ">>> Dracut initramfs created successfully."
}
