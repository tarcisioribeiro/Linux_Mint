#!/usr/bin/env bash

set -e

echo "=== Setup de GPG para GitHub ==="
echo

# ============================
# DADOS DO USUÁRIO
# ============================

read -rp "Nome (ex: Tarcísio): " GPG_NAME
read -rp "Email (MESMO do GitHub): " GPG_EMAIL

KEY_TYPE="RSA"
KEY_LENGTH="4096"
EXPIRE_DATE="0"

echo
echo "Gerando chave GPG..."
echo

# ============================
# GERAR CHAVE GPG (BATCH)
# ============================

cat >gpg_batch <<EOF
Key-Type: RSA
Key-Length: ${KEY_LENGTH}
Subkey-Type: RSA
Subkey-Length: ${KEY_LENGTH}
Name-Real: ${GPG_NAME}
Name-Email: ${GPG_EMAIL}
Expire-Date: ${EXPIRE_DATE}
%commit
EOF

gpg --batch --full-generate-key gpg_batch
rm -f gpg_batch

echo
echo "Chave gerada com sucesso."
echo

# ============================
# OBTER KEY ID
# ============================

KEY_ID=$(gpg --list-secret-keys --keyid-format=long "${GPG_EMAIL}" |
  awk '/sec/{print $2}' |
  cut -d'/' -f2)

if [[ -z "$KEY_ID" ]]; then
  echo "Erro: não foi possível obter o Key ID."
  exit 1
fi

echo "Key ID detectado: $KEY_ID"
echo

# ============================
# CONFIGURAR GIT
# ============================

git config --global user.name "$GPG_NAME"
git config --global user.email "$GPG_EMAIL"
git config --global user.signingkey "$KEY_ID"
git config --global commit.gpgsign true

echo "Git configurado para assinar commits."
echo

# ============================
# CORRIGIR GPG_TTY
# ============================

export GPG_TTY=$(tty)

SHELL_RC=""
if [[ -n "$BASH_VERSION" ]]; then
  SHELL_RC="$HOME/.bashrc"
elif [[ -n "$ZSH_VERSION" ]]; then
  SHELL_RC="$HOME/.zshrc"
fi

if [[ -n "$SHELL_RC" ]] && ! grep -q "GPG_TTY" "$SHELL_RC"; then
  echo 'export GPG_TTY=$(tty)' >>"$SHELL_RC"
  echo "GPG_TTY adicionado a $SHELL_RC"
fi

echo

# ============================
# EXPORTAR CHAVE PÚBLICA
# ============================

echo "=== CHAVE PÚBLICA GPG ==="
echo "Copie tudo abaixo e cole em:"
echo "https://github.com/settings/keys"
echo

gpg --armor --export "$KEY_ID"

echo
echo "=== FIM ==="
echo "Faça um commit para testar:"
echo "git commit -m \"Commit assinado com GPG\""
