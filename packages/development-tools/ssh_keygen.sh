#!/usr/bin/bash
sudo apt update
sudo apt upgrade
sudo apt install nala toilet curl wget git build-essential neofetch htop
ssh-keygen -t ed25519 -C "tarcisio.ribeiro.1840@hotmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
echo "" && sleep 2
echo "Agora, adicione a sua chave SSH ao Github."
read -r -p "Presssione ENTER para prosseguir."
sleep 2
echo "Realizando teste de conexão..." && sleep 2
ssh -T -p 443 git@ssh.github.com
