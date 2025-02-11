#!/bin/bash

echo "Removendo pacotes Snap..."
sudo snap list | awk 'NR>1 {print $1}' | xargs -I {} snap remove {}

echo "Desativando e removendo o serviço snapd..."
sudo systemctl stop snapd.service
sudo systemctl disable snapd.service
sudo systemctl mask snapd.service

echo "Removendo o snapd e pacotes relacionados..."
sudo apt purge -y snapd
sudo apt autoremove -y
sudo apt clean

echo "Removendo diretórios do Snap..."
sudo rm -rf ~/snap
sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd
sudo rm -rf /var/cache/snapd

echo "Removendo perfis do AppArmor relacionados ao Snap..."
sudo rm -rf /etc/apparmor.d/*snap*

echo "Atualizando AppArmor..."
sudo systemctl restart apparmor

echo "Snap removido com sucesso!"
