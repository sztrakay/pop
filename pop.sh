#!/bin/bash


# POP!_OS Post-Install Script
# This script automates the process of setting up a fresh installation of POP!_OS by 
# installing various programs and packages and configuring the system to the user's 
# preferences. It is estimated to take approximately 15 minutes to run.

# Parts of the code were written by ChatGPT, a language model developed by OpenAI 
# (https://chat.openai.com). Specifically, the code includes instructions for 
# downloading the latest releases of FreeTube and Simplenote from GitHub.


# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.


# Clear the terminal and prepare variables
sudo clear
cd ~
STARTPKGS=$(apt list --installed 2>/dev/null | wc -l)
SECONDS=0
CY="\033[30;43;3m"
CY2="\033[33;49;3m"
CN="\033[39;49;0m"
CN2="\033[39;49;3m"


# Welcome message
echo -e "${CY} POP!_OS post-install script ${CN}\n"
echo -e "${CY2} This script will set up the system and my desktop in about 15 minutes."
echo -e "${CY2} Please make sure you have an active internet connection before continuing."
read -rsn1 -p " Press Enter to continue!"
echo -e "${CN} "


# Set the resolution
echo -e "\n${CY} Changing display resolution to 1920x1080 ${CN}"
sleep 1
xrandr -s 1920x1080
sleep 1


# Change Gnome settings
echo -e "\n${CY} Changing Gnome settings (button layout, power deamon, privacy, etc.) ${CN}"
sleep 1
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.desktop.screensaver idle-activation-enabled false
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled true
gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 30
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.settings-daemon.plugins.power lid-close-ac-action 'suspend'
gsettings set org.gnome.settings-daemon.plugins.power lid-close-battery-action 'suspend'
gsettings set org.gnome.settings-daemon.plugins.power lid-close-suspend-with-external-monitor false
gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'
gsettings set org.gnome.settings-daemon.plugins.power power-saver-profile-on-low-battery true
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 1200
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 1200
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
gsettings set org.gnome.shell.extensions.pop-cosmic show-application-menu false
gsettings set org.gnome.shell.extensions.pop-cosmic show-applications-button false
gsettings set org.gnome.shell.extensions.pop-cosmic show-workspaces-button false
gsettings set org.gnome.desktop.privacy disable-camera true
gsettings set org.gnome.desktop.privacy disable-microphone true


# Create directories and bookmarks
echo -e "\n${CY} Create my directories and Nautilus bookmarks ${CN}"
sleep 1
mkdir -vp \
  Documents/Books \
  Downloads/Torrents \
  Downloads/Installers \
  Downloads/Scripts \
  Videos/Sleep \
  Pictures/Wallpapers \
  Pictures/Icons \
  Pictures/Photos \
  Pictures/Screenshots
echo -e file:///home/$USER/Downloads/Torrents Torrents\ >> ~/.config/gtk-3.0/bookmarks
echo -e file:///home/$USER/Downloads/Scripts Scripts\ >> ~/.config/gtk-3.0/bookmarks
echo -e file:///home/$USER/Dropbox Dropbox\ >> ~/.config/gtk-3.0/bookmarks


# Add extra repositories
echo -e "\n${CY} Enable the Universe and Multiverse repositories ${CN}"
sleep 1
sudo add-apt-repository -y universe
sudo add-apt-repository -y multiverse
sudo apt-add-repository -ys ppa:system76-dev/stable
# Add WebP support
sudo add-apt-repository -ys ppa:helkaluin/webp-pixbuf-loader


# Update and upgrade the system
echo -e "\n${CY} Update and upgrade the system - this can take some time. ${CN}"
sleep 1
sudo apt-get update -y
sudo apt upgrade -y
sudo apt autoremove -y


# Install some packages
echo -e "\n${CY} Installing my favorite packages (+fonts +Steam) ${CN}"
sleep 1
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections && sudo apt install ttf-mscorefonts-installer -y
sudo apt install -y wget nautilus-admin gir1.2-gtop-2.0 python3-gpg transmission htop lm-sensors neofetch cpufetch ubuntu-restricted-extras gamemode mpv gnome-tweaks rhythmbox gnome-boxes youtube-dl steam gdebi-core spice-webdavd spice-client-gtk fortune firmware-b43-installer system76-wallpapers webp-pixbuf-loader


# Comment out the line "127.0.1.1	pop-os.localdomain	pop-os" in the /etc/hosts file
echo -e "\n${CY} Modifying /etc/hosts file ${CN}"
sleep 1
cp /etc/hosts hosts.bak
sudo sed -i '/127.0.1.1.*pop-os/ s/^/#/' /etc/hosts


# Add some useful aliases to .bash_aliases file
echo -e "\n${CY} Add some useful aliases to .bash_aliases file ${CN}"
sleep 1
echo "alias friss='sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && flatpak uninstall --unused -y && flatpak update -y'" >> ~/.bash_aliases
echo "alias frissl='sudo apt update -y && sudo apt list --upgradable'" >> ~/.bash_aliases
echo "alias cls='clear'" >> ~/.bash_aliases
source ~/.bash_aliases


