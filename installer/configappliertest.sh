# Copy config files
mkdir -p "$HOME/.config"
cp -rv "$HOME/minimal-hyprland/configs/hypr" "$HOME/.config/"
cp -rv "$HOME/minimal-hyprland/configs/dunst" "$HOME/.config/"
cp -rv "$HOME/minimal-hyprland/configs/waybar" "$HOME/.config/"
cp -rv "$HOME/minimal-hyprland/configs/tofi" "$HOME/.config/"
cp -rv "$HOME/minimal-hyprland/configs/wlogout" "$HOME/.config/"
cp -rv "$HOME/minimal-hyprland/configs/nwg-wrapper" "$HOME/.config/"

mkdir -p "$HOME/Pictures/Wallpapers/OUT4PIZZA"
cp -rv "$HOME/minimal-hyprland/configs/wallpaper" "$HOME/Pictures/Wallpapers/OUT4PIZZA/"

# Themes and icons
sudo mkdir -p /usr/share/themes /usr/share/icons
sudo unzip "$HOME/minimal-hyprland/configs/themes/B00merang-Blackout-master.zip" -d /usr/share/themes/
sudo unzip "$HOME/minimal-hyprland/configs/icons/BlackoutIcons.zip" -d /usr/share/icons/
sudo tar -xvf "$HOME/minimal-hyprland/configs/icons/KDE-classic.tar.gz" -C /usr/share/icons/

# QMMP and terminal themes
mkdir -p "$HOME/.config/qmmp"
cp -rv "$HOME/minimal-hyprland/configs/themes/qmmp" "$HOME/.config/qmmp/"
cp -rv "$HOME/minimal-hyprland/configs/xrvt/.Xresources" "$HOME/"


/home/dove/Downloads/minimal-hyprland/configs/dunst
