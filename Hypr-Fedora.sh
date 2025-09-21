#!/bin/bash
# Fedora pós-instalação Hyprland + RPM Fusion/Multimedia - By Rael
# Script completo com COPR, SDDM, sensores e extração de configs

set -e

SCRIPT_DIR=$(dirname "$(realpath "$0")")

pause() { sleep 5; }

retry_install() {
    package=$1
    for i in {1..3}; do
        if sudo dnf install -y "$package"; then
            echo "$package instalado com sucesso."
            break
        else
            echo "Erro ao instalar $package. Tentativa $i de 3..."
            pause
        fi
    done
}

echo "Configurando Fedora para iniciar em modo gráfico..."
sudo systemctl set-default graphical.target
pause

#echo "Adicionando repositórios RPM Fusion (Free/Non-Free + Multimedia)..."
sudo dnf install \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf install \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
#pause

echo "Habilitando COPR..."
sudo dnf copr enable -y solopasha/hyprland
pause

packages=(
    hyprland waypaper swaylock-effects swww wlogout grimblast nwg-look fish gnome-software hyprland-devel
    adw-gtk3-theme network-manager-applet pavucontrol ffmpegthumbnailer easyeffects hyprpolkitagent pamixer
    xdg-desktop-portal-wlr xdg-user-dirs xdg-user-dirs-gtk bluez bluez-tools blueman vlc plasma-breeze
    btop sddm dolphin dolphin-plugins kde-cli-tools gnome-calculator papers loupe satty menulibre 
    gnome-text-editor gnome-calendar ark qt6-qtwebengine-devel waybar mate-polkit firefox wget git gnome-disk-utility fastfetch pciutils qt5ct qt6ct-kde
    git wget
)

echo "Instalando pacotes principais..."
for pkg in "${packages[@]}"; do
    retry_install "$pkg"
done

echo "Configurando sensores de temperatura..."
sudo dnf install -y lm_sensors
sudo sensors-detect <<< $'\n\n\n\n\n\n\n\n'
sudo systemctl restart lm_sensors

echo "Habilitando SDDM..."
sudo systemctl enable sddm.service

echo "Executando atualizações do xdg-user-dirs..."
xdg-user-dirs-gtk-update
xdg-user-dirs-update

# Baixar Wallpapers.zip se ainda não existir
if [ -f "$SCRIPT_DIR/wallpaper.sh" ]; then
    echo "Executando wallpaper.sh para baixar Wallpapers.zip..."
    bash "$SCRIPT_DIR/wallpaper.sh"
else
    echo "wallpaper.sh não encontrado em $SCRIPT_DIR"
fi

echo "Extraindo config.zip..."
pause
if [ -f "$SCRIPT_DIR/config.zip" ]; then
    unzip -o "$SCRIPT_DIR/config.zip" -d "$HOME/.config"
    echo "Arquivo config.zip extraído para ~/.config com sucesso."
else
    echo "config.zip não encontrado."
fi

echo "Extraindo Wallpapers.zip..."
pause
if [ -f "$SCRIPT_DIR/Wallpapers.zip" ]; then
    unzip -o "$SCRIPT_DIR/Wallpapers.zip" -d "$HOME/Imagens"
    echo "Arquivo Wallpapers.zip extraído para ~/Imagens com sucesso."
else
    echo "Wallpapers.zip não encontrado."
fi

echo "Instalação Fedora Hyprland concluída!"
pause

# --- Executar fontes.sh se existir ---
if [ -f "$SCRIPT_DIR/fontes.sh" ]; then
    echo "Executando fontes.sh..."
    bash "$SCRIPT_DIR/fontes.sh"
    echo "fontes.sh concluído."
else
    echo "fontes.sh não encontrado em $SCRIPT_DIR"
fi

# --- Executar simple-sddm-2.sh se existir ---
if [ -f "$SCRIPT_DIR/simple-sddm-2.sh" ]; then
    echo "Executando simple-sddm-2.sh..."
    bash "$SCRIPT_DIR/simple-sddm-2.sh"
    echo "simple-sddm-2.sh concluído."
else
    echo "simple-sddm-2.sh não encontrado em $SCRIPT_DIR"
fi

# Corrigindo waypaper
if [ -f "$SCRIPT_DIR/fix_swww.sh" ]; then
    echo "Executando fix_swww.sh..."
    bash "$SCRIPT_DIR/fix_swww.sh"
else
    echo "fix_swww.sh não encontrado em $SCRIPT_DIR"
fi

# --- Executar hyprpm-update.sh se existir ---
if [ -f "$SCRIPT_DIR/hyprpm-update.sh" ]; then
    echo "Executando hyprpm-update.sh..."
    bash "$SCRIPT_DIR/hyprpm-update.sh"
    echo "hyprpm-update.sh concluído."
else
    echo "hyprpm-update.sh não encontrado em $SCRIPT_DIR"
fi


echo "Pressione Enter para reiniciar, ou CTRL+C para cancelar."
read -p ""
sudo reboot
