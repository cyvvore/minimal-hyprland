#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/helper.sh"

USER_HOME="$(eval echo ~${SUDO_USER})"

log_message "Installation started for prerequisites section"
print_info "\nStarting prerequisites setup..."

# Ensure core tools
run_command "sudo pacman -Syyu --noconfirm" "Update system"
run_command "sudo pacman -S --noconfirm --needed git pkgfile unzip wget base-devel" "Install base tools"

# Install YAY if missing
run_command "sudo -u $SUDO_USER bash -c 'git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay'" "Install YAY"

# Hyprland & Essentials
run_command "sudo -u $SUDO_USER yay -S --sudoloop --noconfirm \
  hyprland dunst tofi waybar-cava cava swww wlogout grimblast-git slurp grim cliphist \
  hyprlock hypridle hyprpicker" "Install Hyprland & Essentials"

# Install SDDM
run_command "sudo pacman -S --noconfirm \
  sddm qt5-quickcontrols qt5-quickcontrols2 qt5-graphicaleffects qt5-svg" "Install Display Manager"

# Portal & Hypr tools
run_command "sudo -u $SUDO_USER yay -S --sudoloop --noconfirm \
  libportal libportal-gtk3 libportal-gtk4 xdg-desktop-portal-gtk xdg-desktop-portal-hyprland \
  hyprpolkitagent hyprcursor hyprutils hyprgraphics hyprland-qtutils" "Install Portals & Hypr Tools"

# Audio
run_command "sudo pacman -S --noconfirm \
  pipewire pipewire-alsa pipewire-audio pipewire-pulse gst-plugin-pipewire wireplumber \
  pavucontrol pamixer playerctl" "Install Audio Stack"

#Bluetooth & Network
run_command "sudo pacman -S --noconfirm \
  bluez bluez-utils blueman brightnessctl \
  networkmanager network-manager-applet \
  dosfstools" "Install Bluetooth & Network"

# System Utilities
run_command "sudo -u $SUDO_USER yay -S --sudoloop --noconfirm  rxvt-unicode \
  libnotify dim-screen tar \
  gvfs thunar thunar-volman thunar-archive-plugin file-roller tumbler ffmpegthumbnailer xorg-xrdb" "Install System Utilities"

# Theming Utilities
run_command "sudo pacman -S --noconfirm \
  nwg-look qt5ct qt6ct kvantum kvantum-qt5 qt5-wayland qt6-wayland" "Install Theming Utilities"

# Fonts
run_command "sudo -u $SUDO_USER yay -S --sudoloop --noconfirm \
  cozette-otb ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-fira-code ttf-fira-mono ttf-fira-sans \
  ttf-firacode-nerd ttf-iosevka-nerd ttf-iosevkaterm-nerd ttf-jetbrains-mono-nerd ttf-jetbrains-mono \
  ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono" "Install Fonts"

# AMD Drivers
run_command "sudo -u $SUDO_USER yay -S --sudoloop --noconfirm \
  amd-ucode mesa mesa-utils lib32-mesa \
  vulkan-radeon lib32-vulkan-radeon \
  libva-utils" 'Install AMD Graphics Drivers'

# Firewall
run_command "sudo pacman -S --noconfirm firewalld python-pyqt5" "Install Firewall"  


# Flatpak setup
run_command "sudo pacman -S --noconfirm flatpak" "Install Flatpak"
run_command "flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo" "Add Flathub Remote"

# Enable services
run_command "sudo systemctl enable sddm.service" "Enable SDDM"
run_command "sudo systemctl enable bluetooth && sudo systemctl enable NetworkManager.service" "Enable Bluetooth & NetworkManager"

# Apply SDDM Theme from local backup
run_command "echo 'Applying WarGames SDDM theme from local archive...'" "Prepare Theme"

THEME_ARCHIVE="/home/$SUDO_USER/minimal-hyprland/configs/themes/WarGames.tar.gz"
THEME_NAME="WarGames"
THEME_DEST="/usr/share/sddm/themes/$THEME_NAME"

