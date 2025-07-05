sudo rm -rf /var/cache/pacman/* && sudo rm -rf work/ && mkarchiso -v -w work -o out .
if [ "-f /usr/bin/ | grep mkarchiso" != "true" ] ; then
  sudo pacman -Syy mkarchiso --noconfirm
fi

sudo rm -rf /var/cache/pacman/* && sudo rm -rf work/ && mkarchiso -v -w work -o out/ .
