#!/bin/bash

set -e

echo "🚀 Iniciando personalização para macOS Sequoia..."

# 1) Atualizar sistema
sudo apt update && sudo apt upgrade -y

# 2) Instalar ferramentas de customização
sudo apt install -y \
    git curl unzip gnome-tweaks gnome-shell-extensions \
    plank dconf-cli fonts-cantarell fonts-firacode

# 3) Baixar e instalar tema GTK WhiteSur (base para Sequoia)
cd /tmp
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme
./install.sh --tweaks --theme Sequoia
cd ..
rm -rf WhiteSur-gtk-theme

# 4) Baixar e instalar ícones Sequoia
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme
./install.sh --tweaks --icon Sequoia
cd ..
rm -rf WhiteSur-icon-theme

# 5) Instalar cursor macOS
git clone https://github.com/vinceliuice/WhiteSur-cursors.git
cd WhiteSur-cursors
./install.sh --tweaks
cd ..
rm -rf WhiteSur-cursors

# 6) Instalar fontes Apple macOS
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -Lo SF-Pro-Display.zip https://github.com/supermarin/YosemiteSanFranciscoFont/archive/master.zip
unzip master.zip && rm master.zip
fc-cache -fv
cd ~

# 7) Configurar GNOME Shell e tema
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur Sequoia"
gsettings set org.gnome.desktop.interface icon-theme "WhiteSur Sequoia"
gsettings set org.gnome.desktop.interface cursor-theme "WhiteSur"
gsettings set org.gnome.shell.extensions.user-theme name "WhiteSur Sequoia"

# 8) Ativar extensões úteis
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable dash-to-dock@micxgx.gmail.com

# 9) Ajustar Dash-to-Dock para ficar parecido com o macOS
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 48
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true
gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor false
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.20

# 10) Configurar Plank (Dock independente)
mkdir -p ~/.config/plank/docks
cat > ~/.config/plank/docks/dock1.conf <<EOF
[PlankDockPreferences]
Alignment=Center
AutoHide=1
HideDelay=0
IconSize=48
MultiMonitor=0
OffsetX=0
OffsetY=0
Theme=WhiteSur
EOF

# 11) Autostart do Plank
mkdir -p ~/.config/autostart
cp /etc/xdg/autostart/plank.desktop ~/.config/autostart/

# 12) Definir wallpaper Sequoia
curl -Lo ~/Pictures/Sequoia.jpg https://raw.githubusercontent.com/vinceliuice/WhiteSur-gtk-theme/master/screenshot/sequoia-wallpaper.jpg
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Pictures/Sequoia.jpg"

echo "✅ Instalação concluída! Faça logout/login (ou reinicie) para ver todas as mudanças."
