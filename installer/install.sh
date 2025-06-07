#!/bin/bash

# -------PREREQUISITES---------
# Update System
run_command "sudo pacman -Syyu --noconfirm" "Update system"

# Install YAY 
run_command "sudo -u $SUDO_USER bash -c 'pacman -S --noconfirm --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg --noconfirm -si'" "Install YAY"

# Install Fonts
run_command "pacman -S --noconfirm ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-firacode-nerd ttf-iosevka-nerd ttf-iosevkaterm-nerd ttf-jetbrains-mono-nerd ttf-jetbrains-mono ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono" "Installing Fonts & Symbols"

# Installing Bitmap Font
run_command "sudo -u $SUDO_USER yay -S --sudoloop --noconfirm cozette-otb" "Install Bitmap Font"

# Audio
run_command "sudo pacman -S --noconfirm pipewire pipewire-alsa pipewire-audio pipewire-pulse gst-plugin-pipewire wireplumber pavucontrol pamixer playerctl" "Install Audio"

# AMD Drivers
run_command "sudo -u $SUDO_USER yay -S --sudoloop --noconfirm amd-ucode mesa mesa-utils lib32-mesa vulkan-radeon lib32-vulkan-radeon libva-utils" "Install AMD Graphics Drivers"

#Bluetooth & Network
run_command "sudo pacman -S --noconfirm bluez bluez-utils blueman networkmanager network-manager-applet dosfstools" "Install Bluetooth & Network"

# Enable Bluetooth & Network
run_command "sudo systemctl enable bluetooth && sudo systemctl enable NetworkManager.service" "Enable Bluetooth & NetworkManager"

# SDDM Dependencies
run_command "sudo pacman -S --noconfirm brightnessctl qt5-quickcontrols qt5-quickcontrols2 qt5-graphicaleffects qt5-svg" "Install SDDM Dependencies"

# Install & Enable SDDM
run_command "pacman -S --noconfirm sddm && systemctl enable sddm.service" "Install & Enabble SDDM"

# Install Terminal
run_command "pacman -S --noconfirm rxvt-unicode kitty" "Install Terminal"

# Install Core tools
run_command "pacman -S --noconfirm tar unzip" "Install Core tools"



# -----HYPRLAND---------

# Install Hyprland
run_command "pacman -S --noconfirm hyprland hyprlock hypridle hyprpicker hyprpolkitagent hyprcursor hyprutils hyprgraphics hyprland-qtutils xdg-desktop-portal-hyprland" "Install Hyprland & Hyprland Ecosystem"

# Polkit Agents
run_command "sudo -u $SUDO_USER yay -S --sudoloop --noconfirm \
  libportal libportal-gtk3 libportal-gtk4 xdg-desktop-portal-gtk" "Polkit Agents"

#QT Support on Wayland
run_command "sudo pacman -S --noconfirm \ qt5ct qt6ct kvantum kvantum-qt5 qt5-wayland qt6-wayland" "Install Theming Utilities"

# Utilities
run_command "sudo -u $SUDO_USER yay -S --sudoloop --noconfirm dim-screen \ nwg-look swww grimblast-git slurp grim cliphist libnotify xorg-xrdb" "Install Utilities"


# -----SYSTEM UTILITIES-------

# Waybar
run_command "sudo -u $SUDO_USER yay -S --sudoloop --noconfirm waybar-cava cava" "Install Waybar"

# Dunst
run_command "pacman -S --noconfirm dunst" "Install Dunst"

# Tofi
run_command "sudo -u $SUDO_USER yay -S --sudoloop --noconfirm tofi" "Install Tofi"

# Wlogout
run_command "sudo -u $SUDO_USER yay -S --sudoloop --noconfirm wlogout" "Install Wlogout"

# File Manager
run_command "sudo -u $SUDO_USER yay -S --sudoloop --noconfirm gvfs thunar thunar-volman thunar-archive-plugin file-roller tumbler ffmpegthumbnailer xorg-xrdb" "Install Thunar"

# Firewall
run_command "sudo pacman -S --noconfirm firewalld python-pyqt5" "Install Firewall"  


# -----APPS-------

# Flatpak setup
run_command "sudo pacman -S --noconfirm flatpak" "Install Flatpak"
run_command "sudo -u $SUDO_USER flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo" "Add Flathub Remote for User"


# -----THEMING-------

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
REPO_DIR="/home/$SUDO_USER/minimal-hyprland"
USER_HOME="/home/$SUDO_USER"

run_command "mkdir -p $USER_HOME/.config"
run_command "cp -rv $REPO_DIR/configs/hypr $USER_HOME/.config/" "Hyprland theming"
run_command "cp -rv $REPO_DIR/configs/dunst $USER_HOME/.config/" "Dunst theming"
run_command "cp -rv $REPO_DIR/configs/waybar $USER_HOME/.config/" "Waybar theming"
run_command "cp -rv $REPO_DIR/configs/tofi $USER_HOME/.config/" "Tofi theming"
run_command "cp -rv $REPO_DIR/configs/wlogout $USER_HOME/.config/" "Wlogout theming"
run_command "cp -rv $REPO_DIR/configs/nwg-wrapper $USER_HOME/.config/" "nwg-wrapper scripts"

# Wallpaper
run_command "mkdir -p $USER_HOME/Pictures/Wallpapers/OUT4PIZZA"
run_command "cp -rv $REPO_DIR/configs/wallpaper $USER_HOME/Pictures/Wallpapers/OUT4PIZZA/" "Applying Wallpaper"

# Themes and icons
run_command "mkdir -p /usr/share/themes /usr/share/icons"
run_command "unzip $REPO_DIR/configs/themes/B00merang-Blackout-master.zip -d /usr/share/themes/" "GTK Theme"
run_command "unzip $REPO_DIR/configs/icons/BlackoutIcons.zip -d /usr/share/icons/" "Icon Theme"
run_command "tar -xvf $REPO_DIR/configs/icons/KDE-classic.tar.gz -C /usr/share/icons/" "Cursor Theme"

# QMMP
run_command "mkdir -p $USER_HOME/.config/qmmp"
run_command "cp -rv $REPO_DIR/configs/themes/qmmp $USER_HOME/.config/qmmp/" "QMMP Theming"

# URXVT
run_command "cp -rv $REPO_DIR/configs/xrvt/.Xresources $USER_HOME/" "URXVT colors"

# Fix File Ownership
run_command "chown -R $SUDO_USER:$SUDO_USER $USER_HOME" "Fix file ownership"

# -----END-------

# Theming instructions
print_info "\nPost-installation instructions:"
print_bold_blue "Set themes and icons:"
echo "   - Run 'nwg-look' and set GTK + icon themes"
echo "   - Open 'kvantummanager' (with sudo for system-wide) to apply themes"
echo "   - Open 'qt6ct' to set the icon theme"

print_bold_blue "\n Congratulations! Your Simple Hyprland setup is complete!"
echo "------------------------------------------------------------------------"


