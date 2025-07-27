# Lead Maintainer: Natalie Spiva <sprungles.me@proton.me"
# Secondary Maintainer: Darren Clift <cobra3282000@live.com>

# Changes
# If you are going to edit this document, put your changes directly below:
# 
# Change 1:
# Initial information provided, as well as comments, as well as options to push to github/gitlab.
#
#
###############################################################################
echo "###############################################################################"
echo " THERE ARE 2 USER SET VARIABLES IN THIS SCRIPT. GO MODIFY THEM ACCORDINGLY.    "
echo "                     The Variables are for URLS :)                             "
echo "###############################################################################"



echo "###############################################################################"
echo "#                    THIS SCRIPT MUST BE RUN AS ROOT                           "
echo "###############################################################################"
sleep 3

# Warning to only use SSH
echo "This script is not using the HTTPS protocal when pushing with git. MAKE SURE YOU HAVE SSH CONFIGURED."
sleep 5

# Reminding the user to set up their GIT Configuration
echo "If you have not set up your git configuration, do so in the following format:"
sleep 1
echo "git config --global user.email "you@example.com" " 
echo "git config --global user.name "Your Name" " 

# Ask if they want to configure their git...
read -p "Have you already configured git? (Y/N)" yn
if [[ "$yn" == "y" || "$yn" == "Y" || "$yn" == "yes" || "$yn" == "Yes" || "$yn" == "YES" ]] ; then
 echo "Continuing..."
else
 exit;
fi

# Checking if archiso (the package that incluldes mkarchiso script) is installed, and installing if necessary
if [ "-f /usr/bin/ | grep archiso" > /dev/null ] ; then
  sudo pacman -Syy archiso --noconfirm
fi

# Removing the local cache, removing work directory, building ISO
sudo rm -rf /var/cache/pacman/* && sudo rm -rf work/ && mkarchiso -v -w work -o out/ .

# Remove the work directory
rm -rf work/

# Variable set for the GitLab Repository. YOU MUST USE SSH.
gitlabserver="ssh://git@darrengames.ddns.net:2402/sprungles/acreetonos-gnome.git"

# Giving the user the option to push to gitlab
read -p "Would you like to push to GitLab? (Y/N): " gitlab
if [[ "$gitlab" == "Y" || "$gitlab" == "y" || "$gitlab" == "Yes" || "$gitlab" == "YES" || "$gitlab" == "yes" ]]; then
  echo "Removing ISO, because it is to large..."
  rm -rf out/*
  sleep 2
  echo "Removing work directory, it's massive... and not necessary"
  rm -rf work/
  sleep 2
  git add .
  git remote add gitlab $gitlabserver
  git pull 
  git commit -m "Generic Push. Read the code."
  git push origin main
fi

# Variable set for the GitHub Repository. YOU MUST USE SSH.
githubserver="git@github.com:Sprunglesonthehub/AcreetionOS-GNOME.git"

# Giving the use the option to push to github
read -p "Would you like to push to GitHub? (Y/N): " github
if [[ "$github" == "Y" || "$github" == "y" || "$github" == "Yes" || "$github" == "YES" || "$githubs" == "yes" ]]; then
  echo "Removing ISO, because it's to large..."
  rm -rf out/*
  echo "Removing work directoyr, it's massive... and not necessary"
  rm -rf work/
  sleep 2
  git add .
  git remote add github $githubserver
  git pull
  git commit -m "Generic Push. Read the Code."
  git push github main
else
  echo "Thanks for being here and do what you do best. You are appreciated, and I hope you have a great day :D "
fi