# Unpack the theme
run_command "sudo mkdir -p \"$THEME_DEST\"" "Create Theme Destination"
run_command "sudo tar -xzf \"$THEME_ARCHIVE\" -C /usr/share/sddm/themes/" "Extract Theme Archive"

# Install fonts if present
run_command "mkdir -p \"/home/$SUDO_USER/.local/share/fonts\"" "Create Font Directory"
run_command "find \"/usr/share/sddm/themes/$THEME_NAME\" -maxdepth 1 -iname '*.ttf' -exec cp -v {} \"/home/$SUDO_USER/.local/share/fonts/\" \;" "Copy Theme Fonts"
run_command "fc-cache -f" "Rebuild Font Cache"

# Apply SDDM configuration
run_command "bash -c 'echo -e \"[Theme]\nCurrent=$THEME_NAME\n\n[General]\nNumlock=on\" | sudo tee /etc/sddm.conf > /dev/null'" "Write SDDM Config"


# Copy config files
run_command "mkdir -p /home/$SUDO_USER/.config"
run_command "cp -rv /home/$SUDO_USER/minimal-hyprland/configs/hypr /home/$SUDO_USER/.config/" "Hyprland theming"
run_command "cp -rv /home/$SUDO_USER/minimal-hyprland/configs/dunst /home/$SUDO_USER/.config/" "Dunst theming"
run_command "cp -rv /home/$SUDO_USER/minimal-hyprland/configs/waybar /home/$SUDO_USER/.config/" "Waybar theming"
run_command "cp -rv /home/$SUDO_USER/minimal-hyprland/configs/tofi /home/$SUDO_USER/.config/" "Tofi theming"
run_command "cp -rv /home/$SUDO_USER/minimal-hyprland/configs/wlogout /home/$SUDO_USER/.config/" "Wlogout theming"
run_command "cp -rv /home/$SUDO_USER/minimal-hyprland/configs/nwg-wrapper /home/$SUDO_USER/.config/" "nwg-wrapper scripts"

run_command "mkdir -p /home/$SUDO_USER/Pictures/Wallpapers/OUT4PIZZA"
run_command "cp -rv /home/$SUDO_USER/minimal-hyprland/configs/wallpaper /home/$SUDO_USER/Pictures/Wallpapers/OUT4PIZZA/" "Applying Wallpaper"

# Themes and icons
run_command "mkdir -p /usr/share/themes /usr/share/icons"
run_command "unzip /home/$SUDO_USER/minimal-hyprland/configs/themes/B00merang-Blackout-master.zip -d /usr/share/themes/" "GTK Theme"
run_command "unzip /home/$SUDO_USER/minimal-hyprland/configs/icons/BlackoutIcons.zip -d /usr/share/icons/" "Icon Theme"
run_command "tar -xvf /home/$SUDO_USER/minimal-hyprland/configs/icons/KDE-classic.tar.gz -C /usr/share/icons/" "Cursor Theme"

# QMMP
run_command "mkdir -p /home/$SUDO_USER/.config/qmmp"
run_command "cp -rv /home/$SUDO_USER/minimal-hyprland/configs/themes/qmmp /home/$SUDO_USER/.config/qmmp/" "QMMP Theming"

# URXVT
run_command "cp -rv /home/$SUDO_USER/minimal-hyprland/configs/xrvt/.Xresources  /home/$SUDO_USER/" "URXVT colors"

# Theming instructions
print_info "\nPost-installation instructions:"
print_bold_blue "Set themes and icons:"
echo "   - Run 'nwg-look' and set GTK + icon themes"
echo "   - Open 'kvantummanager' (with sudo for system-wide) to apply themes"
echo "   - Open 'qt6ct' to set the icon theme"

print_bold_blue "\n Congratulations! Your Simple Hyprland setup is complete!"
echo "------------------------------------------------------------------------"