# Download the latest release of Dropbox from the official source
echo -e "\n${CY} Downloading and installing Dropbox ${CN}"
sleep 1
wget -O ~/Downloads/Installers/dropbox.deb "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2020.03.04_amd64.deb"

# Install Dropbox and Nautilus integration
sudo gdebi ~/Downloads/Installers/dropbox.deb --n
sudo apt install nautilus-dropbox -y
sleep 1

# Start Dropbox in the background
dropbox start -i 2>/dev/null 
sleep 1
echo -e " "
echo -e "${CY2}   Sign in to Dropbox in the web browser! Wait until the synchronizing is done."
read -rsn1 -p "   Then, press Enter here in the terminal to continue!"
echo -e "${CN} "


# Download the latest release of Discord from official source
echo -e "\n${CY} Downloading and installing more programs (Discord, Freetube, Simplenote) ${CN}"
sleep 1
wget -O ~/Downloads/Installers/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"

# Install Discord
sudo gdebi ~/Downloads/Installers/discord.deb --n


# Download the latest release of FreeTube from GitHub (This code was written by ChatGPT)
latest_release=$(wget -qO- https://github.com/FreeTubeApp/FreeTube/releases | grep -oP 'href="/FreeTubeApp/FreeTube/releases/tag/v\K[^/"]*' | head -1)
latest_release_no_beta=${latest_release%-*}
wget "https://github.com/FreeTubeApp/FreeTube/releases/download/v${latest_release}/freetube_${latest_release_no_beta}_amd64.deb" --show-progress -q -O ~/Downloads/Installers/freetube.deb

# Install FreeTube using gdebi
sudo gdebi ~/Downloads/Installers/freetube.deb --n


# Download the latest release of Simplenote from GitHub (This code was written by ChatGPT)
latest_release=$(wget -qO- https://github.com/Automattic/simplenote-electron/releases | grep -oP 'href="/Automattic/simplenote-electron/releases/tag/v\K[^/"]*' | head -1)
latest_release_no_beta=${latest_release%-*}
wget "https://github.com/Automattic/simplenote-electron/releases/download/v${latest_release}/Simplenote-linux-${latest_release_no_beta}-amd64.deb" --show-progress -q -O ~/Downloads/Installers/simplenote.deb

# Install Simplenote using gdebi
sudo gdebi ~/Downloads/Installers/simplenote.deb --n

# Fix the Simplenote bug with the "--no-sandbox" flag
sudo sed -i '/^Exec/ s/$/ --no-sandbox/' /usr/share/applications/simplenote.desktop


# Download the latest release of Battle.net installer
echo -e "\n${CY} Downloading Battle.net installer ${CN}"
sleep 1
wget -O ~/Downloads/Installers/Battle.net-Setup.exe "https://www.battle.net/download/getInstallerForGame?os=win&gameProgram=BATTLENET_APP&version=Live"


# Copy my files from Dropbox
echo -e "\n${CY} Copying some files from Dropbox ${CN}"
sleep 1
cp ~/Dropbox/POP/scripts/* ~/Downloads/Scripts/
cp ~/Dropbox/POP/desktop/* ~/.local/share/applications/
cp ~/Dropbox/POP/pictures/icons/* ~/Pictures/Icons/
cp ~/Dropbox/POP/appimages/* ~/Downloads/Installers/
cp ~/Dropbox/POP/deb/* ~/Downloads/Installers/
mkdir -p ~/.config/autostart
cp ~/Dropbox/POP/autostart/* ~/.config/autostart/
cp -r ~/Dropbox/POP/config/* ~/.config/

# Copy and set my wallpaper from Dropbox
echo -e "\n${CY} Copying and setting my wallpaper from Dropbox ${CN}"
sleep 1
cp ~/Dropbox/POP/pictures/wallpapers/* ~/Pictures/Wallpapers/
gsettings set org.gnome.desktop.background picture-uri 'file:///home/'$USER'/Pictures/Wallpapers/mypopwp.jpg'
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///home/'$USER'/Pictures/Wallpapers/mypopwp.jpg'

# Copy the Rhythmbox plugin from Dropbox
echo -e "\n${CY} Copying Rhythmbox tray icon plugin from Dropbox ${CN}"
sleep 1
mkdir -p ~/.local/share/rhythmbox/plugins
cp -r ~/Dropbox/POP/rhythmbox/* ~/.local/share/rhythmbox/plugins/


# Finishing message
DURATION=$SECONDS
ENDPKGS=$(apt list --installed 2>/dev/null | wc -l)
PKGS=$((ENDPKGS - STARTPKGS))
echo -e "\n${CY2} The script installed ${CN2}$PKGS${CY2} packages, and took $(($DURATION / 60)) minutes and $(($DURATION % 60)) seconds to complete."
echo -e " It is now time to reboot. To do so, just type in the terminal: ${CN2}reboot${CY2} and hit Enter.${CN}\n"

# END

