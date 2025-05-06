#!/usr/bin/env bash
set -e

echo -e "\n🔄 [1/10] Atualizando pacotes..."
apt update && apt upgrade -y
apt install -y git curl wget gnome-tweaks gnome-shell-extensions \
               plank conky-all dconf-cli unzip fonts-firacode \
               build-essential libglib2.0-dev-bin || true

# Pastas de temas e ícones
THEMES_DIR="$HOME/.themes"
ICONS_DIR="$HOME/.icons"
mkdir -p "$THEMES_DIR" "$ICONS_DIR"

# Remove diretórios anteriores se existirem
echo -e "\n🧹 Limpando instalações anteriores temporárias..."
rm -rf /tmp/WhiteSur-gtk-theme /tmp/McMojave-icons /tmp/dash-to-dock

# Instala tema WhiteSur
echo -e "\n🎨 [2/10] Instalando tema WhiteSur GTK..."
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git /tmp/WhiteSur-gtk-theme
cd /tmp/WhiteSur-gtk-theme
./install.sh -d "$THEMES_DIR" -t all || echo "⚠️ Erro ao instalar tema GTK. Continuando..."

# Instala ícones McMojave
echo -e "\n🎨 [3/10] Instalando ícones McMojave..."
git clone https://github.com/vinceliuice/McMojave-circle.git /tmp/McMojave-icons
cd /tmp/McMojave-icons
./install.sh -d "$ICONS_DIR" || echo "⚠️ Erro ao instalar ícones. Continuando..."

# Instala Dash to Dock manualmente
echo -e "\n🧩 [4/10] Instalando Dash to Dock..."
git clone https://github.com/micheleg/dash-to-dock.git /tmp/dash-to-dock
cd /tmp/dash-to-dock
make && make install || echo "⚠️ Dash to Dock falhou. Verifique manualmente."

# Configurações visuais
echo -e "\n⚙️ [5/10] Aplicando configurações visuais..."
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-dark" || true
gsettings set org.gnome.desktop.interface icon-theme "McMojave-circle" || true
gsettings set org.gnome.desktop.interface font-name "FiraCode Regular 11" || true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM' || true
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false || true
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false || true
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 36 || true

# Plank como backup
echo -e "\n🚀 [6/10] Configurando Plank dock..."
mkdir -p "$HOME/.config/autostart"
cat > "$HOME/.config/autostart/plank.desktop" <<EOF
[Desktop Entry]
Type=Application
Exec=plank --preferences
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Plank
Comment=MacOS style dock
EOF

# Widgets com Conky
echo -e "\n🖼️ [7/10] Instalando widgets com Conky..."
CONKY_DIR="$HOME/.config/conky"
mkdir -p "$CONKY_DIR"
cat > "$CONKY_DIR/conky.conf" <<EOF
conky.config = {
    alignment = 'top_right',
    background = false,
    double_buffer = true,
    own_window = true,
    own_window_type = 'desktop',
    own_window_transparent = true,
    update_interval = 1,
    default_color = 'white',
    gap_x = 20,
    gap_y = 40,
    use_xft = true,
    font = 'FiraCode:size=10',
};
conky.text = [[
🕒 \${time %H:%M:%S}
💻 CPU: \${cpu cpu0}%
🧠 RAM: \${mem}
💾 Disk: \${fs_used /}
🔋 Battery: \${battery_percent BAT0}%
]];
EOF

cat > "$HOME/.config/autostart/conky.desktop" <<EOF
[Desktop Entry]
Type=Application
Exec=conky -c $HOME/.config/conky/conky.conf
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Conky
Comment=MacOS style widgets
EOF

# Instala Ulauncher
echo -e "\n🔍 [8/10] Instalando Ulauncher..."
add-apt-repository ppa:agornostal/ulauncher -y || true
apt update && apt install -y ulauncher || echo "⚠️ Ulauncher não pôde ser instalado."

# Limpeza
echo -e "\n🧼 [9/10] Limpando arquivos temporários..."
rm -rf /tmp/WhiteSur-gtk-theme /tmp/McMojave-icons /tmp/dash-to-dock

# Finalização
echo -e "\n✅ [10/10] Instalação finalizada com sucesso!"
echo -e "🔁 Reinicie sua sessão GNOME ou o sistema para aplicar as alterações. 🍏"
