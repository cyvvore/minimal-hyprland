#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source helper file
source $SCRIPT_DIR/helper.sh

log_message "Installation started for prerequisites section"
print_info "\nStarting prerequisites setup..."

run_command "sudo pacman -Syyu --noconfirm" "Update package database and upgrade packages (Recommended)" "yes" # no

run_command "sudo pacman -S --noconfirm git pkgfile" "Checking for git & pkgfile"

run_command "sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si" "Install YAY (Must)/Breaks the script" "yes";

run_command "yay -S --sudoloop --noconfirm hyprland dunst tofi waybar-cava cava swww wlogout grimblast-git slurp grim cliphist hyprlock hypridle hyprpicker" "Install Window Manager?" "yes" 

run_command "yay -S --sudoloop --noconfirm sddm qt5-quickcontrols qt5-quickcontrols2 qt5-graphicaleffects qt5-svg"  "Install Display Manager?" "yes"

# Applying SDDM Theme

echo "Downloading WarGames theme..."
wget -O wargames-sddm.zip "https://github.com/vinceliuice/Wargus-sddm/releases/download/2024-02-07/Wargus-sddm.zip"

echo "Extracting theme..."
unzip -q wargames-sddm.zip -d wargames-theme
THEME_DIR="wargames-theme/Wargus"

echo "Applying font system-wide..."
mkdir -p ~/.local/share/fonts
find "$THEME_DIR" -maxdepth 1 -iname "*.ttf" -exec cp -v {} ~/.local/share/fonts/ \;

echo "Refreshing font cache..."
fc-cache -f

echo "Setting Wargus as the default SDDM theme..."
sudo tee /etc/sddm.conf > /dev/null <<EOF
[Theme]
Current=Wargus
EOF

run_command "systemctl enable sddm.service" "Enabling SDDM" "yes"

run_command "yay -S --sudoloop --noconfirm dim-screen libportal libportal-gtk3 libportal-gtk4 xdg-desktop-portal-gtk xdg-desktop-portal-hyprland hyprpolkitagent hyprcursor hyprutils hyprgraphics hyprland-qtutils pacman-contrib python-pyamdgpuinfo parallel libnotify"  "Install Dependencies?" "yes"

run_command "yay -S --sudoloop --noconfirm pipewire pipewire-alsa pipewire-audio pipewire-jack pipewire-pulse gst-plugin-pipewire wireplumber pavucontrol pamixer playerctl bluez bluez-utils blueman brightnessctl downgrade trash-cli-git opentabletdriver-git networkmanager network-manager-applet dosfstools"  "Install System?" "yes"

run_command "systemctl enable bluetooth && enable NetworkManager.service" "Enabling Bluetooth & Network Manager" "yes"

run_command "yay -S --sudoloop --noconfirm nwg-look qt5ct qt6ct kvantum kvantum-qt5 qt5-wayland qt6-wayland"  "Install Theming?" "yes"    

run_command "yay -S --sudoloop --noconfirm cozette-otb ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-firacode-nerd ttf-iosevka-nerd ttf-iosevkaterm-nerd ttf-jetbrains-mono-nerd ttf-jetbrains-mono ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono"  "Install Fonts?" "yes" 

run_command "yay -S --sudoloop --noconfirm firewalld python-pyqt5 pythoncapng"  "Install Firewall?" "yes" 

run_command "yay -S --sudoloop --noconfirm amd-ucode mesa mesa-utils lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-mesa-driver libva-util"  "Install Graphics?" "yes" 

run_command "yay -S --sudoloop --noconfirm tar gvfs thunar thunar-volman thunar-archive-plugin file-roller tumbler ffmpegthumbnailer xorg-xrdb"  "Install File Manager? (Thunar)" "yes"

run_command "yay -S --sudoloop --noconfirm flatpak && flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo"  "Install Flatpak?" "yes" 

run_command "yay -S --sudoloop --noconfirm "  "Apply Config?" "yes" 

# Config Rice
run_command "mkdir -p /home/$SUDO_USER/.config && cp -r /home/$SUDO_USER/minimal-hyprland/configs/hypr /home/$SUDO_USER/.config/" "Copy full Hypr config"
run_command "mkdir -p /home/$SUDO_USER/Pictures/Wallpapers/OUT4PIZZA/ && cp -r /home/$SUDO_USER/minimal-hyprland/configs/wallpaper /home/$SUDO_USER/Pictures/Wallpapers/OUT4PIZZA/" "Applying Wallpaper"

run_command "cp -r /home/$SUDO_USER/minimal-hyprland/configs/dunst /home/$SUDO_USER/.config/"
run_command "cp -r /home/$SUDO_USER/minimal-hyprland/configs/waybar /home/$SUDO_USER/.config/"
run_command "cp -r /home/$SUDO_USER/minimal-hyprland/configs/tofi /home/$SUDO_USER/.config/"
run_command "cp -r /home/$SUDO_USER/minimal-hyprland/configs/wlogout /home/$SUDO_USER/.config/"

# Theming
run_command "tar -xvf /home/$SUDO_USER/minimal-hyprland/configs/themes/B00merang-Blackout-master.zip -C /usr/share/themes/" "Install Dark theme"
run_command "tar -xvf /home/$SUDO_USER/minimal-hyprland/configs/icons/BlackoutIcons.zip -C /usr/share/icons/" "Install Dark icon theme"
run_command "tar -xvf /home/$SUDO_USER/minimal-hyprland/configs/icons/KDE-classic.tar.gz -C /usr/share/icons/" "Install KDE Classic cursor"
run_command "mkdir -p /home/$SUDO_USER/.config/qmmp && cp -r /home/$SUDO_USER/minimal-hyprland/configs/themes/qmmp /home/$SUDO_USER/.config/qmmp/" "QMMP Themes"

run_command "cp -r /home/$SUDO_USER/minimal-hyprland/configs/xrvt/.Xresources /home/$SUDO_USER/" "Copy URXVT theme for terminal"

# Add instructions to configure theming
print_info "\nPost-installation instructions:"
print_bold_blue "Set themes and icons:"
echo "   - Run 'nwg-look' and  set the global GTK and icon theme"
echo "   - Open 'kvantummanager' (run with sudo for system-wide changes) to select and apply the themes"
echo "   - Open 'qt6ct' to set the icon theme"

print_bold_blue "\nCongratulations! Your Simple Hyprland setup is complete!"

echo "------------------------------------------------------------------------"
