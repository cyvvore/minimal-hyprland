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
if ! command -v yay &>/dev/null; then
  run_command "git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay" "Install YAY"
else
  log_message "YAY already installed."
fi

# Enable multilib
enable_multilib() {
  if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "[multilib] repo added to pacman.conf"
  elif grep -q "^#\[multilib\]" /etc/pacman.conf; then
    sudo sed -i '/^\[multilib\]/,/^Include/ s/^#//' /etc/pacman.conf
    echo "[multilib] repo uncommented"
  else
    echo "[multilib] repo already enabled"
  fi

  sudo pacman -Sy --noconfirm
}

run_command "enable_multilib" "Enable multilib repo"


# Hyprland & Essentials
run_command "yay -S --sudoloop --noconfirm \
  hyprland dunst tofi waybar-cava cava swww wlogout grimblast-git slurp grim cliphist \
  hyprlock hypridle hyprpicker" "Install Hyprland & Essentials"

# Install SDDM
run_command "sudo pacman -S --noconfirm \
  sddm qt5-quickcontrols qt5-quickcontrols2 qt5-graphicaleffects qt5-svg" "Install Display Manager"

# Portal & Hypr tools
run_command "yay -S --sudoloop --noconfirm \
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
run_command "yay -S --sudoloop --noconfirm \
  libnotify dim-screen tar \
  gvfs thunar thunar-volman thunar-archive-plugin file-roller tumbler ffmpegthumbnailer xorg-xrdb" "Install System Utilities"

# Theming Utilities
run_command "sudo pacman -S --noconfirm \
  nwg-look qt5ct qt6ct kvantum kvantum-qt5 qt5-wayland qt6-wayland" "Install Theming Utilities"

# Fonts
run_command "yay -S --sudoloop --noconfirm \
  cozette-otb ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-fira-code ttf-fira-mono ttf-fira-sans \
  ttf-firacode-nerd ttf-iosevka-nerd ttf-iosevkaterm-nerd ttf-jetbrains-mono-nerd ttf-jetbrains-mono \
  ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono" "Install Fonts"

# AMD Drivers
run_command "yay -S --sudoloop --noconfirm \
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

# Apply SDDM Theme
echo "Downloading WarGames theme..."
wget -O wargames-sddm.zip "https://github.com/vinceliuice/Wargus-sddm/releases/download/2024-02-07/Wargus-sddm.zip"
unzip -q wargames-sddm.zip -d wargames-theme
THEME_DIR="wargames-theme/Wargus"
mkdir -p "$USER_HOME/.local/share/fonts"
find "$THEME_DIR" -maxdepth 1 -iname "*.ttf" -exec cp -v {} "$USER_HOME/.local/share/fonts/" \;
fc-cache -f
sudo mkdir -p /usr/share/sddm/themes
sudo cp -r "$THEME_DIR" /usr/share/sddm/themes/Wargus

# Apply SDDM configuration with theme and fixes
sudo tee /etc/sddm.conf > /dev/null <<EOF
[Theme]
Current=Wargus

[General]
Numlock=on
EOF

# Fix ownership of theme, fonts, and config
sudo chown -R "$SUDO_USER":"$SUDO_USER" "$USER_HOME/.local"
sudo chown -R "$SUDO_USER":"$SUDO_USER" "$USER_HOME/.config"
fc-cache -f

# Ensure Hyprland session file is present
sudo mkdir -p /usr/share/wayland-sessions
sudo tee /usr/share/wayland-sessions/hyprland.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
DesktopNames=Hyprland
EOF

# Copy config files
mkdir -p "$USER_HOME/.config"
cp -r "$USER_HOME/minimal-hyprland/configs/hypr" "$USER_HOME/.config/"
cp -r "$USER_HOME/minimal-hyprland/configs/dunst" "$USER_HOME/.config/"
cp -r "$USER_HOME/minimal-hyprland/configs/waybar" "$USER_HOME/.config/"
cp -r "$USER_HOME/minimal-hyprland/configs/tofi" "$USER_HOME/.config/"
cp -r "$USER_HOME/minimal-hyprland/configs/wlogout" "$USER_HOME/.config/"
cp -r "$USER_HOME/minimal-hyprland/configs/nwg-wrapper" "$USER_HOME/.config/"

mkdir -p "$USER_HOME/Pictures/Wallpapers/OUT4PIZZA"
cp -r "$USER_HOME/minimal-hyprland/configs/wallpaper" "$USER_HOME/Pictures/Wallpapers/OUT4PIZZA/"

# Themes and icons
sudo mkdir -p /usr/share/themes /usr/share/icons
sudo unzip "$HOME/minimal-hyprland/configs/themes/B00merang-Blackout-master.zip" -d /usr/share/themes/
sudo unzip "$HOME/minimal-hyprland/configs/icons/BlackoutIcons.zip" -d /usr/share/icons/
sudo tar -xvf "$HOME/minimal-hyprland/configs/icons/KDE-classic.tar.gz" -C /usr/share/icons/

# QMMP and terminal themes
mkdir -p "$USER_HOME/.config/qmmp"
cp -r "$USER_HOME/minimal-hyprland/configs/themes/qmmp" "$USER_HOME/.config/qmmp/"
cp -r "$USER_HOME/minimal-hyprland/configs/xrvt/.Xresources" "$USER_HOME/"

# Theming instructions
print_info "\nPost-installation instructions:"
print_bold_blue "Set themes and icons:"
echo "   - Run 'nwg-look' and set GTK + icon themes"
echo "   - Open 'kvantummanager' (with sudo for system-wide) to apply themes"
echo "   - Open 'qt6ct' to set the icon theme"

print_bold_blue "\n Congratulations! Your Simple Hyprland setup is complete!"
echo "------------------------------------------------------------------------"

