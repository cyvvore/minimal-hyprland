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
