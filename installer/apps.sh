#!/bin/bash

run_command "yay -S --sudoloop --noconfirm neofetch micro zen-browser-bin rxvt-unicode edex-ui-bin qmmp blender kdenlive transmission-gtk viewnior freetube-bin virtualbox virtualbox-host-modules-arch virtualbox-guest-utils" "Install Apps?" "yes"

# Add user to Flatpak
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo

# Flatpak
flatpak install -y --user flathub com.github.rafostar.Clapper
flatpak install -y --user flathub org.nicotine_plus.Nicotine
flatpak install -y --user flathub org.keepassxc.KeePassXC
flatpak install -y --user flathub dev.vencord.Vesktop
flatpak install -y --user flathub org.kde.okular
flatpak install -y flathub com.github.tenderowl.norka
flatpak install -y flathub net.lutris.Lutris
flatpak install -y flathub com.valvesoftware.Steam
flatpak install -y flathub com.github.tchx84.Flatseal

# Configuring programs

# Virtualbox
sudo systemctl enable vboxservice

sudo modprobe vboxdrv

# View current version
vboxmanage -v | cut -dr -f1

# Change version according to previous command
wget https://download.virtualbox.org/virtualbox/7.1.4/Oracle_VM_VirtualBox_Extension_Pack-7.1.4.vbox-extpack
sudo vboxmanage extpack install Oracle_VM_VirtualBox_Extension_Pack-7.0.12.vbox-extpack
sudo usermod -aG vboxusers $USER


# Clean system
run_command "pacman -Syu" "yes"
run_command "sudo pacman -Sc" "yes"
run_command "sudo pacman -Qtdq" "yes"
run_command "sudo pacman -Rsn $(pacman -Qdtq)" "yes"

echo "Reboot one last time."

echo "------------------------------------------------------------------------"
