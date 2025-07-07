if [ "-f /usr/bin/ | grep archiso" != "true" ] ; then
  sudo pacman -Syy archiso --noconfirm
fi

sudo rm -rf /var/cache/pacman/* && sudo rm -rf work/ && mkarchiso -v -w work -o out/ .
