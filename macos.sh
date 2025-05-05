#!/bin/bash
set -euo pipefail

LOGFILE="$HOME/setup-macos-sequoia.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "🚀 Iniciando personalização para macOS Sequoia..."

run_or_warn() {
    if ! "$@"; then
        echo "⚠️  Aviso: comando falhou: $*"
    fi
}

# 1) Atualizar sistema
echo "1) Atualizando sistema..."
sudo apt update && sudo apt upgrade -y

# 2) Instalar dependências
echo "2) Instalando dependências..."
sudo apt install -y \
    git curl unzip gnome-tweaks gnome-shell-extensions \
    plank dconf-cli fonts-cantarell fonts-firacode \
    sassc libglib2.0-dev libxml2-utils imagemagick

# 3) Tema GTK WhiteSur
echo "3) Instalando/atualizando tema GTK WhiteSur..."
WS_GTK_DIR="$HOME/.local/share/themes/WhiteSur"
TMP_GTK="/tmp/WhiteSur-gtk-theme"
[ -d "$TMP_GTK" ] && rm -rf "$TMP_GTK"
if [ -d "$WS_GTK_DIR" ]; then
    echo "   → Tema já existe: atualizando repositório..."
    git -C "$WS_GTK_DIR" pull --ff-only || true
    "$WS_GTK_DIR/install.sh" || true
else
    echo "   → Clonando repositório e instalando..."
    git clone --depth=1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git "$TMP_GTK"
    "$TMP_GTK/install.sh" || true
    mkdir -p "$WS_GTK_DIR"   # Cria o diretório de destino
    mv "$TMP_GTK" "$WS_GTK_DIR"  # Move o diretório para o destino correto
fi

# 4) Ícones WhiteSur
echo "4) Instalando/atualizando ícones WhiteSur..."
WS_ICONS_DIR="$HOME/.local/share/icons/WhiteSur"
TMP_ICONS="/tmp/WhiteSur-icon-theme"
[ -d "$TMP_ICONS" ] && rm -rf "$TMP_ICONS"
if [ -d "$WS_ICONS_DIR" ]; then
    echo "   → Ícones já existem: atualizando repositório..."
    git -C "$WS_ICONS_DIR" pull --ff-only || true
    "$WS_ICONS_DIR/install.sh" || true
else
    echo "   → Clonando repositório e instalando..."
    git clone --depth=1 https://github.com/vinceliuice/WhiteSur-icon-theme.git "$TMP_ICONS"
    "$TMP_ICONS/install.sh" || true
    mkdir -p "$WS_ICONS_DIR"   # Cria o diretório de destino
    mv "$TMP_ICONS"/* "$WS_ICONS_DIR"  # Move os ícones para o diretório correto
fi

# 5) Cursores WhiteSur
echo "5) Instalando/atualizando cursores WhiteSur..."
WS_CURSOR_DIR="$HOME/.local/share/icons/WhiteSur-cursors"
TMP_CUR="/tmp/WhiteSur-cursors"
[ -d "$TMP_CUR" ] && rm -rf "$TMP_CUR"
if [ -d "$WS_CURSOR_DIR" ]; then
    echo "   → Cursores já existem: atualizando repositório..."
    git -C "$WS_CURSOR_DIR" pull --ff-only || true
    "$WS_CURSOR_DIR/install.sh" || true
else
    echo "   → Clonando repositório e instalando..."
    git clone --depth=1 https://github.com/vinceliuice/WhiteSur-cursors.git "$TMP_CUR"
    "$TMP_CUR/install.sh" || true
    mv "$TMP_CUR" "$WS_CURSOR_DIR"
fi

# 6) Fontes San Francisco
echo "6) Instalando fontes San Francisco..."
FONTS_DIR="$HOME/.local/share/fonts/SF-Pro"
if [ -d "$FONTS_DIR" ]; then
    echo "   → Fontes já instaladas, pulando."
else
    mkdir -p "$FONTS_DIR"
    curl -Lo /tmp/SF-Pro-Display.zip https://github.com/supermarin/YosemiteSanFranciscoFont/archive/master.zip
    unzip /tmp/SF-Pro-Display.zip -d "$FONTS_DIR"
    rm /tmp/SF-Pro-Display.zip
    fc-cache -fv
fi

# 7) Configurar GNOME
echo "7) Configurando GNOME..."
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur"                          || echo "⚠️ Não foi possível aplicar tema GTK"
gsettings set org.gnome.desktop.interface icon-theme "WhiteSur"                         || echo "⚠️ Não foi possível aplicar ícones"
gsettings set org.gnome.desktop.interface cursor-theme "WhiteSur"                       || echo "⚠️ Não foi possível aplicar cursor"
gsettings set org.gnome.shell.extensions.user-theme name "WhiteSur"                     || echo "⚠️ Não foi possível ativar shell theme"

# 8) Extensões GNOME
echo "8) Ativando extensões GNOME..."
run_or_warn gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
run_or_warn gnome-extensions enable dash-to-dock@micxgx.gmail.com

# 9) Ajustes Dash-to-Dock
echo "9) Ajustando Dash-to-Dock..."
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 48
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.20

# 10) Configurar Plank
echo "10) Configurando Plank..."
PLANK_CONF="$HOME/.config/plank/docks/dock1.conf"
mkdir -p "$(dirname "$PLANK_CONF")"
cat > "$PLANK_CONF" <<EOF
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
mkdir -p ~/.config/autostart
cp /etc/xdg/autostart/plank.desktop ~/.config/autostart/ || echo "⚠️ Não foi possível copiar plank.desktop"

# 11) Wallpaper Sequoia
echo "11) Definindo wallpaper Sequoia..."
WALLPAPER="$HOME/Pictures/Sequoia.jpg"
if [ -f "$WALLPAPER" ]; then
    echo "   → Wallpaper já existe, pulando download."
else
    mkdir -p ~/Pictures
    curl -Lo "$WALLPAPER" https://raw.githubusercontent.com/vinceliuice/WhiteSur-gtk-theme/master/screenshot/sequoia-wallpaper.jpg
fi
gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER" || echo "⚠️ Não foi possível aplicar wallpaper"

echo "✅ Instalação concluída! Veja '$LOGFILE' para detalhes. Faça logout/login (ou reinicie) para aplicar as mudanças."
