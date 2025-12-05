#!/usr/bin/bash
set -euo pipefail

msg_color() {
  echo -e "\n\033[$1m$2\033[0m\n"
  sleep 1
}

msg_color "34" "Iniciando correção de dependências..."

# Step 1: Update package lists
msg_color "33" "[1/5] Atualizando lista de pacotes..."
sudo apt-get update

# Step 2: Fix broken packages
msg_color "33" "[2/5] Corrigindo pacotes quebrados..."
sudo apt-get install -f -y

# Step 3: Configure pending packages
msg_color "33" "[3/5] Configurando pacotes pendentes..."
sudo dpkg --configure -a

# Step 4: Clean package cache
msg_color "33" "[4/5] Limpando cache de pacotes..."
sudo apt-get clean
sudo apt-get autoclean

# Step 5: Upgrade system with automatic conflict resolution
msg_color "33" "[5/5] Atualizando sistema..."
sudo apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

msg_color "32" "Correção de dependências concluída!"
msg_color "33" "Agora você pode tentar executar o script de instalação novamente."
