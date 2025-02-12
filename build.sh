if [ "ls /usr/bin | grep mkarchiso" != "mkarchiso" ] ; then
   sudo pacman -Syy archiso --noconfirm
fi  

rm -rf work/ && rm -rf out/ && sudo '/usr/bin/mkarchiso'  -L AcreetionOS-GNOME -v -o ../ISO . -j$nproc && sudo rm -rf ./work


