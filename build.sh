if [ "ls /usr/bin | grep mkarchiso" != "mkarchiso" ] ; then
   sudo pacman -Syy archiso --noconfirm
fi  

rm -rf work/ && rm -rf out/ && sudo '/usr/bin/mkarchiso'  -L AcreetionOS-GNOME -v -o ../ISO . -j4 && sudo rm -rf ./work

#qemu-system-x86_64 -m 8G -cpu qemu64 -smp 2 -drive file=/mnt/00e9d4db-14eb-4e08-9ac8-d714335eb7ac/VIRT_MANAGER/testing.qcow2,format=qcow2 -boot d -cdrom '/mnt/00e9d4db-14eb-4e08-9ac8-d714335eb7ac/Projects/ISO/AcreetionOS-GNOME-1.0-x86_64.iso'

