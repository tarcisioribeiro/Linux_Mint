cat cleanup.sh
#!/bin/bash

set -e

echo "========================================="
echo " Limpeza de logs e arquivos temporários"
echo " Data: $(date)"
echo "========================================="

# Verifica se está rodando como root
if [[ "$EUID" -ne 0 ]]; then
  echo "❌ Este script deve ser executado como root."
  exit 1
fi

echo
echo "🧹 Limpando diretórios temporários..."

rm -rf /tmp/*
rm -rf /var/tmp/*

echo "✔ Diretórios temporários limpos."

echo
echo "🧾 Limpando logs antigos..."

# Limpa logs rotacionados e comprimidos
find /var/log -type f \( -name "*.gz" -o -name "*.old" -o -name "*.1" \) -delete

# Zera logs ativos (mantém arquivos e permissões)
find /var/log -type f -exec truncate -s 0 {} \;

echo "✔ Logs limpos."

echo
echo "🧹 Limpando cache do sistema..."

# Cache do apt (Debian/Ubuntu)
if command -v apt >/dev/null 2>&1; then
  apt clean
fi

# Cache do dnf (Fedora)
if command -v dnf >/dev/null 2>&1; then
  dnf clean all
fi

# Cache do pacman (Arch)
if command -v pacman >/dev/null 2>&1; then
  pacman -Sc --noconfirm
fi

echo "✔ Cache de pacotes limpo."

echo
echo "🗑 Limpando journal do systemd (logs com mais de 7 dias)..."

if command -v journalctl >/dev/null 2>&1; then
  journalctl --vacuum-time=7d
fi

echo "✔ Journal limpo."

echo
echo "✅ Limpeza concluída com sucesso!"
echo "========================================="
