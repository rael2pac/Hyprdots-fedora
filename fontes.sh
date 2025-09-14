#!/bin/bash

# Instalar Nerd Fonts no Fedora - local user install
set -e

# Lista de fontes a instalar (adicione mais se quiser)
FONTS=("Meslo" "FiraCode" "Hack" "JetBrainsMono")

# Diretório de instalação local
FONT_DIR="$HOME/.local/share/fonts"

# Cria diretório se não existir
mkdir -p "$FONT_DIR"

# Função para instalar uma fonte
install_font() {
    local FONT_NAME="$1"
    local URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.zip"
    
    echo "[*] Baixando $FONT_NAME Nerd Font..."
    
    if curl --output /dev/null --silent --head --fail "$URL"; then
        wget -q --show-progress -O "/tmp/${FONT_NAME}.zip" "$URL"
        unzip -oq "/tmp/${FONT_NAME}.zip" -d "$FONT_DIR"
        rm "/tmp/${FONT_NAME}.zip"
        echo "[✓] Fonte $FONT_NAME instalada."
    else
        echo "[!] Link não encontrado para $FONT_NAME. Pulando..."
    fi
}

# Instala todas as fontes
for FONT in "${FONTS[@]}"; do
    install_font "$FONT"
done

# Atualiza cache de fontes
echo "[*] Atualizando cache de fontes..."
fc-cache -fv "$FONT_DIR"

echo -e "\n[✔] Instalação de fontes concluída com sucesso!"
