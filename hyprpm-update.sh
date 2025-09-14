#!/bin/bash
# Atualizando hyprpm

hyprpm update

echo "Pressione Enter para reiniciar, ou CTRL+C para cancelar."
read -p ""
sudo reboot
